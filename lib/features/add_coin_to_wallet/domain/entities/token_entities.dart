class TokenEntity {
  final String contractAddress;
  final String symbol;
  final String name;
  final int decimals;
  final String? logoUrl;
  final int networkId;

  TokenEntity(
      {required this.contractAddress,
      required this.symbol,
      required this.name,
      required this.decimals,
      required this.logoUrl,
      required this.networkId});
}
