class AccountEntity {
  final int index;
  final String address;
  final String privateKey;

  AccountEntity({
    required this.index,
    required this.address,
    required this.privateKey,
  });

  Map<String, dynamic> toJson() => {
        'index': index,
        'address': address,
        'privateKey': privateKey,
      };

  factory AccountEntity.fromJson(Map<String, dynamic> json) => AccountEntity(
        index: json['index'],
        address: json['address'],
        privateKey: json['privateKey'],
      );
}
