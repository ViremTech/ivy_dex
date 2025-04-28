import 'package:ivy_dex/core/usecase/usecase.dart';
import 'package:ivy_dex/features/wallet/domain/entities/account_entity.dart';

import 'package:ivy_dex/features/wallet/domain/repo/wallet_repo.dart';

import '../../../add_coin_to_wallet/domain/entities/token_balance.dart';

class AccountParam {
  final AccountEntity account;

  AccountParam(this.account);
}

class GetTokenBalancesUseCase
    implements Usecase<List<TokenBalanceEntity>, AccountParam> {
  final WalletRepository repository;

  GetTokenBalancesUseCase(this.repository);

  @override
  Future<List<TokenBalanceEntity>> call(AccountParam params) async {
    return await repository.getTokenBalances(params.account);
  }
}
