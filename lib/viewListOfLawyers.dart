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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("المحامين" ,
          style: TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.w500
            )
            ),
        centerTitle: true,
        
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
                      color: Colors.grey.withOpacity(0.3), // Adjust the border color
                      width: 1.0, // Adjust the border width
                    ),
                  ),
                  child: ListTile(
                    leading: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.star,
                          color: Colors.yellow,
                        ),
                        SizedBox(width: 4), // Adjust spacing as needed
                        Text(
                          '3.8', // Replace with the actual number
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Cairo'
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
                    title: Text(
                      '${lawyer.firstName} ${lawyer.lastName}',
                      textAlign: TextAlign.right,
                       // Align text to the right
                       style: TextStyle(
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.w500,
                        fontSize: 17)
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment
                              .centerRight, // Align specialties text to the right
                          child: Text(
                            lawyer.specialties.join(' | '),
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 12,
                              fontWeight: FontWeight.normal
                              )
                            
                          ),
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
                                  fontSize: 12
                                ),
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
