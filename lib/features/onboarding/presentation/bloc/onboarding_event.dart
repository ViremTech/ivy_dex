part of 'onboarding_bloc.dart';

abstract class OnboardingEvent {}

class LoadOnboardingStatus extends OnboardingEvent {}

class CompleteOnboardingEvent extends OnboardingEvent {
  String value;
  CompleteOnboardingEvent({
    required this.value,
  });
}
