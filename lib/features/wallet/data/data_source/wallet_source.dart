import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ivy_dex/features/wallet/domain/entities/account_entity.dart';
import 'package:bip39/bip39.dart' as bip39;
import '../../domain/entities/total_balance_entity.dart';

abstract class WalletLocalDataSource {
  Future<void> saveEncryptedMnemonic();
  Future<String> getEncryptedMnemonic();
  String generateMnemonic();
  // Future<void> savePassword(String password);
  // Future<String> getPassword();

  Future<void> saveAccounts(List<AccountEntity> accounts);
  Future<List<AccountEntity>> getAccounts();

  Future<void> setActiveAccount(AccountEntity account);
  Future<AccountEntity> getActiveAccount();

  Future<void> addTokenToAccount(
    AccountEntity account,
    String contractAddress,
    String symbol,
    int decimals,
  );

  Future<List<TokenBalanceEntity>> getTokenBalances(AccountEntity account);
}

class WalletLocalDataSourceImpl implements WalletLocalDataSource {
  final FlutterSecureStorage storage;

  static const _mnemonicKey = 'wallet_mnemonic';
  // static const _passwordKey = 'wallet_password';
  static const _accountsKey = 'wallet_accounts';
  static const _activeAccountKey = 'active_account';
  static const _tokenPrefix = 'tokens_for_';

  WalletLocalDataSourceImpl({required this.storage});

  @override
  String generateMnemonic() {
    return bip39.generateMnemonic();
  }

  @override
  Future<void> saveEncryptedMnemonic() async {
    final mnemonicPhrase = generateMnemonic();
    final encrypted = _simpleEncrypt(
      mnemonicPhrase,
      'MyPassWord1234',
    );
    await storage.write(key: _mnemonicKey, value: encrypted);
  }

  @override
  Future<String> getEncryptedMnemonic() async {
    final value = await storage.read(key: _mnemonicKey);
    if (value == null) throw Exception("Mnemonic not found");
    return value;
  }

  // @override
  // Future<void> savePassword(String password) async {
  //   await storage.write(key: _passwordKey, value: password);
  // }

  // @override
  // Future<String> getPassword() async {
  //   final value = await storage.read(key: _passwordKey);
  //   if (value == null) throw Exception("Password not found");
  //   return value;
  // }

  @override
  Future<void> saveAccounts(List<AccountEntity> accounts) async {
    final jsonString = jsonEncode(accounts.map((e) => e.toJson()).toList());
    await storage.write(key: _accountsKey, value: jsonString);
  }

  @override
  Future<List<AccountEntity>> getAccounts() async {
    final jsonString = await storage.read(key: _accountsKey);
    if (jsonString == null) return [];
    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((e) => AccountEntity.fromJson(e)).toList();
  }

  @override
  Future<void> setActiveAccount(AccountEntity account) async {
    final jsonString = jsonEncode(account.toJson());
    await storage.write(key: _activeAccountKey, value: jsonString);
  }

  @override
  Future<AccountEntity> getActiveAccount() async {
    final jsonString = await storage.read(key: _activeAccountKey);
    if (jsonString == null) throw Exception("No active account found");
    return AccountEntity.fromJson(jsonDecode(jsonString));
  }

  @override
  Future<void> addTokenToAccount(
    AccountEntity account,
    String contractAddress,
    String symbol,
    int decimals,
  ) async {
    final key = '$_tokenPrefix${account.address}';
    final existing = await storage.read(key: key);
    List<TokenBalanceEntity> tokens = [];
    if (existing != null) {
      final List<dynamic> jsonList = jsonDecode(existing);
      tokens = jsonList.map((e) => TokenBalanceEntity.fromJson(e)).toList();
    }

    final newToken = TokenBalanceEntity(
      symbol: symbol,
      contractAddress: contractAddress,
      decimals: decimals,
      balance: 0.0,
    );

    tokens.add(newToken);
    await storage.write(
        key: key, value: jsonEncode(tokens.map((e) => e.toJson()).toList()));
  }

  @override
  Future<List<TokenBalanceEntity>> getTokenBalances(
      AccountEntity account) async {
    final key = '$_tokenPrefix${account.address}';
    final jsonString = await storage.read(key: key);
    if (jsonString == null) return [];
    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((e) => TokenBalanceEntity.fromJson(e)).toList();
  }
}

String _simpleEncrypt(String input, String password) {
  final bytes = input.codeUnits;
  final encrypted = List.generate(
      bytes.length, (i) => bytes[i] ^ password.codeUnitAt(i % password.length));
  return base64.encode(encrypted);
}
