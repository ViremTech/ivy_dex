import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ivy_dex/core/constants/color.dart';
import 'package:ivy_dex/features/wallet/presentation/bloc/wallet_bloc.dart';
import 'package:ivy_dex/features/wallet/presentation/pages/wallet_home.dart';

class ConfirmSeed extends StatefulWidget {
  final List<String> correctSeed;
  const ConfirmSeed({super.key, required this.correctSeed});

  @override
  State<ConfirmSeed> createState() => _ConfirmSeedState();
}

class _ConfirmSeedState extends State<ConfirmSeed> {
  late List<String> _correctSeed;
  late List<int> confirmIndexes;
  late List<String?> userInput;
  late List<bool> isCorrect;
  late List<String> shuffledSeed;

  @override
  void initState() {
    super.initState();
    _correctSeed = widget.correctSeed;
    final rand = Random();
    confirmIndexes = [];

    // Get 3 random indexes to confirm
    while (confirmIndexes.length < 3) {
      int index = rand.nextInt(12);
      if (!confirmIndexes.contains(index)) {
        confirmIndexes.add(index);
      }
    }

    userInput = List.filled(3, null);
    isCorrect = List.filled(3, false);

    // Create a shuffled version of the seed for the selection grid
    shuffledSeed = List<String>.from(_correctSeed);
    shuffledSeed.shuffle();
  }

  // Handle word tap
  void handleWordTap(String word) {
    int emptyIndex = userInput.indexWhere((element) => element == null);
    if (emptyIndex == -1) return; // All slots filled

    setState(() {
      userInput[emptyIndex] = word;
      int confirmAt = confirmIndexes[emptyIndex];
      isCorrect[emptyIndex] = word == _correctSeed[confirmAt];
    });
  }

  void resetInput() {
    setState(() {
      userInput = List.filled(3, null);
      isCorrect = List.filled(3, false);
    });
  }

  bool allCorrect() => isCorrect.every((e) => e);

  @override
  Widget build(BuildContext context) {
    String mnemonic = widget.correctSeed.join(' ');
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Confirm Seed Phrase',
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
              const SizedBox(height: 24),

              // Row for the three confirm boxes side by side
              Row(
                children: List.generate(3, (index) {
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      child: Container(
                        height: 60,
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 16),
                        decoration: BoxDecoration(
                          color: userInput[index] != null
                              ? isCorrect[index]
                                  ? Colors.green.shade100
                                  : Colors.red.shade100
                              : myGreyColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          userInput[index] ?? "${confirmIndexes[index] + 1}.",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 32),

              // Word selection grid
              Expanded(
                child: GridView.count(
                  crossAxisCount: 3,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 2.5,
                  children: shuffledSeed.map((word) {
                    // Disable words that have already been selected
                    bool isSelected = userInput.contains(word);

                    return GestureDetector(
                      onTap: isSelected ? null : () => handleWordTap(word),
                      child: Container(
                        decoration: BoxDecoration(
                          color:
                              isSelected ? Colors.grey.shade300 : myGreyColor,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: kPrimaryColor),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          word,
                          style: TextStyle(
                            color: isSelected ? Colors.grey : Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              // Continue button
              BlocListener<WalletBloc, WalletState>(
                listener: (context, state) {
                  if (state is WalletLoaded) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WalletHome(
                            walletAddress: state.accounts[0].address),
                      ),
                      (Route<dynamic> route) => false,
                    );
                  }
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: ElevatedButton(
                    onPressed: userInput.every((element) => element != null)
                        ? allCorrect()
                            ? () {
                                // Proceed to next step
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Seed phrase confirmed successfully!'),
                                  ),
                                );
                                context.read<WalletBloc>().add(
                                    DeriveAccountEvent(
                                        mnemonic: mnemonic, index: 0));
                              }
                            : () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Incorrect seed phrase. Please try again.'),
                                  ),
                                );
                                resetInput();
                              }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      disabledBackgroundColor: ksecondaryColor,
                      disabledForegroundColor: Colors.white,
                    ),
                    child: const Text(
                      'Continue',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
