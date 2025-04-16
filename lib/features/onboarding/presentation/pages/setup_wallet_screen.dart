import 'package:flutter/material.dart';
import 'package:ivy_dex/features/wallet/presentation/pages/import_seed.dart';
import '../../../../core/constants/color.dart';
import '../../../../core/widgets/button_widget.dart';
import '../../../auth/presentation/pages/create_password.dart';

class SetUpWalletScreen extends StatelessWidget {
  const SetUpWalletScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  bottom: 50.0, left: 45, top: 80, right: 45),
              child: Image.asset('assets/images/image 1.png'),
            ),
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Text(
                    'Create portfolio of different assets',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Track the best cryptos and coins of your choice for trading. The best crypto coins out there are here on Blockto',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  ButtonWidget(
                    onTap: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ImportSeedScreen(),
                        ),
                      );
                    },
                    text: 'Import Using Seed Phrase',
                    color: ksecondaryColor,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ButtonWidget(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreatePassWordScreen(),
                        ),
                      );
                    },
                    text: 'Create A New Wallet',
                    color: kPrimaryColor,
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
