import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ivy_dex/core/usecase/usecase.dart';
import 'package:ivy_dex/features/add_coin_to_wallet/domain/usecase/add_token_usecase.dart';
import 'package:ivy_dex/features/add_coin_to_wallet/domain/usecase/get_account_token_usecase.dart';
import 'package:ivy_dex/features/add_coin_to_wallet/domain/usecase/remove_token_usecase.dart';
import 'package:ivy_dex/features/add_coin_to_wallet/domain/usecase/validate_ethereum_address_usecase.dart';
import 'package:ivy_dex/features/add_coin_to_wallet/presentation/bloc/token_event.dart';
import 'package:ivy_dex/features/wallet/domain/entities/account_entity.dart';

import '../../domain/usecase/get_token_balance_usecase.dart';
import 'token_state.dart';

class TokenBloc extends Bloc<TokenEvent, TokenState> {
  final AddTokenUsecase addTokenUsecase;
  final RemoveTokenUsecase removeTokenUseCase;
  final GetAccountTokensUseCase getAccountTokensUseCase;
  final GetTokenBalanceUsecase getTokenBalancesUseCase;
  final ValidateEthereumAddressUseCase validateAddressUseCase;

  TokenBloc({
    required this.addTokenUsecase,
    required this.removeTokenUseCase,
    required this.getAccountTokensUseCase,
    required this.getTokenBalancesUseCase,
    required this.validateAddressUseCase,
  }) : super(TokenInitial()) {
    on<LoadTokens>(_onLoadTokens);
    on<AddToken>(_onAddToken);
    on<RemoveToken>(_onRemoveToken);
    on<RefreshBalances>(_onRefreshBalances);
    on<ValidateAddress>(_onValidateAddress);
  }

  Future<void> _onLoadTokens(LoadTokens event, Emitter<TokenState> emit) async {
    emit(TokenLoading());
    try {
      final params = AccountAndGetAccountTokenParams(
          getAccountTokenParams:
              GetAccountTokenParams(networkId: event.networkId),
          accountEntityParam: AccountEntityParam(
              address: event.account.address,
              privateKey: event.account.privateKey,
              index: event.account.index));

      final tokens = await getAccountTokensUseCase(params);
      emit(TokensLoaded(tokens));

      // Also fetch balances
      await _onRefreshBalances(
        RefreshBalances(
          account: AccountEntity(
              index: event.account.index,
              address: event.account.address,
              privateKey: event.account.privateKey),
          networkId: event.networkId,
        ),
        emit,
      );
    } catch (e) {
      emit(TokenOperationFailure('Failed to load tokens: ${e.toString()}'));
    }
  }

  Future<void> _onAddToken(AddToken event, Emitter<TokenState> emit) async {
    emit(TokenLoading());
    try {
      final params = AddTokenUsecaseParams(
          tokenParams: AddTokenParams(
              contractAddress: event.contractAddress,
              symbol: event.symbol,
              name: event.name,
              decimals: event.decimals,
              networkId: event.networkId),
          accountParams: AccountEntityParam(
              address: event.account.address,
              privateKey: event.account.privateKey,
              index: event.account.index));

      await addTokenUsecase(params);
      emit(TokenOperationSuccess('Token added successfully'));

      // Reload tokens and balances
      add(
        LoadTokens(
          account: AccountEntity(
              index: event.account.index,
              address: event.account.address,
              privateKey: event.account.privateKey),
          networkId: event.networkId,
        ),
      );
    } catch (e) {
      emit(TokenOperationFailure('Failed to add token: ${e.toString()}'));
    }
  }

  Future<void> _onRemoveToken(
      RemoveToken event, Emitter<TokenState> emit) async {
    emit(TokenLoading());
    try {
      final params = AccountAndRemoveTokenParam(
          accountParam: AccountEntityParam(
              address: event.address,
              privateKey: event.privateKey,
              index: event.accountIndex),
          removeTokenParam: RemoveTokenParam(
              contractAddress: event.contractAddress,
              networkId: event.networkId));

      await removeTokenUseCase(params);
      emit(TokenOperationSuccess('Token removed successfully'));

      // Reload tokens
      add(
        LoadTokens(
          account: AccountEntity(
              index: event.accountIndex,
              address: event.address,
              privateKey: event.privateKey),
          networkId: event.networkId,
        ),
      );
    } catch (e) {
      emit(TokenOperationFailure('Failed to remove token: ${e.toString()}'));
    }
  }

  Future<void> _onRefreshBalances(
      RefreshBalances event, Emitter<TokenState> emit) async {
    try {
      final params = AccountAndGetAccountTokenParams(
          accountEntityParam: AccountEntityParam(
              address: event.account.address,
              privateKey: event.account.privateKey,
              index: event.account.index),
          getAccountTokenParams:
              GetAccountTokenParams(networkId: event.networkId));

      final balances = await getTokenBalancesUseCase(params);
      emit(TokenBalancesLoaded(balances));
    } catch (e) {
      emit(
          TokenOperationFailure('Failed to refresh balances: ${e.toString()}'));
    }
  }

  Future<void> _onValidateAddress(
      ValidateAddress event, Emitter<TokenState> emit) async {
    try {
      final params = ValidateEthereumAddressParams(address: event.address);
      final isValid = await validateAddressUseCase(params);
      emit(AddressValidationState(isValid: isValid, address: event.address));
    } catch (e) {
      emit(
          TokenOperationFailure('Failed to validate address: ${e.toString()}'));
    }
  }
}
