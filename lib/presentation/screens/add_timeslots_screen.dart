import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:oktoast/oktoast.dart';
import 'package:qanuni/homePageLawyer.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lawyer Time Slots',
      home: TimeSlotScreen(),
    );
  }
}

class TimeSlotScreen extends StatefulWidget {
  @override
  _TimeSlotScreenState createState() => _TimeSlotScreenState();
}

class _TimeSlotScreenState extends State<TimeSlotScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  int? _selectedHour;
  String? _selectedTimeValidator(int? value) {
    if (value == null) {
      return 'اختر الوقت';
    }
    return null;
  }

  // Firestore collection reference for time slots
  final CollectionReference timeSlotsCollection =
      FirebaseFirestore.instance.collection('timeSlots');

  late User? _user; // To store the currently logged-in user

  @override
  void initState() {
    super.initState();
    // Initialize the user using Firebase Authentication
    _user = FirebaseAuth.instance.currentUser;
  }

  Future<void> _navigateBackAndRefresh() async {
    // Pop the current route
    Navigator.pop(context);

    // Wait for the Navigator to finish popping the route
    await Future.delayed(
        Duration(milliseconds: 300)); // Adjust the delay as needed

    // Trigger a refresh of the previous page
    setState(() {});
  }

//navigation bar method
  void _navigateToScreen(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LogoutPageLawyer()),
          (route) => false,
        );
        break;
      case 1:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LogoutPageLawyer()),
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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(255, 0, 128, 128),
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              // ... Your code to add the time slot ...

              // Navigate back and refresh the previous page
              Navigator.pop(context, true);
            },
          ),
        ],
        title: const Text("جدول مواعيدي",
            style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w500)),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Align(
                      alignment: Alignment
                          .centerRight, // Adjust the alignment as needed
                      child: Text(
                        'مدة الجلسة ساعة واحده*',
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Cairo',
                          color: const Color.fromARGB(255, 246, 86, 75),
                        ),
                        // No need to use textAlign here
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          right: 28.0), // Adjust the right padding as needed
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'التاريخ',
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'Cairo',
                            color: Colors.teal,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      width: 300,
                      child: TextFormField(
                        controller: _dateController,
                        textAlign: TextAlign.right,
                        decoration: InputDecoration(
                          // labelText: 'التاريخ',
                          // floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelStyle: TextStyle(
                            fontSize: 18,
                            color: Colors.teal,
                          ),
                          // alignLabelWithHint: true,
                          isDense: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: Colors.teal, width: 2),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 20,
                            horizontal: 20,
                          ),
                        ),
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.teal,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'ادخل التاريخ';
                          }
                          return null;
                        },
                        onTap: () async {
                          final selectedDate =
                              await _showCustomDatePicker(context);
                          if (selectedDate != null) {
                            final formattedDate =
                                DateFormat('yyyy-MM-dd').format(selectedDate);
                            _dateController.text = formattedDate;
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          right: 28.0), // Adjust the right padding as needed
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'الوقت',
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'Cairo',
                            color: Colors.teal,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 300,
                      child: DropdownButtonFormField<int>(
                        isExpanded: true,
                        value: _selectedHour,
                        onChanged: (int? hour) {
                          setState(() {
                            _selectedHour = hour; // Update the selected hour
                          });
                        },
                        items: List.generate(24, (int hour) {
                          final formattedHour = hour.toString().padLeft(2, '0');
                          final formattedTime = '$formattedHour:00';

                          return DropdownMenuItem<int>(
                            value: hour,
                            child: Align(
                              // Align the selected item to the right
                              alignment: Alignment.centerRight,
                              child: Text(
                                formattedTime,
                                style:
                                    TextStyle(fontSize: 16, color: Colors.teal),
                              ),
                            ),
                          );
                        }),
                        decoration: InputDecoration(
                          //labelText: 'الوقت',
                          alignLabelWithHint: true,
                          labelStyle:
                              TextStyle(fontSize: 18, color: Colors.teal),
                          isDense: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: Colors.teal, width: 2),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 20,
                            horizontal: 20,
                          ),
                        ),
                        validator: _selectedTimeValidator,
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate() &&
                            _selectedHour != null) {
                          final hour = _selectedHour!;
                          final minute = 0;

                          final dateParts = _dateController.text.split('-');
                          final year = int.parse(dateParts[0]);
                          final month = int.parse(dateParts[1]);
                          final day = int.parse(dateParts[2]);

                          final selectedTime =
                              DateTime(year, month, day, hour, minute);

                          final endTime = selectedTime.add(Duration(hours: 1));

                          final existingTimeSlot = await timeSlotsCollection
                              .where('lawyerEmail', isEqualTo: _user!.email)
                              .where('startTime',
                                  isEqualTo: Timestamp.fromDate(selectedTime))
                              .limit(1)
                              .get();

                          if (existingTimeSlot.docs.isEmpty) {
                            print("hello");
                            await timeSlotsCollection.add({
                              'startTime': Timestamp.fromDate(selectedTime),
                              'endTime': Timestamp.fromDate(endTime),
                              'available': true,
                              'lawyerEmail': _user!.email,
                            });

                            showToast(
                              'تمت إضافة الوقت بنجاح',
                              backgroundColor: Colors.black,
                              radius: 10.0,
                              textStyle: TextStyle(color: Colors.white),
                              textPadding: EdgeInsets.all(10.0),
                              position: ToastPosition.bottom,
                              duration: Duration(seconds: 2),
                            );

                            _dateController.clear();
                            setState(() {
                              _selectedHour = null;
                            });
                          } else {
                            showToast(
                              'هذا الموعد موجود بالفعل',
                              backgroundColor: Colors.black,
                              radius: 10.0,
                              textStyle: TextStyle(color: Colors.white),
                              textPadding: EdgeInsets.all(10.0),
                              position: ToastPosition.bottom,
                              duration: Duration(seconds: 2),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.teal,
                        minimumSize:
                            Size(300, 56), // Set a fixed size for the button
                      ),
                      child: Text(
                        'اضافة موعد متاح جديد',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Color(0x7F008080),
        unselectedItemColor: Colors.black,
        showUnselectedLabels: true,
        onTap: (index) => _navigateToScreen(context, index),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.person_2_outlined),
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

  Future<DateTime?> _showCustomDatePicker(BuildContext context) async {
    DateTime currentDate = DateTime.now();
    DateTime? selectedDate = currentDate;

    // Calculate the last date as 10 days from the current date
    DateTime lastDate = currentDate.add(Duration(days: 10));

    selectedDate = await showDialog<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'اختر التاريخ',
          ),
          content: Container(
            width: double.maxFinite,
            child: CalendarDatePicker(
              initialDate: currentDate,
              firstDate: currentDate,
              lastDate: lastDate,
              onDateChanged: (DateTime? newDate) {
                if (newDate != null && !newDate.isBefore(currentDate)) {
                  selectedDate = newDate;
                }
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(selectedDate);
              },
              child: Text('OK'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(null);
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );

    return selectedDate;
  }

  @override
  void dispose() {
    _timeController.dispose();
    super.dispose();
  }
}
