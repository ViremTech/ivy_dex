import 'package:ivy_dex/core/usecase/usecase.dart';

import '../repo/wallet_repo.dart';

class GetSavedMnemonicUseCase implements Usecase<String, NoParam> {
  final WalletRepository repository;

  GetSavedMnemonicUseCase(this.repository);

  @override
  Future<String> call(NoParam params) async {
    return await repository.getSavedMnemonic();
  }
}
