import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qanuni/homePageLawyer.dart';
import 'package:qanuni/presentation/screens/home_screen/view.dart';
import 'package:qanuni/presentation/screens/login_screen/view.dart';
import 'package:qanuni/providers/boarding/cubit/boarding_cubit.dart';

import '../../../main.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: StreamBuilder<User?>(
        stream: auth.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData && BoardingCubit.get(context).selectedOption == 0 ) {
            return const HomeScreen();
          }
          else {
          if(snapshot.hasData && BoardingCubit.get(context).selectedOption == 1) {
            return LogoutPageLawyer();
          }
        
          }
          return const LoginScreen();
        },
      ),
    );
  }
}
