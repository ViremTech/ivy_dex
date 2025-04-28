import 'package:equatable/equatable.dart';

abstract class TokenMetadataState extends Equatable {
  const TokenMetadataState();

  @override
  List<Object?> get props => [];
}

class TokenMetadataInitial extends TokenMetadataState {}

class TokenMetadataLoading extends TokenMetadataState {}

class TokenMetadataLoaded extends TokenMetadataState {
  final String symbol;
  final String name;
  final int decimals;

  const TokenMetadataLoaded({
    required this.symbol,
    required this.name,
    required this.decimals,
  });

  @override
  List<Object?> get props => [symbol, name, decimals];
}

class TokenMetadataError extends TokenMetadataState {
  final String message;

  const TokenMetadataError(this.message);

  @override
  List<Object?> get props => [message];
}
