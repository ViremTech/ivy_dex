import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ivy_dex/core/constants/color.dart';
import 'package:ivy_dex/core/cubit/auth_wallet_cubit.dart';
import 'package:ivy_dex/core/widgets/button_widget.dart';
import 'package:ivy_dex/features/auth/presentation/widgets/password.dart';
import 'package:ivy_dex/features/wallet/presentation/bloc/wallet_bloc.dart';
import 'package:ivy_dex/features/wallet/presentation/pages/wallet_home.dart';

import '../../../../core/bloc/auth_bloc/auth_bloc.dart';

class ImportSeedScreen extends StatefulWidget {
  const ImportSeedScreen({super.key});

  @override
  State<ImportSeedScreen> createState() => _ImportSeedScreenState();
}

class _ImportSeedScreenState extends State<ImportSeedScreen> {
  final TextEditingController _newPassWord = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  final TextEditingController _seedPhraseController = TextEditingController();
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

  void _importSeedPhrase(String password, String seedPhrase) {
    context.read<WalletBloc>().add(DeriveAccountEvent(
          index: 0,
          mnemonic: _seedPhraseController.text,
        ));
  }

  void _createPasswordForImport(String password) {
    context.read<AuthBloc>().add(
          SavePasswordEvent(
            password: password,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Import From Seed',
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      const SizedBox(height: 40),
                      TextField(
                        controller: _seedPhraseController,
                        style: GoogleFonts.spaceGrotesk(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          labelText: 'Seed Phrase',
                          suffixIcon: SizedBox(
                            width: 70,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(Icons.qr_code_scanner, size: 24),
                                SizedBox(width: 8),
                                Icon(Icons.visibility, size: 24),
                                SizedBox(width: 10),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Typically 12 (sometimes 24) words separated by single spaces',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                      const SizedBox(height: 60),
                      PasswordField(
                        controller: _newPassWord,
                        text: 'New Password',
                        suffixIcon: _obscurePw
                            ? const Icon(Icons.visibility_off)
                            : const Icon(Icons.visibility),
                        onTap: _changeObscurePw,
                        obscureText: _obscurePw,
                      ),
                      const SizedBox(height: 10),
                      if (_passwordStrength.isNotEmpty)
                        Row(
                          children: [
                            Text(
                              'Password strength: ',
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                            Text(
                              _passwordStrength,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: getStrengthColor(_passwordStrength),
                                  ),
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
                      if (_confirmPassword.text.isNotEmpty && !_passwordsMatch)
                        Text(
                          'Passwords do not match',
                          style:
                              Theme.of(context).textTheme.labelSmall!.copyWith(
                                    color: kErrorColor,
                                  ),
                        )
                      else if (_confirmPassword.text.isNotEmpty &&
                          _passwordsMatch)
                        Text(
                          'Passwords match',
                          style:
                              Theme.of(context).textTheme.labelSmall!.copyWith(
                                    color: kSuccessColor,
                                  ),
                        ),
                    ],
                  ),
                ),
              ),
              Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'By proceeding, you agree to these',
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall!
                            .copyWith(fontSize: 11),
                      ),
                      Text(
                        ' Terms and Conditions',
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall!
                            .copyWith(color: kSuccessColor, fontSize: 11),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: BlocListener<AuthWalletCubic, AuthWalletState>(
                      listener: (context, state) {
                        if (state is AuthWalletReady) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WalletHome(
                                walletAddress:
                                    state.wallet.accounts.first.address,
                                privateKey:
                                    state.wallet.accounts.first.privateKey,
                                accountIndex: state.wallet.accounts.first.index,
                                networkId: 1,
                              ),
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Wallet Imported Successfully'),
                            ),
                          );
                        }

                        if (state is AuthWalletError) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.message)),
                          );
                        }
                      },
                      child: ButtonWidget(
                        color: kPrimaryColor,
                        text: 'Import',
                        onTap: () {
                          if (_seedPhraseController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Please enter a valid seed phrase')),
                            );
                            return;
                          }

                          if (!_passwordsMatch) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Passwords do not match')),
                            );
                            return;
                          }

                          if (_passwordStrength == 'Weak') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Password is too weak')),
                            );
                            return;
                          }
                          _createPasswordForImport(
                            _confirmPassword.text.trim(),
                          );
                          _importSeedPhrase(
                            _confirmPassword.text.trim(),
                            _seedPhraseController.text.trim(),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
