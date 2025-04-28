import 'package:ivy_dex/features/add_coin_to_wallet/domain/entities/token_entities.dart';

class TokenBalanceEntity {
  final TokenEntity token;
  final double fiatValue;
  final double balance;

  TokenBalanceEntity({
    required this.token,
    this.fiatValue = 0.0,
    required this.balance,
  });

  Map<String, dynamic> toJson() => {
        'token': token,
        'fiatValue': fiatValue,
        'balance': balance,
      };

  factory TokenBalanceEntity.fromJson(Map<String, dynamic> json) =>
      TokenBalanceEntity(
        token: json['token'],
        fiatValue: json['fiatValue'],
        balance: (json['balance'] as num).toDouble(),
      );
}
