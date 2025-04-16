import 'package:ivy_dex/features/auth/domain/entities/auth_entity.dart';

abstract class AuthRepo {
  Future<void> savePassword(PasswordEntity password);
  Future<bool> validatePassword(PasswordEntity password);
  Future<bool> deletePassword();
}
