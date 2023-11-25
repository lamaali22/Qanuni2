import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qanuni/EditProfileLawyer.dart';
import 'package:qanuni/consultationLawyer.dart';
import 'package:qanuni/homePage.dart';
import 'package:qanuni/homePageLawyer.dart';
import 'package:qanuni/lawyerProfile.dart';
import 'package:qanuni/presentation/screens/home_screen/view.dart';

class MyProfile_Lawyer extends StatefulWidget {
  @override
  State<MyProfile_Lawyer> createState() => _MyProfile_LawyerState();
}

Lawyer lawyer = Lawyer(
    firstName: '',
    lastName: '',
    dateOfBirth: '',
    password: '',
    phone: '',
    gender: '',
    licenseNumber: '',
    iban: '',
    token: '',
    specialties: [],
    price: '1',
    photoURL: '',
    bio: '',
    email: '',
    AverageRating: '1');

Future<Lawyer> getLawyer(String? email) async {
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('lawyers')
      .where('email', isEqualTo: email)
      .get();

  for (QueryDocumentSnapshot doc in querySnapshot.docs) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    lawyer = Lawyer.fromMap(data);
    print(
        'Lawyer Data: ${lawyer.firstName}, ${lawyer.lastName}, ${lawyer.photoURL}, ${lawyer.specialties}');
  }
  await Future.delayed(Duration(seconds: 6));

  return lawyer;
}

class _MyProfile_LawyerState extends State<MyProfile_Lawyer> {
  late User? _user; // To store the currently logged-in user
  String? email = "";
  @override
  void initState() {
    super.initState();
    // Initialize the user using Firebase Authentication
    _user = FirebaseAuth.instance.currentUser;
    email = _user?.email;
    // getLawyerInfo(email!);
    print(
        'Lawyer Data: ${lawyer.firstName}, ${lawyer.lastName}, ${lawyer.photoURL}, ${lawyer.specialties}');
  }

  String riyal = "ريال";
  String formatNumber(int number) {
    return NumberFormat.decimalPattern('ar_EG').format(number);
  }

  //navigation bar method
  void _navigateToScreen(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => ViewProfileLawyer()),
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
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            padding: EdgeInsets.only(right: 30),
            alignment: Alignment.centerRight,
            icon: Icon(Icons.arrow_forward, color: Colors.teal),
            onPressed: () {
              Navigator.pop(context);
              // Navigate back to the previous page
            },
          ),
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment(20, 0),
              colors: [Color(0x21008080), Colors.white.withOpacity(0)],
            ),
          ),
        ),
      ),

      //navigation bar
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Color(0x7F008080),
        unselectedItemColor: Colors.black,
        showUnselectedLabels: true,
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

      body: FutureBuilder(
        future: getLawyer(email),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While data is loading, display a loading indicator
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            // If an error occurs, display an error message
            return Text('Error: ${snapshot.error}');
          } else {
            // Once data is available, display it in your UI
            final lawyer = snapshot.data!;
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment(0, -1),
                  end: Alignment(0, 0),
                  colors: [Color(0x21008080), Colors.white.withOpacity(0)],
                ),
              ),
              child: SafeArea(
                  child: Stack(children: [
                ListView(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipOval(
                            child: Image.network(
                          lawyer.photoURL,
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'assets/default_photo.jpg',
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                            );
                          },
                        )),
                      ],
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${lawyer.firstName} ${lawyer.lastName}',
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Cairo',
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${formatNumber(int.parse(lawyer.price))}' +
                              '${riyal}',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.699999988079071),
                            fontSize: 14.0,
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.w800,
                            height: 2,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5.0,
                    )

                    //rating box
                    ,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 42,
                          height: 18,
                          child: Stack(
                            children: [
                              Positioned(
                                left: 0,
                                top: 0,
                                child: Container(
                                  width: 42,
                                  height: 18,
                                  decoration: ShapeDecoration(
                                    color: Color(0x26FFC126),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(6)),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 2.0,
                                top: 0,
                                child: Icon(
                                  Icons.star,
                                  size: 17.0,
                                  color: Colors.amber[400],
                                ),
                              ),
                              Positioned(
                                left: 20.40,
                                top: 2.40,
                                child: Text(
                                  '${lawyer.AverageRating}',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13.02,
                                    fontFamily: 'Cairo',
                                    fontWeight: FontWeight.w400,
                                    height: 1,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(
                      height: 15.0,
                    )

                    //specality box
                    ,
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: lawyer.specialties.map((specialty) {
                            return Container(
                              constraints: BoxConstraints(minWidth: 50),
                              height: 24,
                              margin: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              decoration: BoxDecoration(
                                color: Color(0x7F008080),
                                borderRadius: BorderRadius.circular(11.74),
                              ),
                              child: Text(
                                specialty,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontFamily: 'Cairo',
                                  fontWeight: FontWeight.w500,
                                  height: 0,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                    //end specality box

                    SizedBox(
                      height: 15.0,
                    ),
                    Expanded(
                      child: Container(
                        width: double
                            .infinity, // Set the desired width of the container
                        padding: EdgeInsets.all(
                            20), // Set the padding around the container content

                        decoration: ShapeDecoration(
                          color: Color.fromARGB(255, 255, 255, 255),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                            ),
                          ),
                          shadows: [
                            BoxShadow(
                              color: Color(0x0C000000),
                              blurRadius: 40,
                              offset: Offset(0, -5),
                              spreadRadius: 0,
                            )
                          ],
                        ),

                        //inside box

                        child: Column(
                          mainAxisSize: MainAxisSize
                              .min, // Limit the vertical size of the column to its content

                          crossAxisAlignment: CrossAxisAlignment.end,

                          children: [
                            Text(
                              'السيرة الذاتية',
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            //Bio

                            Padding(
                                padding: EdgeInsets.only(right: 20),
                                child: Text(
                                  '${lawyer.bio}',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                  ),
                                )),
                            SizedBox(height: 7),

                            // Divider(
                            //   thickness: 0.5,
                            // ), // Add a vertical spacing between the text and buttons

                            // Text(
                            //   'المراجعات',
                            //   textAlign: TextAlign.right,
                            //   style: TextStyle(
                            //     fontFamily: 'Cairo',
                            //     fontSize: 16,
                            //     fontWeight: FontWeight.w600,
                            //   ),
                            // ),
                            // Row(
                            //   children: [
                            //     TextButton(
                            //       onPressed: () {
                            //         // Handle button press
                            //       },
                            //       child: Text(
                            //         'رؤية الكل',
                            //         style: TextStyle(
                            //             fontFamily: 'Cairo',
                            //             fontSize: 15,
                            //             fontWeight: FontWeight.w600,
                            //             decoration: TextDecoration.underline,
                            //             color: Colors.teal),
                            //       ),
                            //     ),
                            //     Expanded(
                            //       child: Align(
                            //         alignment: Alignment.centerRight,
                            //         child: Text(
                            //           'المراجعات',
                            //           textAlign: TextAlign.right,
                            //           style: TextStyle(
                            //             fontFamily: 'Cairo',
                            //             fontSize: 16,
                            //             fontWeight: FontWeight.w600,
                            //           ),
                            //         ),
                            //       ),
                            //     ),
                            //   ],
                            // ),

                            SizedBox(
                                height:
                                    8), // Add a vertical spacing between buttons

                            //Book button
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: 30,
                  left: 30,
                  child: GestureDetector(
                    onTap: () {
                      // Handle the edit icon tap
                      print('Edit icon tapped');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AccountInfoScreenLawyer(),
                        ),
                      );
                      // Add your edit logic here
                    },
                    child: Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 164, 203, 203),
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            offset: Offset(0, 10), // Y-axis offset of 10
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.edit,
                        size: 24,
                        color: Color(0xFF008080),
                      ),
                    ),
                  ),
                ),
              ])),
            );
          }
        },
      ),
    ));
  }
}

class Lawyer {
  //final int ID;
  final String firstName;
  final String lastName;
  final String dateOfBirth; // changed to string مبدأيا
  final List<String> specialties;
  final String price;
  final String photoURL;
  final String bio; // URL to the lawyer's photo
  String email;
  String password;
  final String AverageRating;
  final String phone; //not sure if it's string
  final String gender;
  final String licenseNumber;
  final String iban;
  final String token;

  Lawyer({
    // required this.ID,
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    required this.password,
    required this.phone,
    required this.gender,
    required this.licenseNumber,
    required this.iban,
    required this.token,
    required this.specialties,
    required this.price,
    required this.photoURL,
    required this.bio,
    required this.email,
    required this.AverageRating,
  });

  factory Lawyer.fromMap(Map<String, dynamic> map) {
    return Lawyer(
        // ID: map['ID'],
        firstName: map['firstName'],
        lastName: map['lastName'],
        dateOfBirth: map["dateOfBirth"],
        password: map['password'],
        phone: map['phoneNumber'],
        gender: map['gender'],
        licenseNumber: map['licenseNumber'],
        iban: map['iban'],
        token: map['token'],
        specialties: List<String>.from(map['specialties']),
        price: map['price'],
        photoURL: map['photoURL'],
        bio: map['bio'],
        email: map['email'],
        AverageRating: map['AverageRating']);
  }
}
