import 'dart:convert';
import 'package:bip39/bip39.dart' as bip39;
import 'package:hex/hex.dart';
import 'package:web3dart/web3dart.dart';
import 'package:bip32/bip32.dart' as bip32;

import 'package:ivy_dex/features/wallet/domain/entities/account_entity.dart';

import 'package:ivy_dex/features/wallet/domain/repo/wallet_repo.dart';
import 'package:ivy_dex/features/wallet/data/data_source/wallet_source.dart';

import '../../../add_coin_to_wallet/domain/entities/token_balance.dart';

class WalletRepoImpl implements WalletRepository {
  final WalletLocalDataSource localDataSource;

  WalletRepoImpl({required this.localDataSource});

  @override
  Future<AccountEntity> deriveAccountFromMnemonic(
      String mnemonic, int index) async {
    final seed = bip39.mnemonicToSeed(mnemonic);
    final root = bip32.BIP32.fromSeed(seed);
    final path = "44'/60'/0'/0/$index";
    final child = root.derivePath(path);

    if (child.privateKey == null) throw Exception('Private key is null');

    final privateKeyHex = HEX.encode(child.privateKey!);
    final ethKey = EthPrivateKey.fromHex(privateKeyHex);
    final address = ethKey.address;

    return AccountEntity(
      index: index,
      address: address.hexEip55,
      privateKey: privateKeyHex,
    );
  }

  @override
  Future<String> getSavedMnemonic() async {
    final encrypted = await localDataSource.getEncryptedMnemonic();
    // final password = await localDataSource.getPassword();
    return _simpleDecrypt(encrypted);
  }

  @override
  Future<List<AccountEntity>> getAllAccounts() {
    return localDataSource.getAccounts();
  }

  @override
  Future<void> setActiveAccount(AccountEntity account) async {
    await localDataSource.setActiveAccount(account);
  }

  @override
  Future<AccountEntity> getActiveAccount() {
    return localDataSource.getActiveAccount();
  }

  // @override
  // Future<void> addTokenToAccount({
  //   required AccountEntity account,
  //   required String contractAddress,
  //   required String symbol,
  //   required int decimals,
  // }) async {
  //   await localDataSource.addTokenToAccount(
  //       account, contractAddress, symbol, decimals);
  // }

  @override
  Future<List<TokenBalanceEntity>> getTokenBalances(
      AccountEntity account) async {
    // You should integrate this with an API (e.g. Moralis, Alchemy) or local node
    return await localDataSource.getTokenBalances(account);
  }

  @override
  Future<double> getTotalBalance(AccountEntity account) async {
    final balances = await getTokenBalances(account);
    double total = 0.0;
    for (final token in balances) {
      total += token.balance;
    }
    return total;
  }

  // === Private Helpers ===

  String _simpleDecrypt(String encoded) {
    String password = 'MyPassWord1234';
    final xor = base64.decode(encoded);
    final decrypted = List.generate(
        xor.length, (i) => xor[i] ^ password.codeUnitAt(i % password.length));
    return String.fromCharCodes(decrypted);
  }

  @override
  Future<void> saveMnemonic() async {
    await localDataSource.saveEncryptedMnemonic();
  }
}
