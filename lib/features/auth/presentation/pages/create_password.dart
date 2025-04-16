import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ivy_dex/core/bloc/auth_bloc/auth_bloc.dart';

import 'package:ivy_dex/features/auth/presentation/widgets/password.dart';
import 'package:ivy_dex/features/wallet/presentation/pages/secure_wallet.dart';

import '../../../../core/constants/color.dart';
import '../../../../core/widgets/button_widget.dart';

class CreatePassWordScreen extends StatefulWidget {
  const CreatePassWordScreen({
    super.key,
  });

  @override
  State<CreatePassWordScreen> createState() => _CreatePassWordScreenState();
}

class _CreatePassWordScreenState extends State<CreatePassWordScreen> {
  final TextEditingController _newPassWord = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  String _passwordStrength = '';
  bool _passwordsMatch = true;
  bool _obscurePw = false;
  bool _obscureConfrimPw = false;

  @override
  void initState() {
    super.initState();
    _newPassWord.addListener(() {
      final password = _newPassWord.text;
      setState(() {
        _passwordStrength = getPasswordStrength(password);
      });
    });

    _newPassWord.addListener(_checkPasswordMatch);
    _confirmPassword.addListener(_checkPasswordMatch);
  }

  @override
  void dispose() {
    _newPassWord.removeListener(_checkPasswordMatch);
    _confirmPassword.removeListener(_checkPasswordMatch);
    _newPassWord.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  String getPasswordStrength(String password) {
    if (password.isEmpty) return '';

    bool hasUppercase = password.contains(RegExp(r'[A-Z]'));
    bool hasDigits = password.contains(RegExp(r'[0-9]'));
    bool hasLowercase = password.contains(RegExp(r'[a-z]'));
    bool hasSpecialCharacters = password.contains(RegExp(r'[_!@#\$&*~]'));
    bool hasMinLength = password.length >= 8;

    int strength = 0;
    if (hasDigits) strength++;
    if (hasUppercase) strength++;
    if (hasLowercase) strength++;
    if (hasSpecialCharacters) strength++;
    if (hasMinLength) strength++;

    if (strength <= 2) {
      return 'Weak';
    } else if (strength == 3 || strength == 4) {
      return 'Good';
    } else {
      return 'Strong';
    }
  }

  Color getStrengthColor(String strength) {
    switch (strength) {
      case 'Weak':
        return kErrorColor;
      case 'Good':
        return kPrimaryColor;
      case 'Strong':
        return kSuccessColor;
      default:
        return Colors.transparent;
    }
  }

  void _checkPasswordMatch() {
    setState(() {
      _passwordsMatch = _newPassWord.text == _confirmPassword.text;
    });
  }

  void _changeObscurePw() {
    setState(() {
      _obscurePw = !_obscurePw;
    });
  }

  void _changeObscureConfrimPw() {
    setState(() {
      _obscureConfrimPw = !_obscureConfrimPw;
    });
  }

  void createPassword(String password) {
    context.read<AuthBloc>().add(
          SavePasswordEvent(
            password: password,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints:
                          BoxConstraints(minHeight: constraints.maxHeight),
                      child: IntrinsicHeight(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Top form section
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 20),
                                Text(
                                  'Create Password',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  'This password will unlock your Cryptooly wallet only on this service',
                                  style: Theme.of(context).textTheme.labelSmall,
                                ),
                                const SizedBox(height: 20),
                                PasswordField(
                                  controller: _newPassWord,
                                  text: 'New Password',
                                  suffixIcon: _obscurePw
                                      ? const Icon(Icons.visibility_off)
                                      : const Icon(Icons.visibility),
                                  onTap: _changeObscurePw,
                                  obscureText: _obscurePw,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                if (_passwordStrength.isNotEmpty)
                                  Row(
                                    children: [
                                      Text(
                                        'Password strength: ',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall,
                                      ),
                                      Text(
                                        _passwordStrength,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall!
                                            .copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: getStrengthColor(
                                                  _passwordStrength,
                                                )),
                                      ),
                                    ],
                                  ),
                                const SizedBox(height: 20),
                                PasswordField(
                                  text: 'Confirm Password',
                                  suffixIcon: _obscureConfrimPw
                                      ? const Icon(Icons.visibility_off)
                                      : const Icon(Icons.visibility),
                                  onTap: _changeObscureConfrimPw,
                                  obscureText: _obscureConfrimPw,
                                  controller: _confirmPassword,
                                ),
                                const SizedBox(height: 5),
                                if (_confirmPassword.text.isNotEmpty &&
                                    !_passwordsMatch)
                                  Text(
                                    'Passwords do not match',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall!
                                        .copyWith(
                                          color: kErrorColor,
                                        ),
                                  )
                                else if (_confirmPassword.text.isNotEmpty &&
                                    _passwordsMatch)
                                  Text(
                                    'Passwords match',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall!
                                        .copyWith(
                                          color: kSuccessColor,
                                        ),
                                  )
                              ],
                            ),

                            // Bottom agreement and button
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'By proceeding, you agree to these',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall!
                                          .copyWith(fontSize: 11.5),
                                    ),
                                    Text(
                                      ' Terms and Conditions',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall!
                                          .copyWith(color: kSuccessColor),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: ButtonWidget(
                                    color: kPrimaryColor,
                                    text: 'Create Password',
                                    onTap: () {
                                      if (_newPassWord.text !=
                                          _confirmPassword.text) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              content: Text(
                                                  'Passwords do not match')),
                                        );
                                        return;
                                      }

                                      if (_passwordStrength == 'Weak') {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              content:
                                                  Text('Password is too weak')),
                                        );
                                        return;
                                      }
                                      createPassword(
                                        _confirmPassword.text.trim(),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
      listener: (context, state) {
        if (state is AuthSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Password Created Successfully',
              ),
            ),
          );

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SecureWallet(),
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
    );
  }
}
