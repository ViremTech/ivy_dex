import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ivy_dex/core/bloc/wallet_init_bloc/wallet_init_bloc.dart';
import 'package:ivy_dex/features/auth/presentation/pages/login_screen.dart';
import 'package:ivy_dex/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:ivy_dex/features/onboarding/presentation/pages/onboarding_screen.dart';
import 'package:ivy_dex/features/onboarding/presentation/pages/setup_wallet_screen.dart';

class InitScreen extends StatefulWidget {
  const InitScreen({super.key});

  @override
  State<InitScreen> createState() => _InitScreenState();
}

class _InitScreenState extends State<InitScreen> {
  bool _onboardingChecked = false;

  @override
  void initState() {
    super.initState();
    context.read<OnboardingBloc>().add(LoadOnboardingStatus());
  }

  void _handleOnboardingCompleted() {
    if (!_onboardingChecked) {
      _onboardingChecked = true;
      context.read<WalletInitBloc>().add(CheckSeedPhraseStatus());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<OnboardingBloc, OnboardingState>(
          listener: (context, state) {
            if (state is OnboardingNotCompleted) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const OnboardingScreen()),
              );
            } else if (state is OnboardingCompleted) {
              _handleOnboardingCompleted(); // Only then check wallet status
            }
          },
        ),
        BlocListener<WalletInitBloc, WalletInitState>(
          listener: (context, state) {
            if (state is WalletNeedsSetup) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const SetUpWalletScreen()),
              );
            } else if (state is WalletReady) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            }
          },
        ),
      ],
      child: const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
