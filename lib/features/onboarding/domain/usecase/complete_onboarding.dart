import 'package:ivy_dex/core/usecase/usecase.dart';

import '../repo/onBoarding_repo.dart';

class CompleteOnboarding implements Usecase<void, String> {
  final OnboardingRepository repo;

  CompleteOnboarding({required this.repo});

  @override
  Future<void> call(String params) {
    return repo.completeOnboarding(params);
  }
}
