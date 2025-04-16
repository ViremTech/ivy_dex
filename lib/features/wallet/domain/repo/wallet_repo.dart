import 'package:ivy_dex/features/wallet/domain/entities/account_entity.dart';

import '../entities/total_balance_entity.dart';

abstract class WalletRepository {
  /// Creates the first account from a given mnemonic
  Future<AccountEntity> deriveAccountFromMnemonic(String mnemonic, int index);

  Future<void> saveMnemonic();

  /// Returns the stored mnemonic for the wallet
  Future<String> getSavedMnemonic();

  /// Returns all accounts stored locally
  Future<List<AccountEntity>> getAllAccounts();

  /// Sets the active account to be used for transactions
  Future<void> setActiveAccount(AccountEntity account);

  /// Returns the currently active account
  Future<AccountEntity> getActiveAccount();

  /// Adds a custom token to the specified account
  Future<void> addTokenToAccount({
    required AccountEntity account,
    required String contractAddress,
    required String symbol,
    required int decimals,
  });

  /// Gets the balances for all tokens in an account
  Future<List<TokenBalanceEntity>> getTokenBalances(AccountEntity account);

  /// Gets the total balance for an account (in native or fiat currency)
  Future<double> getTotalBalance(AccountEntity account);
}
