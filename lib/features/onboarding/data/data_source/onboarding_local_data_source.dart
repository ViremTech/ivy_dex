import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class OnboardingLocalDataSource {
  Future<void> setOnboardingComplete(String value);
  Future<bool> isOnboardingComplete();
}

class OnboardingLocalDataSourceImpl implements OnboardingLocalDataSource {
  final FlutterSecureStorage storage;

  OnboardingLocalDataSourceImpl({required this.storage});

  @override
  Future<void> setOnboardingComplete(String value) async {
    await storage.write(key: 'onboardingComplete', value: value);
  }

  @override
  Future<bool> isOnboardingComplete() async {
    final value = await storage.read(key: 'onboardingComplete');
    return value == 'true';
  }
}
