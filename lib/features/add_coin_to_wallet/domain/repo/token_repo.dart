import 'package:ivy_dex/features/add_coin_to_wallet/domain/entities/token_balance.dart';
import 'package:ivy_dex/features/add_coin_to_wallet/domain/entities/token_entities.dart';

import '../../../wallet/domain/entities/account_entity.dart';

abstract class TokenRepo {
  Future<void> addTokenToAccount({
    required AccountEntity account,
    required String contractAddress,
    required String symbol,
    required String name,
    required int decimals,
    String? logoUrl,
    required int networkId,
  });

  Future<void> removeTokenFromAccount({
    required AccountEntity account,
    required String contractAddress,
    required int networkId,
  });

  Future<List<TokenEntity>> getAccountTokens({
    required AccountEntity account,
    required int networkId,
  });

  Future<List<TokenBalanceEntity>> getTokenBalances({
    required AccountEntity account,
    required int networkId,
  });

  Future<double> getTokenPrice({
    required String contractAddress,
    required int networkId,
  });
}
