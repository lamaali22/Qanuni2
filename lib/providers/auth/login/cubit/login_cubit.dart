import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:qanuni/data/auth_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  static LoginCubit get(context) => BlocProvider.of(context);

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  loginUser() async {
    emit(SigningIn());
    try {
      int mode = await AuthApi().checkClientExistence(emailController.text);

      if (mode == 0 || mode == 1) {
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: emailController.text, password: passwordController.text)
            .then((value) {
          emit(LoginSuccess(mode: mode));
        });
      } else {
        emit(LoginFailed('البريد الالكتروني أو كلمة المرور غير صحيحة'));
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

  // loginLawyer() async {
  //   emit(SigningIn());
  //   try {
  //     bool laywerExists =
  //         await AuthApi().checkLawyerExistence(emailController.text);

  //     if (laywerExists) {
  //       await FirebaseAuth.instance
  //           .signInWithEmailAndPassword(
  //               email: emailController.text, password: passwordController.text)
  //           .then((value) {
  //         emit(LoginSuccess());
  //       });
  //     } else {
  //       emit(LoginFailed('البريد الالكتروني أو كلمة المرور غير صحيحة'));
  //     }
  //   } catch (e) {
  //     if (e is FirebaseAuthException) {
  //       emit(LoginFailed('البريد الالكتروني أو كلمة المرور غير صحيحة'));
  //     } else {
  //       emit(LoginFailed(e.toString()));
  //     }
  //   }
  // }

  reset() {
    emailController.clear();
    passwordController.clear();
    emit(LoginInitial());
  }
}
