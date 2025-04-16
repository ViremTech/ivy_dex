part of 'wallet_bloc.dart';

abstract class WalletEvent extends Equatable {
  const WalletEvent();

  @override
  List<Object?> get props => [];
}

class LoadWalletEvent extends WalletEvent {}

class DeriveAccountEvent extends WalletEvent {
  final String mnemonic;
  final int index;

  DeriveAccountEvent({required this.mnemonic, required this.index});
}

class SetActiveAccountEvent extends WalletEvent {
  final AccountEntity account;

  SetActiveAccountEvent(this.account);
}

class AddTokenEvent extends WalletEvent {
  final AccountEntity account;
  final String contractAddress;
  final String symbol;
  final int decimals;

  AddTokenEvent({
    required this.account,
    required this.contractAddress,
    required this.symbol,
    required this.decimals,
  });
}

class RefreshBalancesEvent extends WalletEvent {
  final AccountEntity account;

  RefreshBalancesEvent(this.account);
}

class GetSavedMnemonicEvent extends WalletEvent {}
