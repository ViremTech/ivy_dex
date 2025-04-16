import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ivy_dex/features/auth/domain/entities/auth_entity.dart';
import 'package:ivy_dex/features/auth/domain/usecase/delete_password.dart';
import 'package:ivy_dex/features/auth/domain/usecase/save_password.dart';
import 'package:ivy_dex/features/auth/domain/usecase/validate_password.dart';

import '../../usecase/usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SavePassword savePassword;
  final ValidatePassword validatePassword;
  final DeletePassword deletePassword;

  AuthBloc({
    required this.savePassword,
    required this.validatePassword,
    required this.deletePassword,
  }) : super(AuthInitial()) {
    on<SavePasswordEvent>(
      (event, emit) async {
        emit(AuthLoading());
        try {
          await savePassword(PasswordEntity(
            event.password,
          ));

          emit(AuthSuccess());
        } catch (e) {
          emit(
            AuthFailure(
              message: 'Failed to save password',
            ),
          );
        }
      },
    );
    on<ValidatePasswordEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final isValid = await validatePassword(PasswordEntity(event.password));
        if (isValid) {
          emit(AuthSuccess());
        } else {
          emit(AuthFailure(message: 'Incorrect Password'));
        }
      } catch (_) {
        emit(AuthFailure(message: 'Something went wrong'));
      }
    });

    on<DeletePasswordEvent>((event, emit) async {
      emit(AuthLoading());

      try {
        final isDeleted = await deletePassword(NoParam());
        if (isDeleted) {
          emit(AuthSuccess());
        } else {
          emit(AuthFailure(message: 'Password deletion failed'));
        }
      } catch (e) {
        emit(AuthFailure(message: 'Password Not Deleted'));
      }
    });
  }
}
