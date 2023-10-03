import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oktoast/oktoast.dart';
import 'package:qanuni/homePageLawyer.dart';
import 'package:qanuni/presentation/screens/boarding_screen/view.dart';
import 'package:qanuni/presentation/screens/client_signup_screen/view.dart';
import 'package:qanuni/presentation/screens/home_screen/view.dart';
import 'package:qanuni/presentation/screens/landing_screen/view.dart';
import 'package:qanuni/presentation/screens/lawyer_signup_screen/view.dart';
import 'package:qanuni/presentation/widgets/custom_text_form_field.dart';
import 'package:qanuni/providers/boarding/cubit/boarding_cubit.dart';

import '../../../providers/auth/login/cubit/login_cubit.dart';
import '../../../utils/colors.dart';
import '../../../utils/images.dart';
import '../reset_password_screen/view.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginFailed) {
          showToast(state.error, position: ToastPosition.bottom);
        }

        if (state is LoginSuccess) {
          showToast('مرحبا', position: ToastPosition.bottom);
          LoginCubit.get(context).reset();
          if (BoardingCubit.get(context).selectedOption == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(),
              ),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => LogoutPageLawyer(),
              ),
            );
          }
        }
      },
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 0.4.sh,
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.bottomRight,
                            height: 0.1.sh,
                            width: 1.sw,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => BoardingScreen()),
                                );
                              },
                              child: Icon(
                                Icons.chevron_right_outlined,
                                size: 30,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 0.2.sh,
                            height: 0.2.sh,
                            child: Image.asset(ImageConstants.logo),
                          ),
                          const Spacer(),
                          const Text(
                            'سجل الدخول لحسابك',
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 0.5.sh,
                      child: Form(
                          key: LoginCubit.get(context).formKey,
                          child: Column(
                            children: [
                              20.verticalSpace,
                              CustomTextFormField(
                                hinttext: 'البريد الالكتروني',
                                icon: const Icon(
                                  Icons.email_outlined,
                                  size: 20,
                                ),
                                filledColor: ColorConstants.greyColor,
                                mycontroller:
                                    LoginCubit.get(context).emailController,
                                valid: (text) {
                                  print(text);
                                  if (text!.isEmpty) {
                                    return 'يجب ادخال البريد الالكتروني';
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                              10.verticalSpace,
                              CustomTextFormField(
                                hinttext: 'كلمة المرور',
                                icon: const Icon(
                                  Icons.lock,
                                  size: 20,
                                ),
                                filledColor: ColorConstants.greyColor,
                                obscureText: true,
                                maxLength: 20,
                                mycontroller:
                                    LoginCubit.get(context).passwordController,
                                valid: (text) {
                                  if (text!.isEmpty) {
                                    return 'يجب ادخال كلمة المرور';
                                  }
                                  return null;
                                },
                              ),
                              5.verticalSpace,
                              Align(
                                alignment: Alignment.centerRight,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const ResetPassword(),
                                        ));
                                    ;
                                  },
                                  child: const Text(
                                    'نسيت كلمة المرور؟',
                                    style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: ColorConstants.primaryColor),
                                  ),
                                ),
                              ),
                              10.verticalSpace,
                              ElevatedButton(
                                  onPressed: () {
                                    if (BoardingCubit.get(context)
                                            .selectedOption ==
                                        0) {
                                      LoginCubit.get(context).loginClient();
                                    } else {
                                      LoginCubit.get(context).loginLawyer();
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      fixedSize: Size(1.sw, 50),
                                      backgroundColor:
                                          ColorConstants.primaryColor),
                                  child: state is SigningIn
                                      ? const Center(
                                          child: SizedBox(
                                              height: 20,
                                              width: 20,
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 2,
                                              )))
                                      : const Text(
                                          'تسجيل الدخول',
                                          style: TextStyle(fontSize: 18),
                                        )),
                            ],
                          )),
                    ),
                    Container(
                      alignment: Alignment.topCenter,
                      height: 0.1.sh,
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'لا تملك حساب؟ قم بإنشاء',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black),
                            ),
                            3.horizontalSpace,
                            GestureDetector(
                              onTap: () {
                                if (BoardingCubit.get(context).selectedOption ==
                                    0) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ClientSignUpScreen(),
                                      ));
                                } else {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            LawyerSignupScreen(),
                                      ));
                                }
                              },
                              child: const Text(
                                'حساب جديد',
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: ColorConstants.primaryColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}