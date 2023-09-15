import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:qanuni/viewLawyerProfilePage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LawyersList(),
    );
  }
}

class LawyersList extends StatelessWidget {
  String riyal = "ريال";
  //navigation bar method
  void _navigateToScreen(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LawyersList(),
          ),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LawyersList(),
          ),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LawyersList(),
          ),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LawyersList(),
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.teal,
        title: const Text("المحامين",
            style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w500)),
        centerTitle: true,
      ),
      //navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Color(0x7F008080),
        unselectedItemColor: Colors.black,
        showUnselectedLabels: true,
        onTap: (index) => _navigateToScreen(context, index),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'الصفحةالرئيسية',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message_outlined),
            label: 'الرسائل',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined),
            label: 'استشاراتي',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_2_outlined),
            label: 'حسابي',
          ),
        ],
      ),

      body: FutureBuilder(
        future: getLawyers(), // Fetch lawyers from Firebase Firestore
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // Loading indicator
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            List<Lawyer> lawyers = snapshot.data as List<Lawyer>;

            return ListView.builder(
              itemCount: lawyers.length,
              itemBuilder: (context, index) {
                Lawyer lawyer = lawyers[index];
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
                                  '3.8',
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
                    title: Text('${lawyer.firstName} ${lawyer.lastName}',
                        textAlign: TextAlign.right,
                        // Align text to the right
                        style: TextStyle(
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.w500,
                            fontSize: 17)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment
                              .centerRight, // Align specialties text to the right
                          child: Text(lawyer.specialties.join(' | '),
                              style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal)),
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.teal,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              padding: EdgeInsets.all(3),
                              child: Text(
                                '${riyal}${lawyer.consultationPrice}',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Cairo',
                                    fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => viewLawyerProfilePage(lawyer),
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
    );
  }
}

Future<List<Lawyer>> getLawyers() async {
  List<Lawyer> lawyers = [];
  QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('lawyers').get();

  for (QueryDocumentSnapshot doc in querySnapshot.docs) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    Lawyer lawyer = Lawyer.fromMap(data);
    lawyers.add(lawyer);
  }

  return lawyers;
}

class Lawyer {
  final int ID;
  final String firstName;
  final String lastName;
  final List<String> specialties;
  final int consultationPrice;
  final String photoURL;
  final String bio; // URL to the lawyer's photo

  Lawyer({
    required this.ID,
    required this.firstName,
    required this.lastName,
    required this.specialties,
    required this.consultationPrice,
    required this.photoURL,
    required this.bio,
  });

  factory Lawyer.fromMap(Map<String, dynamic> map) {
    return Lawyer(
      ID: map['ID'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      specialties: List<String>.from(map['specialties']),
      consultationPrice: map['consultationPrice'],
      photoURL: map['photoURL'],
      bio: map['bio'],
    );
  }
}
