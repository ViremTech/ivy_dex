import 'package:equatable/equatable.dart';

import '../../../wallet/domain/entities/account_entity.dart';

abstract class TokenEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadTokens extends TokenEvent {
  final AccountEntity account;
  final int networkId;

  LoadTokens({
    required this.account,
    required this.networkId,
  });

  @override
  List<Object?> get props => [account, networkId];
}

class AddToken extends TokenEvent {
  final AccountEntity account;
  final String contractAddress;
  final String symbol;
  final String name;
  final int decimals;
  final String? logoUrl;
  final int networkId;

  AddToken({
    required this.account,
    required this.contractAddress,
    required this.symbol,
    required this.name,
    required this.decimals,
    this.logoUrl,
    required this.networkId,
  });

  @override
  List<Object?> get props =>
      [account, contractAddress, symbol, name, decimals, logoUrl, networkId];
}

class RemoveToken extends TokenEvent {
  final int accountIndex;
  final String address;
  final String privateKey;
  final String contractAddress;
  final int networkId;

  RemoveToken({
    required this.accountIndex,
    required this.address,
    required this.privateKey,
    required this.contractAddress,
    required this.networkId,
  });

  @override
  List<Object?> get props =>
      [accountIndex, address, privateKey, contractAddress, networkId];
}

class RefreshBalances extends TokenEvent {
  final AccountEntity account;
  final int networkId;

  RefreshBalances({
    required this.account,
    required this.networkId,
  });

  @override
  List<Object?> get props => [account, networkId];
}

class ValidateAddress extends TokenEvent {
  final String address;

  ValidateAddress({required this.address});

  @override
  List<Object?> get props => [address];
}
