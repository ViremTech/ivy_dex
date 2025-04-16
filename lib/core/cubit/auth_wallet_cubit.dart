import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ivy_dex/core/bloc/auth_bloc/auth_bloc.dart';

import '../../features/wallet/presentation/bloc/wallet_bloc.dart';

part 'auth_wallet_state.dart';

class AuthWalletCubic extends Cubit<AuthWalletState> {
  final AuthBloc authBloc;
  final WalletBloc walletBloc;

  AuthSuccess? _authSuccess;
  WalletLoaded? _walletLoaded;

  late final StreamSubscription _authSub;
  late final StreamSubscription _walletSub;

  AuthWalletCubic({
    required this.authBloc,
    required this.walletBloc,
  }) : super(AuthWalletInitial()) {
    emit(AuthWalletLoading());

    _authSub = authBloc.stream.listen((authState) {
      if (authState is AuthSuccess) {
        _authSuccess = authState;
        _tryEmitReady();
      } else {
        _authSuccess = null;
        emit(AuthWalletLoading());
      }
    });

    _walletSub = walletBloc.stream.listen((walletState) {
      if (walletState is WalletLoaded) {
        _walletLoaded = walletState;
        _tryEmitReady();
      } else {
        _walletLoaded = null;
        emit(AuthWalletLoading());
      }
    });
  }

  void _tryEmitReady() {
    print('Trying to emit ready. Auth: $_authSuccess, Wallet: $_walletLoaded');
    if (_authSuccess != null && _walletLoaded != null) {
      emit(AuthWalletReady(_authSuccess!, _walletLoaded!));
    }
  }

  @override
  Future<void> close() {
    _authSub.cancel();
    _walletSub.cancel();
    return super.close();
  }
}
