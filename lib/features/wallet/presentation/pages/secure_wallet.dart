import 'package:flutter/material.dart';
import 'package:ivy_dex/features/wallet/presentation/pages/secure_wallet_detail.dart';

import '../../../../core/constants/color.dart';
import '../../../../core/widgets/button_widget.dart';

class SecureWallet extends StatelessWidget {
  const SecureWallet({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Secure Your Wallet',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Image.asset(
                      'assets/images/illus.png',
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Text(
                    "Don't risk losing your funds. protect your wallet by saving your seed phrase in a place you trust. It's the only way to recover your wallet if you get locked out of the app or get a new device.",
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 20,
                ),
                child: Column(
                  children: [
                    ButtonWidget(
                      onTap: () {},
                      text: 'Remind Me Later',
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ButtonWidget(
                      onTap: () {
                        _showModalBottomSheet(context);
                      },
                      text: 'Start',
                      color: kPrimaryColor,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

void _showModalBottomSheet(BuildContext context) {
  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    builder: (context) {
      return FractionallySizedBox(
        heightFactor: 0.7,
        child: Container(
          padding: EdgeInsets.all(26),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "What is a 'Seed phrase'",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                '''
A seed phrase is a set of twelve words that contains all the information about your wallet, including your funds. It's like a secret code used to access your entire wallet.
          
You must keep your seed phrase secret and safe. If someone gets your seed phrase, they'll gain control over your accounts.
          
Save it in a place where only you can access it. If you lose it, not even Cryptooly can help you recover it.    
                ''',
                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
              ),
              SizedBox(
                height: 20,
              ),
              ButtonWidget(
                  color: kPrimaryColor,
                  text: 'I Got It',
                  onTap: () {
                    Navigator.pop(context);
                    _showModalBottomSheetNew(context);
                  })
            ],
          ),
        ),
      );
    },
  );
}

void _showModalBottomSheetNew(BuildContext context) {
  // ignore: no_leading_underscores_for_local_identifiers
  bool _value = false;
  showModalBottomSheet(
      context: context,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.6,
          child: Container(
              padding: EdgeInsets.all(26),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Skip Account Security?',
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Checkbox(
                        value: _value,
                        onChanged: (value) {
                          value = !_value;
                        },
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      Flexible(
                        child: Text(
                          'I understand that if i lose my seed phrase i will not be able to access my wallet',
                          style:
                              Theme.of(context).textTheme.labelLarge!.copyWith(
                                    color: Colors.grey,
                                    fontSize: 16,
                                  ),
                          softWrap: true,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ButtonWidget(
                          color: kPrimaryColor,
                          text: 'Secure Now',
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SecureWalletDetail(),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: ButtonWidget(
                          text: 'Skip',
                          onTap: () {},
                          color: ksecondaryColor,
                        ),
                      ),
                    ],
                  )
                ],
              )),
        );
      });
}
