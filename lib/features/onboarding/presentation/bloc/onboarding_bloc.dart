import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ivy_dex/core/usecase/usecase.dart';

import '../../domain/usecase/check_onboarding_status.dart';
import '../../domain/usecase/complete_onboarding.dart';

part 'onboarding_event.dart';
part 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final CompleteOnboarding completeOnboarding;
  final CheckOnboardingStatus checkOnboardingStatus;

  OnboardingBloc(
      {required this.completeOnboarding, required this.checkOnboardingStatus})
      : super(OnboardingInitial()) {
    on<LoadOnboardingStatus>((event, emit) async {
      final hasCompleted = await checkOnboardingStatus(NoParam());
      if (hasCompleted) {
        emit(OnboardingCompleted());
      } else {
        emit(OnboardingNotCompleted());
      }
    });

    on<CompleteOnboardingEvent>((event, emit) async {
      await completeOnboarding(
        event.value,
      );
      emit(OnboardingCompleted());
    });
  }
}
