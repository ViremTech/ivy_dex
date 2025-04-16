abstract class OnboardingRepository {
  Future<void> completeOnboarding(String value);
  Future<bool> hasCompletedOnboarding();
}
