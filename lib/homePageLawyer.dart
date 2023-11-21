import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:oktoast/oktoast.dart';
import 'package:qanuni/Notifications.dart';
import 'package:qanuni/consultationLawyer.dart';
import 'package:qanuni/presentation/screens/add_timeslots_Screen.dart';
import 'package:qanuni/presentation/screens/login_screen/view.dart';
import 'package:qanuni/lawyerProfile.dart';
import 'package:table_calendar/table_calendar.dart';

class LogoutPageLawyer extends StatefulWidget {
  @override
  _LogoutPageLawyerState createState() => _LogoutPageLawyerState();
}

class _LogoutPageLawyerState extends State<LogoutPageLawyer> {
  bool noAvailableTimeSlots = false;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  Map<DateTime, List<dynamic>> _events = {};
  String _selectedTimeSlot = '';
  bool _isLoading = false;
  late DateTime _selectedDay = DateTime.now();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User? _user;
  final CollectionReference timeSlotsCollection =
      FirebaseFirestore.instance.collection('timeSlots');
  late List<DateTime> availableDates;
  late DateTime? selectedDate;
  Map<DateTime, List<DocumentSnapshot>> timeSlotsMap = {};
  StreamSubscription<QuerySnapshot>? timeSlotsSubscription;

  String? email = "";
  Future<void> getEmailAndUpdateToken() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      email = user.email!;

      print('User email: $email');
      Token().updateTokenInDB(email, true, "lawyers");
    }
  }

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
    selectedDate = DateTime.now();
    availableDates = [];
    fetchAvailableTimeSlots();

    Notifications().requestPermission;
    Notifications().onRecieveNotification(context);
    Notifications().setupInteractMessage(context);
    getEmailAndUpdateToken();
  }

  void fetchAvailableTimeSlots() async {
    setState(() {
      _isLoading = true;
    });

    DateTime startOfDay =
        DateTime(_selectedDay.year, _selectedDay.month, _selectedDay.day);
    DateTime endOfDay = startOfDay.add(Duration(days: 1));

    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('timeSlots')
          .where('available', isEqualTo: true)
          .where('lawyerEmail', isEqualTo: _user!.email)
          .get();
      if (mounted) {
        setState(() {
          _events = {};
          noAvailableTimeSlots =
              true; // Assume no available time slots initially

          for (var doc in snapshot.docs) {
            DateTime startTime = (doc['startTime'] as Timestamp).toDate();
            if (startTime.isAfter(startOfDay) && startTime.isBefore(endOfDay)) {
              noAvailableTimeSlots = false; // There are available time slots
              print(startTime);

              String formattedTime = _formatTime(startTime);
              DateTime date = _selectedDay;
              _events[date] = _events[date] ?? [];
              _events[date]?.add(formattedTime);
            }
          }
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      if (e is FirebaseException && e.code == 'failed-precondition') {
        // Firestore is temporarily in read-only mode
        showToast(
          'Error: Internet connection issue. Please check your internet connection.',
          position: ToastPosition.bottom,
          backgroundColor: Colors.red,
          textStyle: TextStyle(color: Colors.white, fontSize: 16.0),
          duration: Duration(seconds: 5),
        );
      } else {
        print('Error fetching available time slots: $e');
      }
    }
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    timeSlotsSubscription?.cancel();
    super.dispose();
  }

  void _navigateToScreen(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => ViewProfileLawyer()),
          (route) => false,
        );
        break;
      case 1:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => BookingListScreen()),
          (route) => false,
        );
        break;
      case 2:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LogoutPageLawyer()),
          (route) => false,
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90), // Adjusted the height
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
                // Center(
                //   child: IconButton(
                //     icon: const Icon(
                //       Icons.exit_to_app,
                //       color: Colors.white,
                //       size: 30,
                //     ),
                //     onPressed: () async {
                //       Token().updateTokenInDB(email, false, "lawyers");
                //       await _auth.signOut();
                //       Navigator.pushReplacement(
                //         context,
                //         MaterialPageRoute(
                //           builder: (context) => LoginScreen(),
                //         ),
                //       );
                //     },
                //   ),
                // ),
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
      ),
      body: FutureBuilder(
        future: getEmailAndUpdateToken(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return buildBody();
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Color(0x7F008080),
        unselectedItemColor: Colors.black,
        showUnselectedLabels: true,
        onTap: (index) => _navigateToScreen(context, index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person_2_outlined,
            ),
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
    );
  }

  Widget buildBody() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Spacer(), // Add Spacer to push the button to the right
              TextButton(
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
                child: const Row(
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
            ],
          ),
        ),
        TableCalendar(
          headerStyle: HeaderStyle(
            formatButtonDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.teal,
            ),
            formatButtonTextStyle: TextStyle(color: Colors.white),
            formatButtonVisible: false,
            titleTextStyle: TextStyle(color: Colors.teal),
          ),
          calendarFormat: _calendarFormat,
          onFormatChanged: (format) {
            setState(() {
              _calendarFormat = format;
            });
          },
          focusedDay: _selectedDay,
          firstDay: DateTime.now(),
          lastDay: DateTime.now().add(Duration(days: 10)),
          selectedDayPredicate: (day) {
            return isSameDay(_selectedDay, day);
          },
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
            });

            fetchAvailableTimeSlots();
          },
          calendarStyle: CalendarStyle(
            todayTextStyle: TextStyle(color: Colors.black),
            todayDecoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: Colors.teal),
            ),
            selectedTextStyle: TextStyle(color: Colors.white),
            selectedDecoration: BoxDecoration(
              color: Colors.teal,
            ),
            weekendTextStyle: TextStyle(color: Colors.black),
            outsideTextStyle: TextStyle(color: Colors.grey),
            defaultTextStyle: TextStyle(color: Colors.black),
          ),
        ),
        SizedBox(height: 20),
        Expanded(
          child: (_isLoading || noAvailableTimeSlots)
              ? Center(
                  child: noAvailableTimeSlots
                      ? Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.red),
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child: Text(
                            "لا توجد لديك مواعيد متاحة في هذا اليوم",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      : CircularProgressIndicator(),
                )
              : (_events[_selectedDay] == null ||
                      _events[_selectedDay]!.isEmpty)
                  ? Center(
                      child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.red),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: Text(
                          "لا تتوفر أوقات متاحة لهذا اليوم, الرجاء اختيار يوم آخر",
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _events.containsKey(_selectedDay)
                          ? _events[_selectedDay]!.length
                          : 0,
                      itemBuilder: (context, index) {
                        List timeSlotsForSelectedDay = _events[_selectedDay]!;

                        // Sort the list in ascending order
                        timeSlotsForSelectedDay.sort();

                        final timeSlot = timeSlotsForSelectedDay[index];
                        String _formatTime(DateTime time) {
                          return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
                        }

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
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  "$timeSlot",
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.0,
                                    fontFamily: 'Cairo',
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                                const SizedBox(width: 8),
                                // Your icon goes here
                                Icon(
                                  Icons
                                      .access_time, // Replace this with the icon you want
                                  color: Colors.teal,
                                ),
                                // Adjust the spacing between the icon and text
                              ],
                            ),
                            leading: IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.teal,
                              ),
                              onPressed: () async {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text(
                                        'تأكيد الحذف',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18.0,
                                          fontFamily: 'Cairo',
                                          fontWeight: FontWeight.w600,
                                        ),
                                        textAlign: TextAlign.right,
                                      ),
                                      content: const Text(
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
                                          child: Text('لا'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        TextButton(
                                          child: Text('نعم'),
                                          onPressed: () async {
                                            // Assuming _events[_selectedDay] is a List of Strings
                                            // You might want to replace this with your actual logic
                                            int index = _events[_selectedDay]!
                                                .indexOf(timeSlot);
                                            if (index != -1) {
                                              _events[_selectedDay]!
                                                  .removeAt(index);
                                            }
                                            setState(() {});
                                            Navigator.of(context).pop();
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
                    ),
        ),
      ],
      //
    );
  }
}
