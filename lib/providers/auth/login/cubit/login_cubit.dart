import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:qanuni/data/auth_api.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  static LoginCubit get(context) => BlocProvider.of(context);

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  loginClient() async {
    emit(SigningIn());
    try {
      if (formKey.currentState!.validate()) {
        bool clientExists =
            await AuthApi().checkClientExistence(emailController.text);

        if (clientExists) {
          await FirebaseAuth.instance
              .signInWithEmailAndPassword(
                  email: emailController.text,
                  password: passwordController.text)
              .then((value) {
            emit(LoginSuccess());
          });
        } else {
          emit(LoginFailed('البريد الالكتروني أو كلمة المرور غير صحيحة'));
        }
      } else {
        emit(LoginInitial());
      }
    } catch (e) {
      if (e is FirebaseAuthException) {
        print(e.code);
        emit(LoginFailed('البريد الالكتروني أو كلمة المرور غير صحيحة'));
      } else {
        emit(LoginFailed(e.toString()));
      }
    }
  }

  loginLawyer() async {
    emit(SigningIn());
    try {
      if (formKey.currentState!.validate()) {
        bool laywerExists =
            await AuthApi().checkLawyerExistence(emailController.text);

        if (laywerExists) {
          await FirebaseAuth.instance
              .signInWithEmailAndPassword(
                  email: emailController.text,
                  password: passwordController.text)
              .then((value) {
            emit(LoginSuccess());
          });
        } else {
          emit(LoginFailed('البريد الالكتروني أو كلمة المرور غير صحيحة'));
        }
      } else {
        emit(LoginInitial());
      }
    } catch (e) {
      if (e is FirebaseAuthException) {
          emit(LoginFailed('البريد الالكتروني أو كلمة المرور غير صحيحة'));
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
