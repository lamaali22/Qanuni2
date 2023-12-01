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
import 'package:qanuni/viewLawyerProfilePage.dart';
import 'package:qanuni/viewListOfLawyers.dart';
import 'package:intl/intl.dart';
import 'package:qanuni/ClientProfile.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'dart:math' as math;

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
        child: SafeArea(
          // Wrap the AppBar with SafeArea
          child: Container(
            width: double.infinity,
            height: 90,
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 17),
            decoration: const ShapeDecoration(
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
                const Expanded(
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
                            height: 0.1,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
        ),
      ), //appbar

      //navigation bar

      bottomNavigationBar: BottomNavigationBar(
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
            icon: Icon(
              Icons.home_outlined,
              color: Colors.teal,
            ),
            label: 'الصفحة الرئيسية',
          ),
        ],
        unselectedItemColor: Colors.black,
        selectedItemColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Stack(children: [
          //
          Align(
            alignment: Alignment.topCenter,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15, left: 30),
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
                              'محتار في تحديد نوع مشكلتك القانونية وتحتاج مساعدة؟    ',
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                height: 230,
              ),
              Align(
                alignment: Alignment.topRight,
                child: Text(
                  'المحامين الاعلى تقييمًا    ',
                  style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w600,
                      color: Color.fromARGB(255, 24, 21, 74)),
                ),
              ),
              TopLawyersList(),
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
                    alignment: Alignment.bottomRight,
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
              SizedBox(height: 10),
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
              SizedBox(height: 20),
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
      ),
    );
  }
}

class TopLawyersList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance
          .collection('lawyers')
          .orderBy('AverageRating', descending: true)
          .limit(3)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Container(); // Return an empty container if no lawyers found
        }

        var sortedList = snapshot.data!.docs.toList()
          ..sort((a, b) {
            var ratingA = double.tryParse(a['AverageRating'] ?? '0') ?? 0;
            var ratingB = double.tryParse(b['AverageRating'] ?? '0') ?? 0;
            return ratingB.compareTo(ratingA);
          });

        return Container(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            reverse: true, // Set reverse to true
            itemCount: sortedList.length,
            itemBuilder: (context, index) {
              var lawyerData = sortedList[index].data() as Map<String, dynamic>;

              // Convert AverageRating to double
              double rating =
                  double.tryParse(lawyerData['AverageRating'] ?? '0') ?? 0;

              return GestureDetector(
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => viewLawyerProfilePage(lawyer),
                  //   ),
                  // );
                },
                child: Container(
                  margin: EdgeInsets.all(8),
                  width: 170, // Adjust the width as needed
                  child: Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment:
                          MainAxisAlignment.end, // Align from right to left
                      children: [
                        Flexible(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment
                                .end, // Align text to the right
                            children: [
                              Text(
                                '${lawyerData['firstName']} ${lawyerData['lastName']}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 4),
                              // Display rating as stars here
                              RatingBar.builder(
                                initialRating: rating,
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemSize: 16,
                                itemPadding:
                                    EdgeInsets.symmetric(horizontal: 1.0),
                                itemBuilder: (context, index) => Transform(
                                  transform: Matrix4.rotationY(
                                      math.pi), // Rotate the stars
                                  alignment: Alignment.center,
                                  child: Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                ),
                                onRatingUpdate: (rating) {
                                  // Empty function, making the RatingBar non-editable
                                },
                                ignoreGestures:
                                    true, // Make the RatingBar non-editable
                              ),
                            ],
                          ),
                        ),
                        // Keep the padding for the image
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 8,
                              right: 8), // Adjust the padding as needed
                          child: ClipOval(
                            child: Image.network(
                              lawyerData['photoURL'],
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  'assets/default_photo.jpg',
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
// Future<List<lawyer>> getLawyers() async {
//   List<lawyer> lawyers = [];
//   QuerySnapshot querySnapshot =
//       await FirebaseFirestore.instance.collection('lawyers').get();

//   for (QueryDocumentSnapshot doc in querySnapshot.docs) {
//     Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
//     lawyers lawyer = lawyer.fromMap(data);
//     lawyers.add(lawyer);
//   }

//   return lawyers;
// }

// class lawyer {
//   final int ID;
//   final String firstName;
//   final String lastName;
//   final List<String> specialties;
//   final int consultationPrice;
//   final String photoURL;
//   final String bio; // URL to the lawyer's photo

//   lawyer({
//     required this.ID,
//     required this.firstName,
//     required this.lastName,
//     required this.specialties,
//     required this.consultationPrice,
//     required this.photoURL,
//     required this.bio,
//   });

//   factory lawyer.fromMap(Map<String, dynamic> map) {
//     return lawyer(
//       ID: map['ID'],
//       firstName: map['firstName'],
//       lastName: map['lastName'],
//       specialties: List<String>.from(map['specialties']),
//       consultationPrice: map['consultationPrice'],
//       photoURL: map['photoURL'],
//       bio: map['bio'],
//     );
//   }
// }


// class TopLawyersList extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<QuerySnapshot>(
//       future: FirebaseFirestore.instance
//           .collection('lawyers')
//           .orderBy('AverageRating', descending: true)
//           .limit(3)
//           .get(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(child: CircularProgressIndicator());
//         }

//         if (snapshot.hasError) {
//           return Center(child: Text('Error: ${snapshot.error}'));
//         }

//         if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//           return Container(); // Return an empty container if no lawyers found
//         }

//         return Container(
//           height: 120,
//           child: ListView.builder(
//             scrollDirection: Axis.horizontal,
//             itemCount: snapshot.data!.docs.length,
//             itemBuilder: (context, index) {
//               var lawyerData =
//                   snapshot.data!.docs[index].data() as Map<String, dynamic>;

//               // Convert AverageRating to double
//               double rating =
//                   double.tryParse(lawyerData['AverageRating'] ?? '0') ?? 0;

//               return GestureDetector(
//                 onTap: () {
//                   // Navigate to a new page with detailed information about the lawyer
//                   // You can replace LawyerDetailPage with the actual page you want to navigate to
//                   // Navigator.push(
//                   //   context,
//                   //   MaterialPageRoute(
//                   //     builder: (context) => LawyerDetailPage(
//                   //       // Pass necessary data to LawyerDetailPage
//                   //       lawyerId: snapshot.data!.docs[index].id,
//                   //       firstName: lawyerData['firstName'],
//                   //       lastName: lawyerData['lastName'],
//                   //       rating: rating,
//                   //     ),
//                   //   ),
//                   // );
//                 },
//                 child: Container(
//                   margin: EdgeInsets.all(8),
//                   width: 100,
//                   child: Column(
//                     children: [
//                       // Display lawyer's photo here if available
//                       ClipOval(
//                           child: Image.network(
//                         lawyerData['photoURL'],
//                         width: 60,
//                         height: 60,
//                         fit: BoxFit.cover,
//                         errorBuilder: (context, error, stackTrace) {
//                           return Image.asset(
//                             'assets/default_photo.jpg',
//                             width: 60,
//                             height: 60,
//                             fit: BoxFit.cover,
//                           );
//                         },
//                       )),
//                       SizedBox(height: 8),
//                       Text(
//                         '${lawyerData['firstName']} ${lawyerData['lastName']}',
//                         style: TextStyle(fontSize: 12, color: Colors.black),
//                         textAlign: TextAlign.center,
//                       ),
//                       SizedBox(height: 4),
//                       // Display rating as stars here
//                       RatingBar.builder(
//                         initialRating: rating,
//                         minRating: 1,
//                         direction: Axis.horizontal,
//                         allowHalfRating: true,
//                         itemCount: 5,
//                         itemSize: 12,
//                         itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
//                         itemBuilder: (context, _) => Icon(
//                           Icons.star,
//                           color: Colors.amber,
//                         ),
//                         onRatingUpdate: (rating) {
//                           print(rating);
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//         );
//       },
//     );
//   }
//}
