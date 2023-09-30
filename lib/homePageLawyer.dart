import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qanuni/presentation/screens/client_signup_screen/view.dart';
import 'package:qanuni/presentation/screens/lawyer_sceens/add_timeslots_Screen.dart';

import 'package:qanuni/presentation/screens/login_screen/view.dart';
import 'package:qanuni/viewListOfLawyers.dart';

class LogoutPageLawyer extends StatefulWidget {
  @override
  _LogoutPageLawyerState createState() => _LogoutPageLawyerState();
}

class _LogoutPageLawyerState extends State<LogoutPageLawyer> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User? _user;
  final CollectionReference timeSlotsCollection =
      FirebaseFirestore.instance.collection('timeSlots');

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
  }

  Future<QuerySnapshot> getAvailableTimeSlots() async {
    final now = DateTime.now();
    final futureStartTime = now.add(Duration(hours: 1));

    return await timeSlotsCollection
        .where('lawyerEmail', isEqualTo: _user!.email)
        // .where('startTime',
        //  isGreaterThanOrEqualTo: Timestamp.fromDate(futureStartTime))
        .where('available', isEqualTo: true)
        // .orderBy('startTime')
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(83),
        child: Container(
          width: double.infinity,
          height: 90,
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 17),
          decoration: ShapeDecoration(
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
              Center(
                child: IconButton(
                  icon: Icon(
                    Icons.exit_to_app,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: () async {
                    await _auth.signOut();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ),
                    );
                  },
                ),
              ),
              Expanded(
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
                          height: 1.4,
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TimeSlotScreen(),
                        ),
                      );

                      if (result == true) {
                        // Refresh the current page if the result is true
                        setState(() {});
                      }
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.add_circle,
                          size: 30,
                          color: Colors.teal,
                        ),
                        Text(
                          ' مواعيدي المتاحة',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.w700,
                            fontSize: 18.12,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          //start of previous code
          /* Padding(
            padding: const EdgeInsets.symmetric(
                vertical: 16.0), // Add vertical padding as needed
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TimeSlotScreen(),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.add_circle,
                          size: 30,
                          color: Colors.teal,
                        ),
                        Text(
                          ' مواعيدي المتاحة',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.w700,
                            fontSize: 18.12,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),*/ //end of previous code

          // Section for displaying and deleting available time slots
          Expanded(
            child: FutureBuilder<QuerySnapshot>(
              future: getAvailableTimeSlots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                final timeSlots = snapshot.data!.docs;

                if (timeSlots.isEmpty) {
                  return Center(
                    child: Text(
                      'لا يوجد مواعيد متاحه',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.12,
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.w500,
                        height: 1.4,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: timeSlots.length,
                  itemBuilder: (context, index) {
                    final timeSlot = timeSlots[index];
                    final startTime = timeSlot['startTime'] as Timestamp;
                    final formattedDate =
                        DateFormat('yyyy-MM-dd').format(startTime.toDate());
                    final formattedTime =
                        DateFormat('HH:mm').format(startTime.toDate());

                    return Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey,
                            width: 0.5, // Adjust the width as needed
                          ),
                        ),
                      ),
                      child: ListTile(
                        title: Text(
                          '$formattedDate '
                          ":"
                          "التاريخ",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.right,
                        ),
                        subtitle: Text(
                          '$formattedTime'
                          ":"
                          "الوقت",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.right,
                        ),
                        leading: IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Colors.teal,
                          ),
                          onPressed: () async {
                            // Show a confirmation dialog
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(
                                    'تأكيد الحذف',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18.0,
                                      fontFamily: 'Cairo',
                                      fontWeight: FontWeight.w600,
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                  content: Text(
                                    'هل أنت متأكد أنك تريد حذف هذا الوقت المتاح؟',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18.0,
                                      fontFamily: 'Cairo',
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text('نعم'),
                                      onPressed: () async {
                                        // Delete the time slot
                                        await timeSlotsCollection
                                            .doc(timeSlot.id)
                                            .delete();
                                        setState(() {
                                          // Refresh the UI after deletion
                                        });
                                        Navigator.of(context)
                                            .pop(); // Close the dialog
                                      },
                                    ),
                                    TextButton(
                                      child: Text('لا'),
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pop(); // Close the dialog
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
