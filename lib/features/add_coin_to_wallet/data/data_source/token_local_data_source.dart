import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../wallet/domain/entities/account_entity.dart';
import '../../domain/entities/token_balance.dart';
import '../../domain/entities/token_entities.dart';

abstract class TokenLocalDataSource {
  Future<void> addToken(AccountEntity account, TokenEntity token);
  Future<void> removeToken(
      AccountEntity account, String contractAddress, int networkId);
  Future<List<TokenEntity>> getTokens(AccountEntity account, int networkId);
  Future<TokenBalanceEntity> getTokenBalance(
      AccountEntity account, TokenEntity token);
  Future<double> getTokenPrice(String contractAddress, int networkId);
  Future<double> getNativeTokenPrice(int networkId);
}

class TokenLocalDataSourceImpl implements TokenLocalDataSource {
  final FlutterSecureStorage secureStorage;

  TokenLocalDataSourceImpl({required this.secureStorage});

  @override
  Future<void> addToken(AccountEntity account, TokenEntity token) async {
    final tokensKey =
        'tokens_${account.address.toLowerCase()}_${token.networkId}';
    final tokensData = await secureStorage.read(key: tokensKey);
    List<String> tokens = [];

    if (tokensData != null) {
      tokens = List<String>.from(
        jsonDecode(
          tokensData,
        ),
      );
    }

    final existingTokens = tokens.where((t) {
      final Map<String, dynamic> tokenMap = jsonDecode(t);
      return tokenMap['contractAddress'].toString().toLowerCase() ==
          token.contractAddress.toLowerCase();
    });

    if (existingTokens.isNotEmpty) {
      tokens = tokens.where((t) {
        final Map<String, dynamic> tokenMap = jsonDecode(t);
        return tokenMap['contractAddress'].toString().toLowerCase() !=
            token.contractAddress.toLowerCase();
      }).toList();
    }

    final tokenMap = {
      'contractAddress': token.contractAddress,
      'symbol': token.symbol,
      'name': token.name,
      'decimals': token.decimals,
      'logoUrl': token.logoUrl,
      'networkId': token.networkId,
    };

    tokens.add(jsonEncode(tokenMap));
    await secureStorage.write(key: tokensKey, value: jsonEncode(tokens));

    await _saveTokenBalance(account, token, 0.0, 0.0);
  }

  @override
  Future<void> removeToken(
      AccountEntity account, String contractAddress, int networkId) async {
    final tokensKey = 'tokens_${account.address.toLowerCase()}_${networkId}';
    final tokensData = await secureStorage.read(key: tokensKey);
    List<String> tokens = [];

    if (tokensData != null) {
      tokens = List<String>.from(jsonDecode(tokensData));

      tokens = tokens.where((t) {
        final Map<String, dynamic> tokenMap = jsonDecode(t);
        return tokenMap['contractAddress'].toString().toLowerCase() !=
            contractAddress.toLowerCase();
      }).toList();

      await secureStorage.write(key: tokensKey, value: jsonEncode(tokens));
    }
    final balanceKey =
        'balance_${account.address.toLowerCase()}_${contractAddress.toLowerCase()}_$networkId';
    await secureStorage.delete(key: balanceKey);
  }

  @override
  Future<List<TokenEntity>> getTokens(
      AccountEntity account, int networkId) async {
    final tokensKey = 'tokens_${account.address.toLowerCase()}_$networkId';
    final tokensData = await secureStorage.read(key: tokensKey);
    List<String> tokenStrings = [];

    if (tokensData != null) {
      tokenStrings = List<String>.from(jsonDecode(tokensData));
    }

    // Add native token if not present
    bool hasNativeToken = false;
    for (final tokenString in tokenStrings) {
      final tokenMap = jsonDecode(tokenString);
      if (tokenMap['contractAddress'].toString().toLowerCase() == 'native') {
        hasNativeToken = true;
        break;
      }
    }

    if (!hasNativeToken) {
      // Add native token based on networkId
      final nativeToken = _getNativeTokenForNetwork(networkId);
      final nativeTokenMap = {
        'contractAddress': 'native',
        'symbol': nativeToken['symbol'],
        'name': nativeToken['name'],
        'decimals': nativeToken['decimals'],
        'logoUrl': nativeToken['logoUrl'],
        'networkId': networkId,
      };

      tokenStrings.add(jsonEncode(nativeTokenMap));
      await secureStorage.write(
          key: tokensKey, value: jsonEncode(tokenStrings));
    }

    return tokenStrings.map((tokenString) {
      final Map<String, dynamic> map = jsonDecode(tokenString);
      return TokenEntity(
        contractAddress: map['contractAddress'],
        symbol: map['symbol'],
        name: map['name'],
        decimals: map['decimals'],
        logoUrl: map['logoUrl'],
        networkId: map['networkId'],
      );
    }).toList();
  }

  @override
  Future<double> getNativeTokenPrice(int networkId) async {
    return getTokenPrice('native', networkId);
  }

  @override
  Future<TokenBalanceEntity> getTokenBalance(
      AccountEntity account, TokenEntity token) async {
    final balanceKey =
        'balance_${account.address.toLowerCase()}_${token.contractAddress.toLowerCase()}_${token.networkId}';
    final balanceData = await secureStorage.read(key: balanceKey);

    if (balanceData != null) {
      final Map<String, dynamic> balanceMap = jsonDecode(balanceData);
      return TokenBalanceEntity(
        token: token,
        balance: balanceMap['balance'].toDouble(),
        fiatValue: balanceMap['fiatValue'].toDouble(),
      );
    }

    // Return zero balance if not found
    return TokenBalanceEntity(
      token: token,
      balance: 0.0,
      fiatValue: 0.0,
    );
  }

  @override
  Future<double> getTokenPrice(String contractAddress, int networkId) async {
    final priceKey = 'price_${contractAddress.toLowerCase()}_$networkId';
    final priceData = await secureStorage.read(key: priceKey);

    if (priceData != null) {
      final Map<String, dynamic> priceMap = jsonDecode(priceData);
      final lastUpdated =
          DateTime.fromMillisecondsSinceEpoch(priceMap['lastUpdated']);
      final now = DateTime.now();

      // Return cached price if it's less than 15 minutes old
      if (now.difference(lastUpdated).inMinutes < 15) {
        return priceMap['price'].toDouble();
      }
    }

    // In a real implementation, you would fetch the price from an API here
    // For now, return a placeholder price
    final price = _getPlaceholderPrice(contractAddress, networkId);

    // Cache the price
    final priceMap = {
      'price': price,
      'lastUpdated': DateTime.now().millisecondsSinceEpoch,
    };

    await secureStorage.write(
        key: 'price_${contractAddress.toLowerCase()}_$networkId',
        value: jsonEncode(priceMap));

    return price;
  }

  Future<void> _saveTokenBalance(
    AccountEntity account,
    TokenEntity token,
    double balance,
    double fiatValue,
  ) async {
    final balanceKey =
        'balance_${account.address.toLowerCase()}_${token.contractAddress.toLowerCase()}_${token.networkId}';
    final balanceMap = {
      'balance': balance,
      'fiatValue': fiatValue,
      'lastUpdated': DateTime.now().millisecondsSinceEpoch,
    };

    await secureStorage.write(key: balanceKey, value: jsonEncode(balanceMap));
  }

  Map<String, dynamic> _getNativeTokenForNetwork(int networkId) {
    switch (networkId) {
      case 1: // Ethereum Mainnet
        return {
          'symbol': 'ETH',
          'name': 'Ethereum',
          'decimals': 18,
          'logoUrl': 'https://ethereum.org/eth-logo.svg',
        };
      case 56: // Binance Smart Chain
        return {
          'symbol': 'BNB',
          'name': 'Binance Coin',
          'decimals': 18,
          'logoUrl': 'https://binance.com/bnb-logo.svg',
        };
      case 137: // Polygon
        return {
          'symbol': 'MATIC',
          'name': 'Polygon',
          'decimals': 18,
          'logoUrl': 'https://polygon.technology/matic-logo.svg',
        };
      // Add more networks as needed
      default:
        return {
          'symbol': 'ETH',
          'name': 'Ethereum',
          'decimals': 18,
          'logoUrl': 'https://ethereum.org/eth-logo.svg',
        };
    }
  }

  double _getPlaceholderPrice(String contractAddress, int networkId) {
    // In a real app, you would fetch this from an API
    final Map<String, double> placeholderPrices = {
      'native_1': 3500.00, // ETH on Mainnet
      'native_56': 250.00, // BNB on BSC
      'native_137': 0.50, // MATIC on Polygon
      '0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48_1': 1.00, // USDC on Mainnet
      '0xdac17f958d2ee523a2206206994597c13d831ec7_1': 1.00, // USDT on Mainnet
    };

    final key = '${contractAddress.toLowerCase()}_$networkId';
    return placeholderPrices[key] ?? 0.0;
  }
}
