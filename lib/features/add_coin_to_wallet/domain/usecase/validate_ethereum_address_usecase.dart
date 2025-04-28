import '../../../../core/usecase/usecase.dart';
import '../../data/repository_impl/token_repo.dart';
import '../repo/token_repo.dart';

class ValidateEthereumAddressParams {
  final String address;

  ValidateEthereumAddressParams({
    required this.address,
  });
}

class ValidateEthereumAddressUseCase
    implements Usecase<bool, ValidateEthereumAddressParams> {
  final TokenRepo tokenRepo;

  ValidateEthereumAddressUseCase(this.tokenRepo);

  @override
  Future<bool> call(ValidateEthereumAddressParams params) async {
    if (tokenRepo is TokenRepoImpl) {
      return (tokenRepo as TokenRepoImpl)
          .isValidEthereumAddress(params.address);
    }
    // Fallback validation if the repo doesn't implement the method
    try {
      // Basic Ethereum address validation (0x followed by 40 hex characters)
      final RegExp ethereumAddressRegExp = RegExp(r'^0x[a-fA-F0-9]{40}$');
      return ethereumAddressRegExp.hasMatch(params.address);
    } catch (_) {
      return false;
    }
  }
}
