import 'package:ivy_dex/core/usecase/usecase.dart';
import 'package:ivy_dex/features/wallet/domain/entities/account_entity.dart';
import 'package:ivy_dex/features/wallet/domain/repo/wallet_repo.dart';

class GetAllAccountsUseCase implements Usecase<List<AccountEntity>, NoParam> {
  final WalletRepository repository;

  GetAllAccountsUseCase(this.repository);

  @override
  Future<List<AccountEntity>> call(NoParam params) async {
    return await repository.getAllAccounts();
  }
}
