import 'package:ivy_dex/core/usecase/usecase.dart';
import 'package:ivy_dex/features/add_coin_to_wallet/domain/repo/token_repo.dart';
import 'package:ivy_dex/features/wallet/domain/entities/account_entity.dart';

import '../entities/token_entities.dart';

class GetAccountTokensUseCase
    implements Usecase<List<TokenEntity>, AccountAndGetAccountTokenParams> {
  final TokenRepo tokenRepo;

  GetAccountTokensUseCase({required this.tokenRepo});

  @override
  Future<List<TokenEntity>> call(AccountAndGetAccountTokenParams params) async {
    final account = AccountEntity(
        index: params.accountEntityParam.index,
        address: params.accountEntityParam.address,
        privateKey: params.accountEntityParam.privateKey);

    return await tokenRepo.getAccountTokens(
        account: account, networkId: params.getAccountTokenParams.networkId);
  }
}
