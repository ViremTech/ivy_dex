import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ivy_dex/core/bloc/auth_bloc/auth_bloc.dart';
import 'package:ivy_dex/core/constants/color.dart';

import 'package:ivy_dex/core/widgets/button_widget.dart';

import 'package:ivy_dex/features/auth/presentation/widgets/password.dart';
import 'package:ivy_dex/features/wallet/presentation/pages/wallet_home.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController passwordController = TextEditingController();
  void _login(String password) {
    context.read<AuthBloc>().add(ValidatePasswordEvent(password: password));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WalletHome(
                  walletAddress: '',
                  privateKey: '',
                  accountIndex: 1,
                  networkId: 1,
                ),
              ),
            );
          }
          if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.message,
                ),
              ),
            );
          }
        },
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SingleChildScrollView(
              child: BlocListener<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is AuthSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Login Succesfully',
                        ),
                      ),
                    );
                  }
                  if (state is AuthFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          state.message,
                        ),
                      ),
                    );
                  }
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Image.asset(
                        'assets/images/Group 12.png',
                      ),
                    ),
                    Text('Welcome Back!',
                        style:
                            Theme.of(context).textTheme.headlineLarge!.copyWith(
                                  fontSize: 32,
                                )),
                    SizedBox(
                      height: 20,
                    ),
                    PasswordField(
                      text: 'Password',
                      suffixIcon: Icon(
                        Icons.visibility,
                      ),
                      onTap: () {},
                      obscureText: false,
                      controller: passwordController,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ButtonWidget(
                      color: kPrimaryColor,
                      text: 'Unlock',
                      onTap: () {
                        _login(
                          passwordController.text.trim(),
                        );
                      },
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Text(
                      "Wallet won't unlock? You can ERASE your current wallet and setup a new one",
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        myDialogBox(context);
                      },
                      child: Text(
                        "Reset Wallet",
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                              color: kPrimaryColor,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void myDialogBox(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Icon(
            Icons.warning_amber,
            color: kErrorColor,
            size: 60,
          ),
          actions: [
            Text(
              'Are you sure you want to erase your wallet?',
              style: Theme.of(context)
                  .textTheme
                  .headlineLarge!
                  .copyWith(color: kErrorColor),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Your current wallet, accounts and assets will be removed from this app permantly, This action cannot be undone.',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'You can ONLY recover this wallet with your Secret Recovery Phrase, We dont have your Secret Recovery Phrase.',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            SizedBox(
              height: 30,
            ),
            ButtonWidget(
              text: 'I understand, continue',
              onTap: () async {
                Navigator.pop(context);
                context.read<AuthBloc>().add(DeletePasswordEvent());
              },
              color: kErrorColor,
            ),
            SizedBox(
              height: 10,
            ),
            BlocListener<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Deleted Succesfully',
                      ),
                    ),
                  );
                }
              },
              child: ButtonWidget(
                text: 'Cancel',
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            )
          ],
        );
      });
}
