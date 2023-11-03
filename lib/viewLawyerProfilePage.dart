import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qanuni/clientBookSession2.dart';
import 'package:qanuni/viewLawyerReviews.dart';

import '../viewListOfLawyers.dart';

class viewLawyerProfilePage extends StatelessWidget {
  String riyal = "ريال";
  final Lawyer lawyer; // Pass the lawyer object
  viewLawyerProfilePage(this.lawyer, {super.key});
  // Convert English number to Arabic
  String formatNumber(int number) {
    return NumberFormat.decimalPattern('ar_EG').format(number);
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
              padding: const EdgeInsets.only(right: 30),
              alignment: Alignment.centerRight,
              icon: const Icon(Icons.arrow_forward, color: Colors.teal),
              onPressed: () {
                Navigator.pop(context); // Navigate back to the previous page
              },
            ),
          ],
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: const Alignment(20, 0),
                colors: [const Color(0x21008080), Colors.white.withOpacity(0)],
              ),
            ),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: const Alignment(0, -1),
              end: const Alignment(0, 0),
              colors: [const Color(0x21008080), Colors.white.withOpacity(0)],
            ),
          ),
          child: SafeArea(
            child: ListView(
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
                      style: const TextStyle(
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
                      '${formatNumber(int.parse(lawyer.price))}' + '${riyal}',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: Colors.teal,
                        fontSize: 14.0,
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.w800,
                        height: 2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5.0,
                ),

                FutureBuilder<QuerySnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('reviews')
                      .where('lawyerEmail', isEqualTo: lawyer.email)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      final reviews = snapshot.data!.docs;

                      // Calculate the number of clients with non-null or non-zero ratings
                      int numberOfClientsWithRatings = 0;

                      for (final review in reviews) {
                        final rating = (review['ratings'] as num).toDouble();
                        // review['ratings'];
                        if (rating != null && rating != 0.0) {
                          numberOfClientsWithRatings++;
                        }
                      }

                      return Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                width: 42,
                                height: 18,
                                child: Stack(
                                  children: <Widget>[
                                    Positioned(
                                      left: 0,
                                      top: 0,
                                      child: Container(
                                        width: 42,
                                        height: 18,
                                        decoration: ShapeDecoration(
                                          color: const Color(0x26FFC126),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
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
                                        style: const TextStyle(
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
                          const SizedBox(
                            height: 15,
                          ),
                          if (numberOfClientsWithRatings == 0)
                            const Text(
                              "لا يوجد مراجعات",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontFamily: 'Cairo',
                                fontWeight: FontWeight.w400,
                                height: 1,
                              ),
                            )
                          else
                            Text(
                              "عدد التقييمات "
                              " : "
                              '${formatNumber(numberOfClientsWithRatings)}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontFamily: 'Cairo',
                                fontWeight: FontWeight.w400,
                                height: 1,
                              ),
                            ),
                        ],
                      );
                    }
                  },
                ),

                const SizedBox(
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
                          constraints: const BoxConstraints(minWidth: 50),
                          height: 24,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            color: const Color(0x7F008080),
                            borderRadius: BorderRadius.circular(11.74),
                          ),
                          child: Text(
                            specialty,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
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

                    decoration: const ShapeDecoration(
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
                        const Text(
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
                              style: const TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                              ),
                            )),

                        const Divider(
                          thickness: 0.5,
                        ), // Add a vertical spacing between the text and buttons

                        Row(
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ViewLawyerReviews(lawyer)));
                              },
                              child: const Text(
                                'رؤية الكل',
                                style: TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.underline,
                                    color: Colors.teal),
                              ),
                            ),
                            const Expanded(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  'المراجعات',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        FutureBuilder<QuerySnapshot>(
                          future: FirebaseFirestore.instance
                              .collection('reviews')
                              .where('lawyerEmail', isEqualTo: lawyer.email)
                              .get(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else if (!snapshot.hasData ||
                                snapshot.data!.docs.isEmpty) {
                              return const Text('لا يوجد مراجعات');
                            } else {
                              final reviews = snapshot.data!.docs;

                              // Filter out reviews where the 'reviews' field is empty or null
                              final validReviews = reviews
                                  .where((review) =>
                                      (review['reviews'] != null &&
                                          review['reviews'].isNotEmpty))
                                  .toList();

                              if (validReviews.isEmpty) {
                                return const Text('لا يوجد مراجعات');
                              }

                              final review = validReviews[0];
                              final clientEmail = review['clientEmail'];

                              final rating =
                                  (review['ratings'] as num).toDouble();
                              final reviewText = review['reviews'];

                              return Card(
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                    color: Color(0xFF008080),
                                    width: 0.5,
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                margin: EdgeInsets.all(8.0),
                                child: ListTile(
                                  trailing: const CircleAvatar(
                                    backgroundImage:
                                        AssetImage('assets/default_photo.jpg'),
                                  ),
                                  title: FutureBuilder(
                                    // Use FutureBuilder to asynchronously load the client's data
                                    future: FirebaseFirestore.instance
                                        .collection('Clients')
                                        .where('email', isEqualTo: clientEmail)
                                        .get(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.done) {
                                        if (snapshot.hasError) {
                                          return Text(
                                              'Error: ${snapshot.error}');
                                        } else if (snapshot.hasData &&
                                            snapshot.data!.docs.isNotEmpty) {
                                          // Retrieve the client's data
                                          var clientData =
                                              snapshot.data!.docs[0].data();
                                          var clientFirstName =
                                              clientData['firstName'];

                                          // Check the language of the name
                                          bool isNameInEnglish = clientFirstName
                                              .contains(RegExp(r'[A-Za-z]'));

                                          // Define alignment based on language

                                          if (isNameInEnglish) {
                                            // Display the client's name as the title
                                            return Text(
                                              '${clientFirstName.substring(0, 2)}****',
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                fontFamily: 'Cairo',
                                                fontSize: 12,
                                              ),
                                            );
                                          } else {
                                            return Text(
                                              '****${clientFirstName.substring(0, 2)}',
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                fontFamily: 'Cairo',
                                                fontSize: 12,
                                              ),
                                            );
                                          }
                                        } else {
                                          return Text(
                                              'Client not found or missing data.');
                                        }
                                      } else {
                                        return CircularProgressIndicator(); // Handle loading state
                                      }
                                    },
                                  ),
                                  subtitle: Column(
                                    children: [
                                      SizedBox(height: 5.0),
                                      Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Row(
                                          // Wrap the Text widget in a Row
                                          mainAxisAlignment: MainAxisAlignment
                                              .end, // Align to the right
                                          children: [
                                            Expanded(
                                              child: Text(
                                                reviewText,
                                                textAlign: TextAlign.right,
                                                style: TextStyle(
                                                  fontSize: 14.0,
                                                  fontFamily: 'Cairo',
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                          },
                        ),

                        const SizedBox(
                            height:
                                8), // Add a vertical spacing between buttons

                        //Book button

                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            BookingPage(lawyer)),
                                  );
                                  //  Navigator.pushNamed(
                                  //   context,
                                  //   '/BookingPage()', arguments:lawyer
                                  // );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(
                                      0xFF008080), // Set the background color of the button
                                  padding: EdgeInsets.all(8.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                child: Text(
                                  'حجز موعد استشارة',
                                  style: TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
