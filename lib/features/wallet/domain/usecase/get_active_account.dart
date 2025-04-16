import 'package:ivy_dex/core/usecase/usecase.dart';
import 'package:ivy_dex/features/wallet/domain/entities/account_entity.dart';
import 'package:ivy_dex/features/wallet/domain/repo/wallet_repo.dart';

class GetActiveAccountUseCase implements Usecase<AccountEntity, NoParam> {
  final WalletRepository repository;

  GetActiveAccountUseCase(this.repository);

  @override
  Future<AccountEntity> call(NoParam params) async {
    return await repository.getActiveAccount();
  }
}
