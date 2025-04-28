import 'package:ivy_dex/core/usecase/usecase.dart';
import 'package:ivy_dex/features/add_coin_to_wallet/domain/repo/token_repo.dart';

import '../../../wallet/domain/entities/account_entity.dart';
import '../entities/token_balance.dart';

class GetTokenBalanceUsecase
    implements
        Usecase<List<TokenBalanceEntity>, AccountAndGetAccountTokenParams> {
  final TokenRepo tokenRepo;

  GetTokenBalanceUsecase({required this.tokenRepo});

  @override
  Future<List<TokenBalanceEntity>> call(
      AccountAndGetAccountTokenParams params) async {
    final account = AccountEntity(
        index: params.accountEntityParam.index,
        address: params.accountEntityParam.address,
        privateKey: params.accountEntityParam.privateKey);

    return await tokenRepo.getTokenBalances(
        account: account, networkId: params.getAccountTokenParams.networkId);
  }
}
