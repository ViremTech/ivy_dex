// import 'package:ivy_dex/core/usecase/usecase.dart';
// import 'package:ivy_dex/features/wallet/domain/entities/account_entity.dart';
// import 'package:ivy_dex/features/wallet/domain/repo/wallet_repo.dart';

// class AddTokenToAccountUseCase implements Usecase<void, AddTokenParams> {
//   final WalletRepository repository;

//   AddTokenToAccountUseCase(this.repository);

//   @override
//   Future<void> call(AddTokenParams params) async {
//     await repository.addTokenToAccount(
//       account: params.account,
//       contractAddress: params.contractAddress,
//       symbol: params.symbol,
//       decimals: params.decimals,
//     );
//   }
// }

// class AddTokenParams {
//   final AccountEntity account;
//   final String contractAddress;
//   final String symbol;
//   final int decimals;

//   AddTokenParams({
//     required this.account,
//     required this.contractAddress,
//     required this.symbol,
//     required this.decimals,
//   });
// }
