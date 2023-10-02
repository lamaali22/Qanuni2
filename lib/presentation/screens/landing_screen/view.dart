import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:qanuni/homePage.dart';
=======
<<<<<<< HEAD
import 'package:qanuni/presentation/screens/client_home_screen/view.dart';
=======
>>>>>>> main
import 'package:qanuni/homePageLawyer.dart';
import 'package:qanuni/presentation/screens/home_screen/view.dart';
>>>>>>> 558fb5e9d5e63aeadb5468a01c480d9b507e7b6e
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
            return  LogoutPage();
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
