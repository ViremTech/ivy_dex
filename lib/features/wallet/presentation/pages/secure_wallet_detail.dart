import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ivy_dex/core/constants/color.dart';
import 'package:ivy_dex/core/widgets/button_widget.dart';
import 'package:ivy_dex/features/wallet/presentation/bloc/wallet_bloc.dart';

import 'seed_phrase.dart';

class SecureWalletDetail extends StatefulWidget {
  const SecureWalletDetail({super.key});

  @override
  State<SecureWalletDetail> createState() => _SecureWalletDetailState();
}

class _SecureWalletDetailState extends State<SecureWalletDetail> {
  FlutterSecureStorage storage = FlutterSecureStorage();
  String? password = '';
  String? _mnemonic;

  @override
  void initState() {
    context.read<WalletBloc>().add(GetSavedMnemonicEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<WalletBloc, WalletState>(
        listener: (context, state) {
          if (state is MnemonicGenerated) {
            _mnemonic = state.mnemonic;

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SeedPhrase(mnemonic: state.mnemonic),
              ),
            );
          }
          if (state is WalletError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.message,
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is WalletLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                      Row(
                        children: [
                          Text(
                            "Secure Your Wallet's",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Text(
                            " seed phrase",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color: kPrimaryColor,
                                ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.blue),
                                borderRadius: BorderRadius.circular(
                                  30,
                                )),
                            child: Icon(
                              Icons.question_mark_outlined,
                              size: 16,
                              color: Colors.blue,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Why is it important?',
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge!
                                .copyWith(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.blue,
                                ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Text(
                        'Write down your seed phrase on a cryptooly of paper and store in a safe place.',
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                              color: Colors.grey,
                            ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        children: [
                          Text(
                            'Password strength: ',
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge!
                                .copyWith(
                                  color: Colors.grey,
                                ),
                          ),
                          Text(
                            'Good',
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge!
                                .copyWith(
                                  color: kSuccessColor,
                                ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Container(
                            width: 32,
                            height: 8,
                            decoration: BoxDecoration(
                              color: kSuccessColor,
                              borderRadius: BorderRadius.circular(
                                3,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Container(
                            width: 32,
                            height: 8,
                            decoration: BoxDecoration(
                              color: kSuccessColor,
                              borderRadius: BorderRadius.circular(
                                3,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Container(
                            width: 32,
                            height: 8,
                            decoration: BoxDecoration(
                              color: kSuccessColor,
                              borderRadius: BorderRadius.circular(
                                3,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Container(
                            width: 32,
                            height: 8,
                            decoration: BoxDecoration(
                              color: kSuccessColor,
                              borderRadius: BorderRadius.circular(
                                3,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        '''
Risks are: 
• You lose it
• You forget where you put it
• Someone else finds it
                  ''',
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                              color: Colors.grey,
                              height: 2,
                            ),
                      ),
                      Text(
                        "Other options: Doesn't have to be paper!,",
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                              color: Colors.grey,
                            ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        '''
Tips:
• Store in bank vault
• Store in a safe
• Store in multiple secret places
                  ''',
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                              color: Colors.grey,
                              height: 2,
                            ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 20,
                    ),
                    child: ButtonWidget(
                      color: kPrimaryColor,
                      text: 'Start',
                      onTap: () {
                        context.read<WalletBloc>().add(DeriveAccountEvent(
                            mnemonic: _mnemonic ?? '', index: 0));
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
