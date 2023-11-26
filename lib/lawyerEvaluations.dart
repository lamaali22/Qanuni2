import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rating_summary/rating_summary.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LawyerEvaluations extends StatefulWidget {
  @override
  _LawyerEvaluationsState createState() => _LawyerEvaluationsState();
}

class _LawyerEvaluationsState extends State<LawyerEvaluations> {
  double averageRating = 0.0;
  late User? user;
  @override
  void initState() {
    super.initState();
    // Fetch the authenticated user
    user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      fetchUserRating(user!.email); // Fetch the user's rating using their email
    }
  }

  Future<void> showReportConfirmationDialog(String reviewDocumentId) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'تأكيد البلاغ',
            style: TextStyle(
              color: const Color.fromARGB(255, 14, 16, 16),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.right,
          ),
          content: Text(
            'هل أنت متأكد أنك تريد الإبلاغ عن هذا التعليق؟',
            style: TextStyle(
              color: const Color.fromARGB(255, 14, 16, 16),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.right,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('إلغاء'),
            ),
            TextButton(
              onPressed: () {
                // Handle the report action, e.g., send a report to the server
                // Update the Firestore document with the reporter's email
                updateReviewWithReporter(reviewDocumentId);
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('تأكيد'),
            ),
          ],
        );
      },
    );
  }

  void updateReviewWithReporter(String reviewDocumentId) async {
    // Get the current user's email or any identifier you have for the user
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String reporterEmail = user.email!;

      try {
        // Retrieve the review document
        DocumentSnapshot reviewSnapshot = await FirebaseFirestore.instance
            .collection('reviews')
            .doc(reviewDocumentId)
            .get();

        // Check if the user's email is already in the array of reporters
        Map<String, dynamic>? reviewData =
            reviewSnapshot.data() as Map<String, dynamic>?;

        List<dynamic>? reporters = reviewData?['reporters'];
        if (reporters != null && reporters.contains(reporterEmail)) {
          // The user has already reported, show a message
          Fluttertoast.showToast(
            msg: "لقد قمت بالإبلاغ مسبقًا.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.orange,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          return; // Do not proceed with the update
        }

        // Update the 'reporters' field in the reviews document with the reporter's email
        // Increment the 'numOfReports' field by 1
        await FirebaseFirestore.instance
            .collection('reviews')
            .doc(reviewDocumentId)
            .update({
          'reporters': FieldValue.arrayUnion([reporterEmail]),
          'numOfReports': FieldValue.increment(1),
        });

// Check if numOfReports is 3 or greater
        int updatedNumOfReports = (reviewData?['numOfReports'] ?? 0) + 1;
        if (updatedNumOfReports >= 3) {
          // Delete the comment
          await FirebaseFirestore.instance
              .collection('reviews')
              .doc(reviewDocumentId)
              .delete();

          // Display a toast with the deletion message
          Fluttertoast.showToast(
            msg: "تم حذف التعليق بنجاح.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        } else {
          // Display a toast with the success message
          Fluttertoast.showToast(
            msg: "تم إرسال التقرير بنجاح.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }

        // Print a message or handle success as needed
        print('Report submitted successfully.');
      } catch (error) {
        // Handle the error, e.g., display an error message
        print('Error submitting report: $error');
      }
    } else {
      // Handle the case where the user is not authenticated
      print('User not authenticated');
    }
  }

  Future<void> fetchUserRating(String? userEmail) async {
    if (userEmail != null) {
      QuerySnapshot userData = await FirebaseFirestore.instance
          .collection('lawyers')
          .where('email', isEqualTo: userEmail)
          .get();

      if (userData.docs.isNotEmpty) {
        double userAverageRating = 0.0;
        if ((userData.docs[0]['AverageRating'] != null) &&
            (userData.docs[0]['AverageRating'].isNotEmpty)) {
          userAverageRating = double.parse(userData.docs[0]['AverageRating']);
        } else {
          userAverageRating = 0.0;
        }

        setState(() {
          averageRating = userAverageRating;
        });
      }
    } else {
      // Handle the case where userEmail is null (e.g., user is not authenticated)
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: const Color(0xFF008080),
          elevation: 0,
          title: const Text("تقييم المستفيدين",
              style:
                  TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w500)),
          centerTitle: true,
          actions: [
            IconButton(
              padding: const EdgeInsets.only(right: 30),
              alignment: Alignment.centerRight,
              icon: const Icon(Icons.arrow_forward,
                  color: Color.fromARGB(255, 245, 238, 238)),
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
          // decoration: BoxDecoration(
          //   gradient: LinearGradient(
          //     begin: const Alignment(0, -1),
          //     end: const Alignment(0, 0),
          //     colors: [const Color(0x21008080), Colors.white.withOpacity(0)],
          //   ),
          // ),
          child: SafeArea(
            child: ListView(
              children: [
                const SizedBox(
                  height: 15.0,
                ),
                FutureBuilder<QuerySnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('reviews')
                      .where('lawyerEmail', isEqualTo: user!.email)
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
                              label: ": عدد التقييمات",
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
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  width: 120,
                                  height: 25,
                                  child: Stack(
                                    children: <Widget>[
                                      Positioned(
                                        left: 0,
                                        top: 0,
                                        bottom: 0, //
                                        child: Container(
                                          width: 120,
                                          height: 100,
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
                                      const Positioned(
                                        left: 20.40,
                                        top: 2.40,
                                        child: Text(
                                          'لا يوجد تقييمات',
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
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
                              .where('lawyerEmail', isEqualTo: user!.email)
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
                                  final reviewId =
                                      review.id; // Retrieve the document ID

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
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          CircleAvatar(
                                            backgroundImage: AssetImage(
                                                'assets/default_photo.jpg'),
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.report),
                                            onPressed: () {
                                              showReportConfirmationDialog(
                                                  reviewId);
                                            },
                                          ),
                                        ],
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
                                                  '${clientFirstName.substring(0, 2)}**',
                                                  textAlign: TextAlign.right,
                                                  style: TextStyle(
                                                    fontFamily: 'Cairo',
                                                    fontSize: 12,
                                                  ),
                                                );
                                              } else {
                                                return Text(
                                                  '**${clientFirstName.substring(0, 2)}',
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
