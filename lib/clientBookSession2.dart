import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:oktoast/oktoast.dart';
import 'package:qanuni/homePage.dart';
import 'package:qanuni/presentation/screens/payment_screen/view.dart';
import 'package:qanuni/providers/auth/login/cubit/login_cubit.dart';
import 'package:qanuni/providers/payment/cubit/payment_cubit.dart';
import 'package:qanuni/viewListOfLawyers.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BookingPage extends StatefulWidget {
  final Lawyer lawyer;

  BookingPage(this.lawyer);

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  List<String> lawyerTimeSlots = [];
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  Map<DateTime, List<dynamic>> _events = {};
  String _selectedTimeSlot = '';
  bool _isLoading = false;

  late User? _user;

  @override
  void initState() {
    super.initState();
    fetchAvailableTimeSlots();
    _user = FirebaseAuth.instance.currentUser;
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
          .where('lawyerEmail', isEqualTo: widget.lawyer.email)
          .get();
      print('${widget.lawyer.email} at fetch');
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

  void addBookingToFirestore(DateTime startTime, String timeSlotId) {
    // Get the client's email from LoginCubit
    //  String clientEmail = LoginCubit.get(context).email;

    DateTime endTime =
        startTime.add(Duration(hours: 1)); // Assuming each session is 1 hour

    // Add a new document to 'bookings' collection
    FirebaseFirestore.instance.collection('bookings').add({
      'clientEmail': _user!.email,
      'lawyerEmail': widget.lawyer.email,
      'startTime': startTime,
      'endTime': endTime,
      'timeSlotId': timeSlotId,
    }).then((_) {
      print('Booking added to Firestore successfully');
    }).catchError((error) {
      print('Failed to add booking to Firestore: $error');
    });
  }

  void showOkToast() {
    showToast(
      'Your session is booked',
      position: ToastPosition.center,
      backgroundColor: Colors.green,
      textStyle: TextStyle(color: Colors.white, fontSize: 16.0),
      duration: Duration(seconds: 3),
    );
  }

  void selectTimeSlot(String timeSlot) {
    setState(() {
      _selectedTimeSlot = timeSlot;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('حجز موعد استشارة'),
        backgroundColor: Color.fromARGB(255, 0, 128, 128),
        automaticallyImplyLeading: false,
        centerTitle: true,
        actions: [
          IconButton(
            padding: EdgeInsets.only(right: 30),
            alignment: Alignment.centerRight,
            icon: Icon(Icons.arrow_forward, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
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
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : (_events[_selectedDay] == null ||
                        _events[_selectedDay]!.isEmpty)
                    ? Center(
                        child: Text(
                          "No available time slots for this day. Please choose another day.",
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : GridView.builder(
                        padding: EdgeInsets.all(10),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: _events[_selectedDay]!.length,
                        itemBuilder: (context, index) {
                          String timeSlot = _events[_selectedDay]![index];
                          bool isSelected = timeSlot == _selectedTimeSlot;

                          return GestureDetector(
                            onTap: () {
                              selectTimeSlot(timeSlot);
                              print(timeSlot);
                            },
                            child: Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color:
                                        isSelected ? Colors.teal : Colors.white,
                                    border: Border.all(
                                      color: isSelected
                                          ? Colors.teal
                                          : Colors.teal,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Text(
                                      timeSlot,
                                      style: TextStyle(
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.teal,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
          ),
          Column(
            children: [
              IgnorePointer(
                ignoring: _selectedTimeSlot.isEmpty,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 15, right: 10, left: 10),
                  child: Opacity(
                    opacity: _selectedTimeSlot.isEmpty ? 0.5 : 1.0,
                    child: Expanded(
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            PaymentCubit.get(context).init(
                                _selectedTimeSlot,
                                widget.lawyer.price,
                                _selectedDay,
                                widget.lawyer.email);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const PaymentScreen(), //pass 'String selectedTimeSlot'
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.teal,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'الانتقال إلى الدفع',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
