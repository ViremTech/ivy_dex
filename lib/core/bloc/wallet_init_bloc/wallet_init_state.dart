part of 'wallet_init_bloc.dart';

abstract class WalletInitState {}

class WalletInitInitial extends WalletInitState {}

class WalletInitLoading extends WalletInitState {}

class WalletNeedsSetup extends WalletInitState {}

class WalletReady extends WalletInitState {}
