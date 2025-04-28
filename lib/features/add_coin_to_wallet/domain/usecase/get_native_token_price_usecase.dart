import '../../../../core/usecase/usecase.dart';
import '../repo/token_repo.dart';

class GetNativeTokenPriceParams {
  final int networkId;

  GetNativeTokenPriceParams({
    required this.networkId,
  });
}

class GetNativeTokenPriceUseCase
    implements Usecase<double, GetNativeTokenPriceParams> {
  final TokenRepo tokenRepo;

  GetNativeTokenPriceUseCase(this.tokenRepo);

  @override
  Future<double> call(GetNativeTokenPriceParams params) async {
    return await tokenRepo.getTokenPrice(
      contractAddress: 'native',
      networkId: params.networkId,
    );
  }
}
