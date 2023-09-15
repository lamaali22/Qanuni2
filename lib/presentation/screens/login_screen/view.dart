import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oktoast/oktoast.dart';
import 'package:qanuni/presentation/screens/client_signup_screen/view.dart';
import 'package:qanuni/presentation/widgets/custom_text_form_field.dart';

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
                          SizedBox(
                            height: 0.1.sh,
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
                      height: 0.4.sh,
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
                                  if (text!.isEmpty) {
                                    return 'يجب ادخال البريد الالكتروني';
                                  }
                                  return null;
                                },
                              ),
                              20.verticalSpace,
                              CustomTextFormField(
                                hinttext: 'كلمة المرور',
                                icon: const Icon(
                                  Icons.lock,
                                  size: 20,
                                ),
                                filledColor: ColorConstants.greyColor,
                                obscureText: true,
                                maxLength: 10,
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
                                    'نسيت كلمة المرور؟ قم بإعادة ضبط كلمة المرور',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black),
                                  ),
                                ),
                              ),
                              10.verticalSpace,
                              ElevatedButton(
                                  onPressed: () {
                                    LoginCubit.get(context).login();
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
                    SizedBox(
                      height: 0.2.sh,
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
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ClientSignUpScreen(),
                                    ));
                                ;
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
