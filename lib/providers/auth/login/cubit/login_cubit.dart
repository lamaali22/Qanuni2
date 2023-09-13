import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  static LoginCubit get(context) => BlocProvider.of(context);

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  login() async {
    emit(SigningIn());
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailController.text, password: passwordController.text)
          .then((value) {
        emit(LoginSuccess());
      });
    } catch (e) {
      if (e is FirebaseAuthException) {
        emit(LoginFailed(e.code));
      } else {
        emit(LoginFailed(e.toString()));
      }
    }
  }

  reset() {
    emailController.clear();
    passwordController.clear();
    emit(LoginInitial());
  }
}
