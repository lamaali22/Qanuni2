import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qanuni/homePage.dart';
import 'package:qanuni/homePageLawyer.dart';
import 'package:qanuni/presentation/screens/home_screen/view.dart';
import 'package:qanuni/presentation/screens/login_screen/view.dart';
import 'package:qanuni/providers/boarding/cubit/boarding_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../main.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  int? selectedOption;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initShared();
    BoardingCubit.get(context).init();
  }

  initShared() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    selectedOption = sharedPreferences.getInt('selectedOption') ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: StreamBuilder<User?>(
        stream: auth.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData && selectedOption == 0) {
            return LogoutPage();
          } else if (snapshot.hasData && selectedOption == 1) {
            return LogoutPageLawyer();
          }
          return const LoginScreen();
        },
      ),
    );
  }
}
