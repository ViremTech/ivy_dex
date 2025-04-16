import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ivy_dex/confiq/theme/dart_mode.dart';
import 'package:ivy_dex/core/bloc/wallet_init_bloc/wallet_init_bloc.dart';
import 'package:ivy_dex/core/cubit/auth_wallet_cubit.dart';
import 'package:ivy_dex/features/auth/data/data_source/local_auth_datasource.dart';
import 'package:ivy_dex/features/auth/data/repository_impl/auth_repo_impl.dart';
import 'package:ivy_dex/features/auth/domain/usecase/delete_password.dart';
import 'package:ivy_dex/features/auth/domain/usecase/save_password.dart';
import 'package:ivy_dex/features/auth/domain/usecase/validate_password.dart';
import 'package:ivy_dex/core/bloc/auth_bloc/auth_bloc.dart';
import 'package:ivy_dex/features/onboarding/data/data_source/onboarding_local_data_source.dart';
import 'package:ivy_dex/features/onboarding/data/repository_impl/onboarding_repo_impl.dart';
import 'package:ivy_dex/features/onboarding/domain/usecase/check_onboarding_status.dart';
import 'package:ivy_dex/features/onboarding/domain/usecase/complete_onboarding.dart';
import 'package:ivy_dex/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:ivy_dex/features/wallet/data/data_source/wallet_source.dart';
import 'package:ivy_dex/features/wallet/data/repository_impl/wallet_repo_impl.dart';
import 'package:ivy_dex/features/wallet/domain/usecase/add_token_to_account.dart';
import 'package:ivy_dex/features/wallet/domain/usecase/get_active_account.dart';
import 'package:ivy_dex/features/wallet/domain/usecase/get_all_account.dart';
import 'package:ivy_dex/features/wallet/domain/usecase/get_saved_mnemonic.dart';
import 'package:ivy_dex/features/wallet/domain/usecase/get_token_balance.dart';
import 'package:ivy_dex/features/wallet/domain/usecase/get_total_balance.dart';

import 'package:ivy_dex/features/wallet/domain/usecase/create_wallet_from_seedPhrase.dart';
import 'package:ivy_dex/features/wallet/domain/usecase/save_mnemonic.dart';
import 'package:ivy_dex/features/wallet/domain/usecase/set_active_account.dart';
import 'package:ivy_dex/features/wallet/presentation/bloc/wallet_bloc.dart';
import 'package:ivy_dex/init_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => WalletInitBloc(
            storage: FlutterSecureStorage(),
          ),
        ),
        BlocProvider(
          create: (context) => OnboardingBloc(
            completeOnboarding: CompleteOnboarding(
              repo: OnboardingRepositoryImpl(
                OnboardingLocalDataSourceImpl(
                  storage: FlutterSecureStorage(),
                ),
              ),
            ),
            checkOnboardingStatus: CheckOnboardingStatus(
              OnboardingRepositoryImpl(
                OnboardingLocalDataSourceImpl(
                  storage: FlutterSecureStorage(),
                ),
              ),
            ),
          ),
        ),
        BlocProvider(
            create: (context) => WalletBloc(
                deriveAccount: DeriveAccountFromMnemonicUseCase(
                  WalletRepoImpl(
                    localDataSource: WalletLocalDataSourceImpl(
                      storage: FlutterSecureStorage(),
                    ),
                  ),
                ),
                getMnemonic: GetSavedMnemonicUseCase(WalletRepoImpl(
                    localDataSource: WalletLocalDataSourceImpl(
                        storage: FlutterSecureStorage()))),
                getAccounts: GetAllAccountsUseCase(WalletRepoImpl(
                    localDataSource: WalletLocalDataSourceImpl(
                        storage: FlutterSecureStorage()))),
                setActiveAccount: SetActiveAccountUseCase(WalletRepoImpl(
                    localDataSource: WalletLocalDataSourceImpl(
                        storage: FlutterSecureStorage()))),
                getActive: GetActiveAccountUseCase(WalletRepoImpl(
                    localDataSource: WalletLocalDataSourceImpl(
                        storage: FlutterSecureStorage()))),
                addToken: AddTokenToAccountUseCase(WalletRepoImpl(
                    localDataSource: WalletLocalDataSourceImpl(
                        storage: FlutterSecureStorage()))),
                getBalances: GetTokenBalancesUseCase(WalletRepoImpl(
                    localDataSource: WalletLocalDataSourceImpl(
                        storage: FlutterSecureStorage()))),
                getTotal: GetTotalBalanceUseCase(WalletRepoImpl(
                    localDataSource: WalletLocalDataSourceImpl(
                        storage: FlutterSecureStorage()))),
                saveMnemonic: SaveMnemonic(
                    repository: WalletRepoImpl(
                        localDataSource: WalletLocalDataSourceImpl(
                            storage: FlutterSecureStorage()))))),
        BlocProvider(
          create: (context) => AuthBloc(
              deletePassword: DeletePassword(
                  authRepo: AuthRepoImpl(
                datasource: LocalAuthDatasourceImpl(),
              )),
              savePassword: SavePassword(
                  repo: AuthRepoImpl(
                datasource: LocalAuthDatasourceImpl(),
              )),
              validatePassword: ValidatePassword(
                  authRepo: AuthRepoImpl(
                datasource: LocalAuthDatasourceImpl(),
              ))),
        ),
        BlocProvider(
            create: (context) => AuthWalletCubic(
                authBloc: context.read<AuthBloc>(),
                walletBloc: context.read<WalletBloc>())),
      ],
      child: MaterialApp(
        title: 'Ivy Dex',
        theme: darkTheme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        home: InitScreen(),
      ),
    );
  }
}
