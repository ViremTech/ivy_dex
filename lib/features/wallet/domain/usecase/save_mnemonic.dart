import 'package:ivy_dex/core/usecase/usecase.dart';
import 'package:ivy_dex/features/wallet/domain/repo/wallet_repo.dart';

class SaveMnemonic implements Usecase<void, NoParam> {
  WalletRepository repository;
  SaveMnemonic({required this.repository});
  @override
  Future<void> call(NoParam params) async {
    return await repository.saveMnemonic();
  }
}
