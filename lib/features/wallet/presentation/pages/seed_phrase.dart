import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ivy_dex/core/constants/color.dart';
import 'package:ivy_dex/core/widgets/button_widget.dart';

import 'confirm_seed.dart';

class SeedPhrase extends StatefulWidget {
  final String mnemonic;
  const SeedPhrase({super.key, required this.mnemonic});

  @override
  State<SeedPhrase> createState() => _SeedPhraseState();
}

class _SeedPhraseState extends State<SeedPhrase> {
  bool _showSeed = true;

  void _revealSeed() {
    setState(() {
      _showSeed = !_showSeed;
    });
  }

  @override
  Widget build(BuildContext context) {
    String mySeedPhrase = widget.mnemonic;
    List<String> seedPhrase = mySeedPhrase.split(' ');

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
                    height: 20,
                  ),
                  Text(
                    "This is your seed phrase. Write it down on a paper and keep it in a safe place. You'll be asked to re-enter this phrase (in order) on the next step.",
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          color: Colors.grey,
                        ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            12,
                          ),
                          border: Border.all(
                            style: BorderStyle.solid,
                            color: kPrimaryColor,
                            width: 1,
                          ),
                        ),
                        width: double.infinity,
                        child: Center(
                          child: GridView.builder(
                            shrinkWrap: true,
                            itemCount: seedPhrase.length,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              childAspectRatio: 2.5,
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                              crossAxisCount: 3,
                            ),
                            itemBuilder: (context, index) {
                              return Container(
                                alignment: Alignment.center,
                                child: Text(
                                  seedPhrase[index],
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      if (_showSeed)
                        Positioned.fill(
                          child: GestureDetector(
                            onTap: _revealSeed,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: BackdropFilter(
                                filter:
                                    ImageFilter.blur(sigmaX: 3.5, sigmaY: 3.5),
                                child: Container(
                                  color: Color.fromRGBO(255, 255, 255, 0.2),
                                  alignment: Alignment.center,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.visibility_off,
                                        color: Colors.grey,
                                        size: 40,
                                      ),
                                      SizedBox(height: 12),
                                      Text(
                                        'Tap to reveal your seed phrase',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(height: 6),
                                      Text(
                                        'Make sure no one is watching your screen.',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall,
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: ButtonWidget(
                  color: kPrimaryColor,
                  text: 'Continue',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ConfirmSeed(
                          correctSeed: seedPhrase,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
