import 'account_entity.dart';

class WalletEntity {
  final String mnemonic;
  final List<AccountEntity> accounts;
  final int activeAccountIndex;

  WalletEntity({
    required this.mnemonic,
    required this.accounts,
    required this.activeAccountIndex,
  });

  AccountEntity get activeAccount => accounts[activeAccountIndex];
}
