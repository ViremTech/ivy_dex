import 'package:ivy_dex/core/usecase/usecase.dart';
import 'package:ivy_dex/features/auth/domain/repo/auth_repo.dart';

class DeletePassword implements Usecase<bool, NoParam> {
  final AuthRepo authRepo;

  DeletePassword({required this.authRepo});
  @override
  Future<bool> call(NoParam params) {
    return authRepo.deletePassword();
  }
}
