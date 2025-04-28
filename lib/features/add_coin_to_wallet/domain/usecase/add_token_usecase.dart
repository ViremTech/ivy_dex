import 'package:ivy_dex/core/usecase/usecase.dart';
import 'package:ivy_dex/features/add_coin_to_wallet/domain/repo/token_repo.dart';
import 'package:ivy_dex/features/wallet/domain/entities/account_entity.dart';

class AddTokenUsecase implements Usecase<void, AddTokenUsecaseParams> {
  final TokenRepo tokenRepo;

  AddTokenUsecase({required this.tokenRepo});

  @override
  Future<void> call(AddTokenUsecaseParams params) async {
    final account = AccountEntity(
        index: params.accountParams.index,
        address: params.accountParams.address,
        privateKey: params.accountParams.privateKey);
    await tokenRepo.addTokenToAccount(
        account: account,
        contractAddress: params.tokenParams.contractAddress,
        symbol: params.tokenParams.symbol,
        name: params.tokenParams.name,
        decimals: params.tokenParams.decimals,
        networkId: params.tokenParams.networkId);
  }
}

class AddTokenUsecaseParams {
  final AddTokenParams tokenParams;
  final AccountEntityParam accountParams;

  AddTokenUsecaseParams({
    required this.tokenParams,
    required this.accountParams,
  });
}

class AddTokenParams {
  final String contractAddress;
  final String symbol;
  final String name;
  final int decimals;
  final String? logoUrl;
  final int networkId;

  AddTokenParams({
    required this.contractAddress,
    required this.symbol,
    required this.name,
    required this.decimals,
    this.logoUrl,
    required this.networkId,
  });
}
