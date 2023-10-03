import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qanuni/consultationList.dart';
import 'package:qanuni/presentation/screens/client_signup_screen/view.dart';

import 'package:qanuni/presentation/screens/login_screen/view.dart';
import 'package:qanuni/viewListOfLawyers.dart';

class LogoutPageLawyer extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
void _navigateToScreen(BuildContext context, int index) {
  switch (index) {
    case 0:
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LogoutPageLawyer()),
        (route) => false,
      );
      break;
    case 1:
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => BookingListScreen()),
        (route) => false,
      );
      break;
    case 2:
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LogoutPageLawyer()),
        (route) => false,
      );
      break;
   
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(83),
        child: Container(
          width: double.infinity,
          height: 90,
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 17),
          decoration: ShapeDecoration(
            color: Color(0xFF008080),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: IconButton(
                  icon: Icon(
                    Icons.exit_to_app,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: () async {
                    await _auth.signOut();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            LoginScreen(), // go to sign in page
                      ),
                    ); // Replace '/login' with your login screen route
                  },
                ),
              ),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '👋🏼 أهلاً \n ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.12,
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.w500,
                          height: 1.4,
                        ),
                      ),
                      // TextSpan(
                      //   text: 'محمد الصالح',
                      //   style: TextStyle(
                      //     color: Colors.white,
                      //     fontSize: 18.12,
                      //     fontFamily: 'Cairo',
                      //     fontWeight: FontWeight.w600,
                      //     height: 0.06,
                      //   ),
                      // ),
                    ],
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        ),
      ),
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Color(0x7F008080),
          unselectedItemColor: Colors.black,
          showUnselectedLabels: true,
          onTap: (index) => _navigateToScreen(context, index),
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.person_2_outlined),
              label: 'جسابي',
            ),
            
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month_outlined),
              label: 'مواعيدي',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'الصفحة الرئيسية',
            ),
          ],
        ),
    );
  }
}
