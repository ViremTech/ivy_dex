import 'package:flutter/material.dart';

class WalletHome extends StatefulWidget {
  final String walletAddress;
  const WalletHome({super.key, required this.walletAddress});

  @override
  State<WalletHome> createState() => _WalletHomeState();
}

class _WalletHomeState extends State<WalletHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          widget.walletAddress,
        ),
      ),
    );
  }
}
