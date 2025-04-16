import '../../domain/repo/onBoarding_repo.dart';
import '../data_source/onboarding_local_data_source.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  final OnboardingLocalDataSource localDataSource;

  OnboardingRepositoryImpl(this.localDataSource);

  @override
  Future<void> completeOnboarding(String value) {
    return localDataSource.setOnboardingComplete(value);
  }

  @override
  Future<bool> hasCompletedOnboarding() {
    return localDataSource.isOnboardingComplete();
  }
}
