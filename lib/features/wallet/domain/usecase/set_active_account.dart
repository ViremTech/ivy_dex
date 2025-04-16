import 'package:ivy_dex/core/usecase/usecase.dart';
import 'package:ivy_dex/features/wallet/domain/entities/account_entity.dart';
import 'package:ivy_dex/features/wallet/domain/repo/wallet_repo.dart';

class SetActiveAccountUseCase implements Usecase<void, AccountEntity> {
  final WalletRepository repository;

  SetActiveAccountUseCase(this.repository);

  @override
  Future<void> call(AccountEntity params) async {
    await repository.setActiveAccount(params);
  }
}
