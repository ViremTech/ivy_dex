abstract interface class Usecase<Successtype, Params> {
  Future<Successtype> call(Params params);
}

class NoParam {}

class AccountEntityParam {
  final String address;
  final String privateKey;
  final int index;

  AccountEntityParam(
      {required this.address, required this.privateKey, required this.index});
}

class AccountAndGetAccountTokenParams {
  final AccountEntityParam accountEntityParam;
  final GetAccountTokenParams getAccountTokenParams;

  AccountAndGetAccountTokenParams(
      {required this.accountEntityParam, required this.getAccountTokenParams});
}

class GetAccountTokenParams {
  final int networkId;

  GetAccountTokenParams({required this.networkId});
}
