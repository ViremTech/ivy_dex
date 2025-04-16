import 'package:ivy_dex/features/auth/data/data_source/local_auth_datasource.dart';
import 'package:ivy_dex/features/auth/domain/entities/auth_entity.dart';
import 'package:ivy_dex/features/auth/domain/repo/auth_repo.dart';

class AuthRepoImpl implements AuthRepo {
  final LocalAuthDatasource datasource;

  AuthRepoImpl({required this.datasource});

  @override
  Future<void> savePassword(PasswordEntity password) {
    return datasource.savePassword(
      password.rawPassword,
    );
  }

  @override
  Future<bool> validatePassword(PasswordEntity password) {
    return datasource.validatePassword(
      password.rawPassword,
    );
  }

  @override
  Future<bool> deletePassword() {
    return datasource.deletePassword();
  }
}
