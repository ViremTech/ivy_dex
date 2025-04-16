import 'package:ivy_dex/core/usecase/usecase.dart';
import 'package:ivy_dex/features/wallet/domain/repo/wallet_repo.dart';

import '../entities/account_entity.dart';

class DeriveAccountFromMnemonicUseCase
    implements Usecase<AccountEntity, DeriveAccountParams> {
  final WalletRepository repository;

  DeriveAccountFromMnemonicUseCase(this.repository);

  @override
  Future<AccountEntity> call(DeriveAccountParams params) async {
    return await repository.deriveAccountFromMnemonic(
        params.mnemonic, params.index);
  }
}

class DeriveAccountParams {
  final String mnemonic;
  final int index;

  DeriveAccountParams({
    required this.mnemonic,
    required this.index,
  });
}
