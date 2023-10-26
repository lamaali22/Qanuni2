import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qanuni/viewListOfLawyers.dart';
import '../viewLawyerReviews.dart';
import 'package:rating_summary/rating_summary.dart';

class ViewLawyerReviews extends StatefulWidget {
  final Lawyer lawyer; // Pass the lawyer object
  ViewLawyerReviews(this.lawyer, {super.key});

  @override
  _ViewLawyerReviewsState createState() => _ViewLawyerReviewsState(lawyer);
}

class _ViewLawyerReviewsState extends State<ViewLawyerReviews> {
  final Lawyer lawyer;
  double averageRating = 0.0;

  _ViewLawyerReviewsState(this.lawyer);

  @override
  void initState() {
    super.initState();
    if (lawyer.AverageRating != null) {
      averageRating = double.parse(lawyer.AverageRating);
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
                        final rating = (review['ratings'] as num)?.toDouble();
                        if (rating != null && rating != 0.0) {
                          numberOfClientsWithRatings++;
                        }
                      }

                      if (numberOfClientsWithRatings > 0) {
                        return Column(
                          children: <Widget>[
                            RatingSummary(
                              counter: numberOfClientsWithRatings,
                              average: averageRating,
                              showAverage: true,
                              counterFiveStars: reviews
                                      .where((review) =>
                                          (review['ratings'] as num)
                                              ?.toDouble() ==
                                          5.0)
                                      .length ??
                                  0,
                              counterFourStars: reviews
                                      .where((review) =>
                                          (review['ratings'] as num)
                                              ?.toDouble() ==
                                          4.0)
                                      .length ??
                                  0,
                              counterThreeStars: reviews
                                      .where((review) =>
                                          (review['ratings'] as num)
                                              ?.toDouble() ==
                                          3.0)
                                      .length ??
                                  0,
                              counterTwoStars: reviews
                                      .where((review) =>
                                          (review['ratings'] as num)
                                              ?.toDouble() ==
                                          2.0)
                                      .length ??
                                  0,
                              counterOneStars: reviews
                                      .where((review) =>
                                          (review['ratings'] as num)
                                              ?.toDouble() ==
                                          1.0)
                                      .length ??
                                  0,
                            ),
                          ],
                        );
                      } else {
                        return Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Container(
                                  width: 120,
                                  height: 18,
                                  child: Stack(
                                    children: <Widget>[
                                      Positioned(
                                        left: 0,
                                        top: 0,
                                        child: Container(
                                          width: 120,
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
                                          'لا يوجد تقييمات',
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
                          ],
                        );
                      }
                    }
                  },
                ),
                const SizedBox(
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
                        ),
                      ],
                    ),

                    child: Column(
                      mainAxisSize: MainAxisSize
                          .min, // Limit the vertical size of the column to its content

                      crossAxisAlignment: CrossAxisAlignment.end,

                      children: [
                        /* const Divider(
                          thickness: 0.5,
                        ), */ // Add a vertical spacing between the text and buttons

                        const Row(
                          children: [
                            Expanded(
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

                              final validReviews = reviews.where((review) {
                                final reviewText = review['reviews'];
                                return reviewText != null &&
                                    reviewText.isNotEmpty;
                              }).toList();

                              if (validReviews.isEmpty) {
                                return const Text('لا يوجد مراجعات');
                              }

                              return Column(
                                children: validReviews.map((review) {
                                  final clientEmail = review['clientEmail'];
                                  final reviewText = review['reviews'];

                                  return Card(
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                        color: Color(0xFF008080),
                                        width: 0.5,
                                      ),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    margin: EdgeInsets.all(8.0),
                                    child: ListTile(
                                      trailing: const CircleAvatar(
                                        backgroundImage: AssetImage(
                                            'assets/default_photo.jpg'),
                                      ),
                                      title: FutureBuilder(
                                        // Use FutureBuilder to asynchronously load the client's data
                                        future: FirebaseFirestore.instance
                                            .collection('Clients')
                                            .where('email',
                                                isEqualTo: clientEmail)
                                            .get(),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.done) {
                                            if (snapshot.hasError) {
                                              return Text(
                                                  'Error: ${snapshot.error}');
                                            } else if (snapshot.hasData &&
                                                snapshot
                                                    .data!.docs.isNotEmpty) {
                                              // Retrieve the client's data
                                              var clientData =
                                                  snapshot.data!.docs[0].data();
                                              var clientFirstName =
                                                  clientData['firstName'];

                                              // Check the language of the name
                                              bool isNameInEnglish =
                                                  clientFirstName.contains(
                                                      RegExp(r'[A-Za-z]'));

                                              // Define alignment based on language
                                              if (isNameInEnglish) {
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
                                              mainAxisAlignment:
                                                  MainAxisAlignment
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
                                }).toList(),
                              );
                            }
                          },
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
