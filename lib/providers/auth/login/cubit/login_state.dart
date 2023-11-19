part of 'login_cubit.dart';

@immutable
abstract class LoginState {}

class LoginInitial extends LoginState {}

class SigningIn extends LoginState {}

class LoginSuccess extends LoginState {
  final int mode;

  LoginSuccess({required this.mode});
}

class LoginFailed extends LoginState {
  final String error;

  LoginFailed(this.error);
}
