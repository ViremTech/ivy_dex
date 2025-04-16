part of 'auth_wallet_cubit.dart';

abstract class AuthWalletState {}

class AuthWalletInitial extends AuthWalletState {}

class AuthWalletLoading extends AuthWalletState {}

class AuthWalletReady extends AuthWalletState {
  final AuthSuccess auth;
  final WalletLoaded wallet;

  AuthWalletReady(this.auth, this.wallet);
}

class AuthWalletError extends AuthWalletState {
  final String message;
  AuthWalletError(this.message);
}
