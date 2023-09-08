/*import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LawyersList(),
    );
  }
}

class LawyersList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lawyers'),
      ),
      body: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return ListTile(
            // leading: /* Lawyer's photo */,
            title: Text("/* Lawyer's name */"),
            subtitle: Text("/* Lawyer's specialties */"),
            trailing: Text("/* Price of consultation */"),
            onTap: () {
              // Navigate to LawyerProfile with lawyer details
            },
          );
        },
      ),
    );
  }
}*/
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("المحامين"),
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
                return ListTile(
                  trailing: Image.network(
                      lawyer.photoURL), // Use the lawyer's photo URL
                  title: Text(
                    '${lawyer.firstName} ${lawyer.lastName}',
                    textAlign: TextAlign.right, // Align text to the right
                  ),
                  subtitle: Text(
                    lawyer.specialties.join('، '),
                    textAlign: TextAlign.right, // Align text to the right
                  ),
                  leading: Text(
                    ' ${lawyer.consultationPrice}',
                    textAlign: TextAlign.end, // Align text to the right
                  ),
                  onTap: () {
                    /*
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LawyerProfile(lawyer),
                      ),
                    );*/
                  },
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
  final String photoURL; // URL to the lawyer's photo

  Lawyer({
    required this.ID,
    required this.firstName,
    required this.lastName,
    required this.specialties,
    required this.consultationPrice,
    required this.photoURL,
  });

  factory Lawyer.fromMap(Map<String, dynamic> map) {
    return Lawyer(
      ID: map['ID'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      specialties: List<String>.from(map['specialties']),
      consultationPrice: map['consultationPrice'],
      photoURL: map['photoURL'],
    );
  }
}
