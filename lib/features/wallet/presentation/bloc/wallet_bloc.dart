import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ivy_dex/core/usecase/usecase.dart';
import 'package:ivy_dex/features/wallet/domain/entities/account_entity.dart';

import 'package:ivy_dex/features/wallet/domain/usecase/add_token_to_account.dart';
import 'package:ivy_dex/features/wallet/domain/usecase/create_wallet_from_seedPhrase.dart';
import 'package:ivy_dex/features/wallet/domain/usecase/get_active_account.dart';
import 'package:ivy_dex/features/wallet/domain/usecase/get_all_account.dart';
import 'package:ivy_dex/features/wallet/domain/usecase/get_saved_mnemonic.dart';
import 'package:ivy_dex/features/wallet/domain/usecase/get_total_balance.dart';
import 'package:ivy_dex/features/wallet/domain/usecase/save_mnemonic.dart';
import 'package:ivy_dex/features/wallet/domain/usecase/set_active_account.dart';

import '../../domain/entities/total_balance_entity.dart';
import '../../domain/usecase/get_token_balance.dart';

part 'wallet_event.dart';
part 'wallet_state.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  final DeriveAccountFromMnemonicUseCase deriveAccount;
  final GetSavedMnemonicUseCase getMnemonic;
  final GetAllAccountsUseCase getAccounts;
  final SetActiveAccountUseCase setActiveAccount;
  final GetActiveAccountUseCase getActive;
  final AddTokenToAccountUseCase addToken;
  final GetTokenBalancesUseCase getBalances;
  final GetTotalBalanceUseCase getTotal;
  final SaveMnemonic saveMnemonic;

  WalletBloc({
    required this.saveMnemonic,
    required this.deriveAccount,
    required this.getMnemonic,
    required this.getAccounts,
    required this.setActiveAccount,
    required this.getActive,
    required this.addToken,
    required this.getBalances,
    required this.getTotal,
  }) : super(WalletInitial()) {
    on<LoadWalletEvent>(_onLoadWallet);
    on<DeriveAccountEvent>(_onDeriveAccount);
    on<SetActiveAccountEvent>(_onSetActiveAccount);
    on<AddTokenEvent>(_onAddToken);
    on<RefreshBalancesEvent>(_onRefreshBalances);
    on<GetSavedMnemonicEvent>(_onGetSavedMnemonic);
  }

  Future<void> _onGetSavedMnemonic(
      GetSavedMnemonicEvent event, Emitter<WalletState> emit) async {
    emit(WalletLoading());

    try {
      await saveMnemonic(NoParam());
      final mnemonic = await getMnemonic(NoParam());

      emit(MnemonicGenerated(mnemonic));
    } catch (e) {
      emit(WalletError(message: e.toString()));
    }
  }

  Future<void> _onLoadWallet(
      LoadWalletEvent event, Emitter<WalletState> emit) async {
    emit(WalletLoading());
    try {
      final mnemonic = await getMnemonic(NoParam());

      final accounts = await getAccounts(NoParam());

      final active = await getActive(NoParam());

      emit(WalletLoaded(
        mnemonic: mnemonic,
        accounts: accounts,
        activeAccount: active,
      ));
    } catch (e) {
      emit(WalletError(message: e.toString()));
    }
  }

  Future<void> _onDeriveAccount(
      DeriveAccountEvent event, Emitter<WalletState> emit) async {
    try {
      final account = await deriveAccount(DeriveAccountParams(
        mnemonic: event.mnemonic,
        index: event.index,
      ));
      final accounts = await getAccounts(NoParam());
      emit(WalletLoaded(
        mnemonic: event.mnemonic,
        accounts: [...accounts, account],
        activeAccount: account,
      ));
    } catch (e) {
      emit(WalletError(message: e.toString()));
    }
  }

  Future<void> _onSetActiveAccount(
      SetActiveAccountEvent event, Emitter<WalletState> emit) async {
    try {
      await setActiveAccount(event.account);
      final updatedActive = await getActive(NoParam());
      emit(AccountSwitched(account: updatedActive));
    } catch (e) {
      emit(WalletError(message: e.toString()));
    }
  }

  Future<void> _onAddToken(
      AddTokenEvent event, Emitter<WalletState> emit) async {
    try {
      await addToken(AddTokenParams(
        account: event.account,
        contractAddress: event.contractAddress,
        symbol: event.symbol,
        decimals: event.decimals,
      ));
      emit(TokenAddedSuccessfully());
    } catch (e) {
      emit(WalletError(message: e.toString()));
    }
  }

  Future<void> _onRefreshBalances(
      RefreshBalancesEvent event, Emitter<WalletState> emit) async {
    try {
      final balances = await getBalances(AccountParam(event.account));
      final total = await getTotal(event.account);
      emit(BalancesLoaded(balances: balances, totalBalance: total));
    } catch (e) {
      emit(WalletError(message: e.toString()));
    }
  }
}
