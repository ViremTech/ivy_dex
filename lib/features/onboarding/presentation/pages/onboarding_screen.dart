import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ivy_dex/features/onboarding/presentation/pages/setup_wallet_screen.dart';

import 'package:ivy_dex/features/onboarding/presentation/widgets/onboarding_pages_widget.dart';

import '../bloc/onboarding_bloc.dart';
import '../widgets/onboarding_page_two.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController _pageController;
  int _currentPage = 0;
  final int _totalPages = 2;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: Duration(
          milliseconds: 300,
        ),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  void _goToSetUpWalletScreen(String value) {
    context.read<OnboardingBloc>().add(CompleteOnboardingEvent(value: value));

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SetUpWalletScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    String value = 'true';
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            PageView(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              children: [
                OnboardingPagesOne(
                  heading: 'Buy The Best Crypto in The Market',
                  subHeading:
                      'Track the best cryptos and coins of your choice for trading. The best crypto coins out there are here on Blockto',
                  imageUrl: 'assets/images/Group 12.png',
                  onTapToContinue: _nextPage,
                  onTapToSkip: () {
                    _goToSetUpWalletScreen(value);
                  },
                ),
                OnboardingPagesTwo(
                  heading: 'Buy The Best Crypto in The Market',
                  subHeading:
                      'Track the best cryptos and coins of your choice for trading. The best crypto coins out there are here on Blockto',
                  imageUrl: 'assets/images/3.png',
                  onTapToContinue: () {
                    _goToSetUpWalletScreen(value);
                  },
                ),
              ],
            ),
            Positioned(
              top: 15,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(height: 2, width: 160, color: Colors.white),
                  Container(
                    height: 2,
                    width: 160,
                    color: _currentPage == 1 || _currentPage == 2
                        ? Colors.white
                        : Colors.grey[800],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
