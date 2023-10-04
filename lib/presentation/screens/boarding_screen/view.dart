import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qanuni/presentation/screens/boarding_screen/widgets/custom_radio.dart';
import 'package:qanuni/presentation/screens/client_signup_screen/view.dart';
import 'package:qanuni/presentation/screens/landing_screen/view.dart';
import 'package:qanuni/presentation/screens/lawyer_signup_screen/view.dart';
import 'package:qanuni/presentation/screens/login_screen/view.dart';
import 'package:qanuni/presentation/widgets/custom_button.dart';
import 'package:qanuni/providers/auth/login/cubit/login_cubit.dart';
import 'package:qanuni/providers/boarding/cubit/boarding_cubit.dart';
import 'package:qanuni/utils/colors.dart';
import 'package:qanuni/utils/images.dart';

class BoardingScreen extends StatelessWidget {
  const BoardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BoardingCubit, BoardingState>(
      builder: (context, state) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.bottomRight,
                  height: 0.1.sh,
                  width: 1.sw,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.chevron_right_outlined,
                      size: 30,
                    ),
                  ),
                ),
                SizedBox(
                  width: 0.4.sw,
                  height: 0.4.sw,
                  child: Image.asset(ImageConstants.logo),
                ),
                20.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      ImageConstants.qan,
                      color: Colors.black,
                    ),
                    3.horizontalSpace,
                    Image.asset(
                      ImageConstants.uni,
                      color: Colors.black,
                    ),
                  ],
                ),
                40.verticalSpace,
                GestureDetector(
                  onTap: () {
                    BoardingCubit.get(context).selectOption(0);
                  },
                  child: CustomRadioButton(
                      value: 0,
                      groupValue:
                          BoardingCubit.get(context).selectedOption != null
                              ? BoardingCubit.get(context).selectedOption!
                              : 2,
                      onChangeFunction: BoardingCubit.get(context).selectOption,
                      title: 'أنا مستفيد',
                      content: 'أبحث عن استشارة مع محامي'),
                ),
                10.verticalSpace,
                GestureDetector(
                  onTap: () {
                    BoardingCubit.get(context).selectOption(1);
                  },
                  child: CustomRadioButton(
                      value: 1,
                      groupValue:
                          BoardingCubit.get(context).selectedOption != null
                              ? BoardingCubit.get(context).selectedOption!
                              : 2,
                      onChangeFunction: BoardingCubit.get(context).selectOption,
                      title: 'أنا محامي',
                      content: 'أود تقديم الاستشارات القانونية'),
                ),
                Spacer(),
                ElevatedButton(
                    onPressed: () {
                      if (BoardingCubit.get(context).selectedOption != null) {
                        if (BoardingCubit.get(context).selectedOption == 0) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ClientSignUpScreen(),
                              )).then((value) {
                            LoginCubit.get(context).reset();
                          });
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const LawyerSignupScreen(),
                              )).then((value) {
                            LoginCubit.get(context).reset();
                          });
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        fixedSize: Size(1.sw, 50),
                        backgroundColor:
                            BoardingCubit.get(context).selectedOption != null
                                ? ColorConstants.primaryColor
                                : ColorConstants.primaryColor.withOpacity(0.5)),
                    child: Text(
                      'ابدأ',
                      style: TextStyle(fontSize: 18),
                    )),
                SizedBox(
                  height: 0.1.sh,
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
