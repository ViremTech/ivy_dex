import '../../../../core/usecase/usecase.dart';
import '../repo/token_repo.dart';

class GetTokenPriceParams {
  final String contractAddress;
  final int networkId;

  GetTokenPriceParams({
    required this.contractAddress,
    required this.networkId,
  });
}

class GetTokenPriceUseCase implements Usecase<double, GetTokenPriceParams> {
  final TokenRepo tokenRepo;

  GetTokenPriceUseCase(this.tokenRepo);

  @override
  Future<double> call(GetTokenPriceParams params) async {
    return await tokenRepo.getTokenPrice(
      contractAddress: params.contractAddress,
      networkId: params.networkId,
    );
  }
}
