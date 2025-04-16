import 'package:ivy_dex/core/usecase/usecase.dart';
import 'package:ivy_dex/features/wallet/domain/entities/account_entity.dart';
import 'package:ivy_dex/features/wallet/domain/repo/wallet_repo.dart';

class GetTotalBalanceUseCase implements Usecase<double, AccountEntity> {
  final WalletRepository repository;

  GetTotalBalanceUseCase(this.repository);

  @override
  Future<double> call(AccountEntity params) async {
    return await repository.getTotalBalance(params);
  }
}
