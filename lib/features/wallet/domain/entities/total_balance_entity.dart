class TokenBalanceEntity {
  final String symbol;
  final String contractAddress;
  final int decimals;
  final double balance;

  TokenBalanceEntity({
    required this.symbol,
    required this.contractAddress,
    required this.decimals,
    required this.balance,
  });

  Map<String, dynamic> toJson() => {
        'symbol': symbol,
        'contractAddress': contractAddress,
        'decimals': decimals,
        'balance': balance,
      };

  factory TokenBalanceEntity.fromJson(Map<String, dynamic> json) =>
      TokenBalanceEntity(
        symbol: json['symbol'],
        contractAddress: json['contractAddress'],
        decimals: json['decimals'],
        balance: (json['balance'] as num).toDouble(),
      );
}
