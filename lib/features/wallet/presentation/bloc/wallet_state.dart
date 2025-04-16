part of 'wallet_bloc.dart';

abstract class WalletState extends Equatable {
  const WalletState();

  @override
  List<Object?> get props => [];
}

class WalletInitial extends WalletState {}

class WalletLoading extends WalletState {}

class WalletLoaded extends WalletState {
  final String mnemonic;
  final List<AccountEntity> accounts;
  final AccountEntity activeAccount;

  WalletLoaded({
    required this.mnemonic,
    required this.accounts,
    required this.activeAccount,
  });

  @override
  List<Object?> get props => [mnemonic, accounts, activeAccount];
}

class AccountSwitched extends WalletState {
  final AccountEntity account;

  AccountSwitched({required this.account});

  @override
  List<Object?> get props => [account];
}

class TokenAddedSuccessfully extends WalletState {}

class BalancesLoaded extends WalletState {
  final List<TokenBalanceEntity> balances;
  final double totalBalance;

  BalancesLoaded({required this.balances, required this.totalBalance});

  @override
  List<Object?> get props => [balances, totalBalance];
}

class WalletError extends WalletState {
  final String message;

  WalletError({required this.message});

  @override
  List<Object?> get props => [message];
}

class MnemonicGenerated extends WalletState {
  final String mnemonic;
  MnemonicGenerated(this.mnemonic);
}
