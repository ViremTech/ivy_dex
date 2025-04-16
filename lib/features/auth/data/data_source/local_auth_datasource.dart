import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class LocalAuthDatasource {
  Future<void> savePassword(String password);
  Future<bool> validatePassword(String password);
  Future<bool> deletePassword();
}

class LocalAuthDatasourceImpl implements LocalAuthDatasource {
  final storage = FlutterSecureStorage();
  final _key = 'wallet_password';
  @override
  Future<void> savePassword(String password) async {
    final hashed = sha256.convert(utf8.encode(password)).toString();
    await storage.write(key: _key, value: hashed);
  }

  @override
  Future<bool> validatePassword(String password) async {
    final storedHash = await storage.read(key: _key);
    final inputHash = sha256
        .convert(
          utf8.encode(password),
        )
        .toString();
    return storedHash == inputHash;
  }

  @override
  Future<bool> deletePassword() async {
    await storage.delete(key: _key);
    return (await storage.read(key: _key)) == null;
  }

  Future<bool> persistLoginState(String isLoadedIn) async {
    await storage.write(
      key: 'isLoggedIn',
      value: isLoadedIn,
    );
    final isLoggedIn = await storage.read(key: 'isLoggedIn');
    return isLoggedIn == 'true';
  }
}
