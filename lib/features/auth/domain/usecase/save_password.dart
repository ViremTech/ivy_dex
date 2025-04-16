import 'package:ivy_dex/core/usecase/usecase.dart';
import 'package:ivy_dex/features/auth/domain/entities/auth_entity.dart';
import 'package:ivy_dex/features/auth/domain/repo/auth_repo.dart';

class SavePassword implements Usecase<void, PasswordEntity> {
  final AuthRepo repo;

  SavePassword({required this.repo});
  @override
  Future<void> call(PasswordEntity password) {
    return repo.savePassword(password);
  }
}
