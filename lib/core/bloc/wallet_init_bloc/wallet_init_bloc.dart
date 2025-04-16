import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

part 'wallet_init_event.dart';
part 'wallet_init_state.dart';

class WalletInitBloc extends Bloc<WalletInitEvent, WalletInitState> {
  final FlutterSecureStorage storage;

  WalletInitBloc({required this.storage}) : super(WalletInitInitial()) {
    on<CheckSeedPhraseStatus>((event, emit) async {
      emit(WalletInitLoading());

      final seedPhrase = await storage.read(key: 'wallet_mnemonic');

      if (seedPhrase != null && seedPhrase.isNotEmpty) {
        emit(WalletReady());
      } else {
        emit(WalletNeedsSetup());
      }
    });
  }
}
