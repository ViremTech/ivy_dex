part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class SavePasswordEvent extends AuthEvent {
  final String password;
  SavePasswordEvent({
    required this.password,
  });

  @override
  List<Object> get props => [password];
}

class ValidatePasswordEvent extends AuthEvent {
  final String password;
  ValidatePasswordEvent({
    required this.password,
  });

  @override
  List<Object> get props => [password];
}

class DeletePasswordEvent extends AuthEvent {}
