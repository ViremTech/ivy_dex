import 'package:flutter/material.dart';
import 'package:ivy_dex/features/auth/presentation/pages/create_password.dart';
import 'package:ivy_dex/features/wallet/presentation/pages/secure_wallet.dart';

class CreateWallet extends StatefulWidget {
  const CreateWallet({super.key});

  @override
  State<CreateWallet> createState() => _CreateWalletState();
}

class _CreateWalletState extends State<CreateWallet> {
  late PageController _pageController;
  int _currentPage = 0;
  final int _totalPages = 3;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void goToNextPage() {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void goToPreviousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            physics: NeverScrollableScrollPhysics(),
            children: [
              CreatePassWordScreen(),
              SecureWallet(),
              // ConfirmSeed(),
            ],
          ),
          Positioned(
            top: 15,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(height: 2, width: 103, color: Colors.white),
                Container(
                  height: 2,
                  width: 103,
                  color: _currentPage == 1 || _currentPage == 2
                      ? Colors.white
                      : Colors.grey[800],
                ),
                Container(
                  height: 2,
                  width: 103,
                  color: _currentPage == _totalPages - 1
                      ? Colors.white
                      : Colors.grey[800],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
