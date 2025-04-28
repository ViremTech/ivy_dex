import 'package:ivy_dex/core/usecase/usecase.dart';
import 'package:ivy_dex/features/add_coin_to_wallet/domain/repo/token_repo.dart';

import '../../../wallet/domain/entities/account_entity.dart';

class RemoveTokenUsecase implements Usecase<void, AccountAndRemoveTokenParam> {
  final TokenRepo tokenRepo;

  RemoveTokenUsecase({required this.tokenRepo});

  @override
  Future<void> call(AccountAndRemoveTokenParam params) async {
    final account = AccountEntity(
        index: params.accountParam.index,
        address: params.accountParam.address,
        privateKey: params.accountParam.privateKey);
    await tokenRepo.removeTokenFromAccount(
        account: account,
        contractAddress: params.removeTokenParam.contractAddress,
        networkId: params.removeTokenParam.networkId);
  }
}

class AccountAndRemoveTokenParam {
  final AccountEntityParam accountParam;
  final RemoveTokenParam removeTokenParam;

  AccountAndRemoveTokenParam(
      {required this.accountParam, required this.removeTokenParam});
}

class RemoveTokenParam {
  final String contractAddress;
  final int networkId;

  RemoveTokenParam({required this.contractAddress, required this.networkId});
}
