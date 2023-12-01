import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qanuni/ClientProfile.dart';
import 'package:qanuni/consultationFromClient.dart';
import 'package:qanuni/firebase_options.dart';
import 'package:qanuni/homePage.dart';
import 'package:qanuni/presentation/screens/home_screen/view.dart';
import 'package:qanuni/presentation/widgets/custom_text_form_field.dart';
import 'package:qanuni/viewLawyerProfilePage.dart';
import 'package:intl/intl.dart';
import 'package:intl/locale.dart';
import 'dart:ui' as ui;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LawyersList(""),
    );
  }
}

class LawyersList extends StatefulWidget {
  final String speciality;
  LawyersList(this.speciality);

  @override
  State<LawyersList> createState() => _LawyersListState();
}

class _LawyersListState extends State<LawyersList> {
  String riyal = "ريال";
  TextEditingController searchController = TextEditingController();
  List<Lawyer> lawyers = [];
  List<Lawyer> searchedLawyers = [];
// Convert English number to Arabic
  String formatNumber(int number) {
    return NumberFormat.decimalPattern('ar_EG').format(number);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchController.addListener(() {
      setState(() {});
    });
  }

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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(255, 0, 128, 128),
        title: Text("محامين ${widget.speciality}",
            style: TextStyle(
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w500,
                color: Colors.white)),
        centerTitle: true,
        actions: [
          IconButton(
            padding: EdgeInsets.only(right: 30),
            alignment: Alignment.centerRight,
            icon: Icon(Icons.arrow_forward, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      //navigation bar
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.black,
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

      body: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.grey)),
            child: Directionality(
              textDirection: ui.TextDirection.rtl,
              child: Row(children: [
                15.horizontalSpace,
                Image.asset(
                  'assets/images/search.png',
                  height: 30,
                  width: 30,
                  color: Colors.grey,
                ),
                5.horizontalSpace,
                Expanded(
                  child: TextField(
                    controller: searchController,
                    inputFormatters: [FilteringTextInputFormatter.deny('  ')],
                    style: TextStyle(color: Colors.black),
                    expands: true,
                    minLines: null,
                    maxLines: null,
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      isCollapsed: true,
                      hintText: 'بحث',
                    ),
                  ),
                )
              ]),
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: getLawyers(
                  widget.speciality), // Fetch lawyers from Firebase Firestore
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: CircularProgressIndicator()); // Loading indicator
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  lawyers = snapshot.data as List<Lawyer>;
                  if (searchController.text.isNotEmpty) {
                    if (lawyers.isNotEmpty) {
                      searchedLawyers = lawyers
                          .where((element) => (element.firstName +
                                  ' ' +
                                  element.lastName)
                              .toString()
                              .toLowerCase()
                              .contains(searchController.text.toLowerCase()))
                          .toList();
                    } else {
                      searchedLawyers = [];
                    }
                  } else {
                    searchedLawyers = [];
                  }
                  if (lawyers.isEmpty) {
                    return Center(
                        child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.teal),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white),
                      child: Text(
                        "نعتذر, لا يوجد محامين بهذا الاختصاص في الوقت الحالي",
                        style: TextStyle(
                          color: Colors.teal,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ));
                  } else
                    return ListView.builder(
                      itemCount: searchController.text.isNotEmpty
                          ? searchedLawyers.length
                          : lawyers.length,
                      itemBuilder: (context, index) {
                        Lawyer lawyer = searchController.text.isNotEmpty
                            ? searchedLawyers[index]
                            : lawyers[index];
                        return Container(
                          margin: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            border: Border.all(
                              color: Colors.grey
                                  .withOpacity(0.3), // Adjust the border color
                              width: 1.0, // Adjust the border width
                            ),
                          ),
                          child: ListTile(
                            leading: Row(
                              mainAxisSize: MainAxisSize.min,
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
                                                borderRadius:
                                                    BorderRadius.circular(6)),
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
                            trailing: ClipOval(
                                child: Image.network(
                              lawyer.photoURL,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  'assets/default_photo.jpg',
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                );
                              },
                            )),
                            title:
                                Text('${lawyer.firstName} ${lawyer.lastName}',
                                    textAlign: TextAlign.right,
                                    // Align text to the right
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Cairo',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 17,
                                    )),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Align(
                                  alignment: Alignment
                                      .centerRight, // Align specialties text to the right
                                  child: Text(lawyer.specialties.join(' | '),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'Cairo',
                                          fontSize: 12,
                                          fontWeight: FontWeight.normal)),
                                ),
                                SizedBox(height: 1),
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Container(
                                    decoration: BoxDecoration(),
                                    child: Text(
                                      '${formatNumber(int.parse(lawyer.price))}' +
                                          '${riyal}',
                                      style: TextStyle(
                                          color: Colors.teal,
                                          fontFamily: 'Cairo',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      viewLawyerProfilePage(lawyer),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

Future<List<Lawyer>> getLawyers(String speciality) async {
  List<Lawyer> lawyers = [];

  print("speciality" + speciality);
  if (speciality != "الكل") {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('lawyers')
        .orderBy('AverageRating', descending: true)
        .get();

    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      Lawyer lawyer = Lawyer.fromMap(data);
      if (lawyer.specialties.contains(speciality)) {
        lawyers.add(lawyer);
        print(
            'Lawyer Data: ${lawyer.firstName}, ${lawyer.lastName}, ${lawyer.photoURL}, ${lawyer.specialties} ,${lawyer.specialties.length} ');
      }
    }
  } else {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('lawyers')
        .orderBy('AverageRating', descending: true)
        .get();

    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      Lawyer lawyer = Lawyer.fromMap(data);
      lawyers.add(lawyer);
      print(
          'Lawyer Data: ${lawyer.firstName}, ${lawyer.lastName}, ${lawyer.photoURL}, ${lawyer.specialties}');
    }
  }

  return lawyers;
}

class Lawyer {
  //final int ID;
  final String firstName;
  final String lastName;
  final List<String> specialties;
  final String price;
  final String photoURL;
  final String bio; // URL to the lawyer's photo
  final String email;
  final String AverageRating;

  Lawyer({
    // required this.ID,
    required this.firstName,
    required this.lastName,
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
        specialties: List<String>.from(map['specialties']),
        price: map['price'],
        photoURL: map['photoURL'],
        bio: map['bio'],
        email: map['email'],
        AverageRating: map['AverageRating']);
  }
}
