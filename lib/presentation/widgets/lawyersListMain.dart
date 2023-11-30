import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LawyerListWidget extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Lawyer>> _fetchLawyers() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _firestore.collection('lawyers')
        .orderBy('AverageRating', descending: true)
        .get();

    List<Lawyer> lawyers = snapshot.docs
        .map((doc) => Lawyer(
              name: doc['firstName'],
              photoUrl: doc['photoURL'],
              rating: doc['AverageRating'],
            ))
        .toList();

    lawyers.sort((a, b) => b.rating.compareTo(a.rating));

    print('in fetchLawyers: ${lawyers[0].name}');

    return lawyers.take(4).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Lawyer>>(
      future: _fetchLawyers(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          print('error: ${snapshot.error}');
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text('No lawyers available');
        } else {
          return Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (Lawyer lawyer in snapshot.data!)
                    LawyerCard(lawyer: lawyer),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}


class LawyerCard extends StatelessWidget {
  final Lawyer lawyer;

  LawyerCard({required this.lawyer});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          Image.network(
            lawyer.photoUrl,
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 10),
          Text(lawyer.name),
          SizedBox(height: 5),
          Text('Rating: ${lawyer.rating}'),
        ],
      ),
    );
  }
}

class Lawyer {
  final String name;
  final String photoUrl;
  final String rating;

  Lawyer({required this.name, required this.photoUrl, required this.rating});
}
