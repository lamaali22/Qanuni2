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
import 'package:qanuni/viewProfileLawyer.dart';
import 'package:table_calendar/table_calendar.dart';

class LogoutPageLawyer extends StatefulWidget {
  @override
  _LogoutPageLawyerState createState() => _LogoutPageLawyerState();
}

class _LogoutPageLawyerState extends State<LogoutPageLawyer> {
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
  //late DateTime? selectedDate;
  //Map<DateTime, List<DocumentSnapshot>> timeSlotsMap = {};
  StreamSubscription<QuerySnapshot>? timeSlotsSubscription;
  List<String> lawyerTimeSlots = [];

  String? email = "";
  Future<void> getEmailAndUpdateToken() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      email = user.email!;

      print('User email: $email');
      Token().updateTokenIfEmailMatches(email, true);
    }
  }

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
    _selectedDay = DateTime.now();
    availableDates = [];
    fetchAvailableTimeSlots();

    Notifications().requestPermission;
    Notifications().onRecieveNotification(context);
    Notifications().setupInteractMessage(context);
    getEmailAndUpdateToken();
  }

  /*void fetchAvailableTimeSlots() {
    timeSlotsSubscription = timeSlotsCollection
        .where('lawyerEmail', isEqualTo: _user!.email)
        .where('available', isEqualTo: true)
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      Map<DateTime, List<DocumentSnapshot>> map = {};
      for (var timeSlot in snapshot.docs) {
        final startTime =
            (timeSlot['startTime'] as Timestamp).toDate().toLocal();
        final date = _selectedDay;
        //DateTime(startTime.year, startTime.month, startTime.day);

        if (map.containsKey(date)) {
          map[date]!.add(timeSlot);
        } else {
          map[date] = [timeSlot];
        }
      }

      setState(() {
        timeSlotsMap = map;
      });
    });
  }*/
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

      setState(() {
        _events = {};
        print(snapshot.size);

        for (var doc in snapshot.docs) {
          DateTime startTime = (doc['startTime'] as Timestamp).toDate();
          if (startTime.isAfter(startOfDay) && startTime.isBefore(endOfDay)) {
            print(startTime);

            String formattedTime = _formatTime(startTime);
            DateTime date = _selectedDay;
            _events[date] = _events[date] ?? [];
            _events[date]?.add(formattedTime);
          }
        }
        _isLoading = false;
      });
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
                Center(
                  child: IconButton(
                    icon: const Icon(
                      Icons.exit_to_app,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () async {
                      Token().updateTokenIfEmailMatches(email, false);
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
      body: Column(
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
            child: ListView.builder(
              itemCount: _events.containsKey(_selectedDay)
                  ? _events[_selectedDay]!.length
                  : 0,
              itemBuilder: (context, index) {
                final timeSlot = _events[_selectedDay]![index];
                //  String startTime = timeSlot['startTime'] as Timestamp;
                /* final formattedTime =
                    DateFormat('HH:mm').format(startTime.toDate());*/
                String _formatTime(DateTime time) {
                  return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
                }

                return Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey,
                        width: 0.5,
                      ),
                    ),
                  ),
                  child: ListTile(
                    title: Text(
                      '$_formatTime' //the proble is here
                      " :"
                      " الوقت",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.right,
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
                                  child: Text('نعم'),
                                  onPressed: () async {
                                    await timeSlotsCollection
                                        .doc(timeSlot.id)
                                        .delete();
                                    setState(() {});
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: Text('لا'),
                                  onPressed: () {
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
          )
        ],
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
}

      /*Container(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: timeSlotsMap.keys.length,
              reverse: true, // Set reverse to true to start from the right
              itemBuilder: (context, index) {
                final date = timeSlotsMap.keys.elementAt(index);
                final formattedDate = DateFormat('yyyy-MM-dd').format(date);
                final isSelected = date == selectedDate;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedDate = date;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      primary: isSelected ? Colors.teal : Colors.grey,
                      onPrimary: Colors.white,
                    ),
                    child: Text(
                      formattedDate,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontSize: 18.0,
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(
            height: 16,
          ),*/
