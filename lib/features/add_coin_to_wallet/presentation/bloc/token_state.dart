import 'package:equatable/equatable.dart';
import 'package:ivy_dex/features/add_coin_to_wallet/domain/entities/token_balance.dart';
import 'package:ivy_dex/features/add_coin_to_wallet/domain/entities/token_entities.dart';

abstract class TokenState extends Equatable {
  const TokenState();

  @override
  List<Object?> get props => [];
}

class TokenInitial extends TokenState {}

class TokenLoading extends TokenState {}

class TokensLoaded extends TokenState {
  final List<TokenEntity> tokens;

  const TokensLoaded(this.tokens);

  @override
  List<Object?> get props => [tokens];
}

class TokenBalancesLoaded extends TokenState {
  final List<TokenBalanceEntity> balances;

  const TokenBalancesLoaded(this.balances);

  @override
  List<Object?> get props => [balances];
}

class TokenOperationSuccess extends TokenState {
  final String message;

  const TokenOperationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class TokenOperationFailure extends TokenState {
  final String message;

  const TokenOperationFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class AddressValidationState extends TokenState {
  final bool isValid;
  final String address;

  const AddressValidationState({
    required this.isValid,
    required this.address,
  });

  @override
  List<Object?> get props => [isValid, address];
}
