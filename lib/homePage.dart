import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qanuni/Notifications.dart';
import 'package:qanuni/consultationFromClient.dart';
import 'package:qanuni/lib/chatbot/chatbotMain.dart';
import 'package:qanuni/presentation/screens/boarding_screen/view.dart';
import 'package:qanuni/presentation/screens/client_signup_screen/view.dart';
import 'package:qanuni/presentation/screens/home_screen/view.dart';
import 'package:qanuni/presentation/screens/login_screen/view.dart';
import 'package:qanuni/utils/colors.dart';
import 'package:qanuni/viewListOfLawyers.dart';
import 'package:intl/intl.dart';
import 'package:qanuni/ClientProfile.dart';
import 'package:timezone/data/latest.dart' as tz;

class LogoutPage extends StatefulWidget {
  @override
  _LogoutPageState createState() => _LogoutPageState();
}

class _LogoutPageState extends State<LogoutPage> {
  String? email = "";
  Future<void> getEmailAndUpdateToken() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      email = user.email!;
      print('User email: $email');
      Token().updateTokenInDB(email, true, "Clients");
    }
  }

  @override
  void initState() {
    super.initState();

    Notifications().requestPermission;
    Notifications().onRecieveReminderNotification(context, "client");
    Notifications().setupInteractMessageReminder(context, "client");

    getEmailAndUpdateToken();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
//navigation bar method
  void _navigateToScreen(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => ClientProfile()),
          (route) => false,
        );
        break;
      case 1:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => BookingClientScreen()),
          (route) => false,
        );
        break;
      case 2:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LogoutPage()),
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
              // Center(
              //   child: IconButton(
              //     icon: Icon(
              //       Icons.exit_to_app,
              //       color: Colors.white,
              //       size: 30,
              //     ),
              //     onPressed: () async {
              //       Token().updateTokenInDB(email, false, "Clients");
              //       await _auth.signOut();
              //       Navigator.pushReplacement(
              //         context,
              //         MaterialPageRoute(
              //           builder: (context) =>
              //               LoginScreen(), // go to sign in page
              //         ),
              //       ); // Replace '/login' with your login screen route
              //     },
              //   ),
              // ),
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
                          height: 2.4,
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
      ), //appbar

      //navigation bar
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Color(0x7F008080), // Color for selected item
        unselectedItemColor: Colors.black, // Color for unselected items
        onTap: (index) => _navigateToScreen(context, index),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.person_2_outlined),
            label: 'حسابي',
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
      body: Stack(children: [
        //
        Align(
          alignment: Alignment.topCenter,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30, left: 30),
                child: Container(
                  width: 337,
                  height: 200,
                  clipBehavior: Clip.antiAlias,
                  decoration: ShapeDecoration(
                    gradient: LinearGradient(
                      begin: Alignment(
                        4,
                        1,
                      ),
                      end: Alignment(-0.85, -1),
                      colors: [
                        Color(0xFF33CCBE),
                        Color(0xFF93E6DE),
                        Colors.white.withOpacity(0)
                      ],
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    shadows: [
                      BoxShadow(
                        color: Color(0x26008592),
                        blurRadius: 20,
                        offset: Offset(0, 10),
                        spreadRadius: 0,
                      )
                    ],
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        left: 80,
                        top: 16,
                        child: Text(
                          '!دليلك القانوني للقرارات الصائبة',
                          style: TextStyle(
                            color: Color(0xFF006771),
                            fontSize: 20,
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.w700,
                            height: 0,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 165,
                        top: 49,
                        child: SizedBox(
                          width: 148,
                          child: Text(
                            'محتار في تحديد نوع مشكلتك القانونية وتحتاج مساعدة؟ اسأل روبوت قانوني ',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Color(0xFF005159),
                              fontSize: 15,
                              fontFamily: 'Cairo',
                              fontWeight: FontWeight.w500,
                              height: 0,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 156,
                        top: 150,
                        child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            clipBehavior: Clip.antiAlias,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              shadows: [
                                BoxShadow(
                                  color: Color(0x33005159),
                                  blurRadius: 20,
                                  offset: Offset(0, 10),
                                  spreadRadius: 0,
                                )
                              ],
                            ),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => chatbotMain(),
                                  ),
                                );
                              },
                              child: Container(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'اسأل روبوت قانوني',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Color(0xFF00616B),
                                        fontSize: 12,
                                        fontFamily: 'Cairo',
                                        fontWeight: FontWeight.w800,
                                        height: 0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )),
                      ),
                      Positioned(
                        left: 17,
                        top: 49,
                        child: Container(
                          width: 130,
                          height: 127,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/robot.png'),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        //
        Column(
          children: [
            SizedBox(
              height: 300,
            ),
            Align(
              alignment: Alignment.topRight,
              child: Text(
                'التخصصات    ',
                style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w600,
                    color: Color.fromARGB(255, 24, 21, 74)),
              ),
            ),
            Row(children: [
              SizedBox(
                width: 19,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LawyersList("الكل"),
                    ),
                  );
                },
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'جميع المحامين >',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: ColorConstants.primaryColor,
                    ),
                  ),
                ),
              ),
            ]),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 1,
                ),
                InkWell(
                  //القانون الدولي
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LawyersList("القانون الدولي"),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/Speciality4.png',
                        width: 75, // Set the desired width
                        height: 75, // Set the desired height
                      ),
                      Text(
                        '',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  //القانون التجاري
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LawyersList("القانون التجاري"),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/Speciality3.png',
                        width: 75, // Set the desired width
                        height: 75, // Set the desired height
                      ),
                      Text(
                        '',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  //قانون العمل
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LawyersList("قانون العمل"),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/Speciality2.png',
                        width: 75, // Set the desired width
                        height: 75, // Set the desired height
                      ),
                      Text(
                        '',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  //مدني
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LawyersList("القانون المدني"),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/Speciality1.png',
                        width: 75, // Set the desired width
                        height: 75, // Set the desired height
                      ),
                      Text(
                        '',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 1,
                ),
              ],
            ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 1,
                ),
                InkWell(
                  //القانون المالي
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LawyersList("القانون المالي"),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/Speciality5.png',
                        width: 75, // Set the desired width
                        height: 75, // Set the desired height
                      ),
                      Text(
                        '',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  //القانون الجنائي
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LawyersList("القانون الجنائي"),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/Speciality6.png',
                        width: 75, // Set the desired width
                        height: 75, // Set the desired height
                      ),
                      Text(
                        '',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  //مواريث
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LawyersList("قانون المواريث"),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/Speciality7.png',
                        width: 75, // Set the desired width
                        height: 75, // Set the desired height
                      ),
                      Text(
                        '',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  //القانون الاداري
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LawyersList("القانون الإداري"),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/Speciality8.png',
                        width: 75, // Set the desired width
                        height: 75, // Set the desired height
                      ),
                      Text(
                        '',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 1,
                ),
              ],
            ),
          ],
        )
      ]),
    );
  }
}
