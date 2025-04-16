import 'package:ivy_dex/core/usecase/usecase.dart';

import '../repo/onBoarding_repo.dart';

class CheckOnboardingStatus implements Usecase<bool, NoParam> {
  final OnboardingRepository repo;
  CheckOnboardingStatus(this.repo);
  @override
  Future<bool> call(NoParam params) {
    return repo.hasCompletedOnboarding();
  }
}
