import 'package:ivy_dex/core/usecase/usecase.dart';
import 'package:ivy_dex/features/auth/domain/entities/auth_entity.dart';
import 'package:ivy_dex/features/auth/domain/repo/auth_repo.dart';

class ValidatePassword implements Usecase<bool, PasswordEntity> {
  final AuthRepo authRepo;

  ValidatePassword({required this.authRepo});

  @override
  Future<bool> call(PasswordEntity password) {
    return authRepo.validatePassword(password);
  }
}
