/*import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(255, 0, 128, 128),
        title: const Text("جدول مواعيدي",
            style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w500)),
        centerTitle: true,
         leading: IconButton(
          icon: Icon(Icons.arrow_back), // Back button icon
           onPressed: () {
            // Navigate back to the previous page
            Navigator.pop(context);
          },
         ),
      ),
      body: Column(
        children: <Widget>[
          // Display existing time slots
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: timeSlotsCollection.snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }

                // Extract time slots from Firestore documents
                final timeSlots = snapshot.data!.docs;

                // Create a list of time slot widgets
                final timeSlotWidgets = timeSlots.map((timeSlot) {
                  final startTime = timeSlot['startTime'] as Timestamp;
                  final available = timeSlot['available'] as bool;

                  // Format Timestamp to DateTime
                  final dateTime = startTime.toDate();
                  final formattedTime =
                      '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
                  final formattedDate =
                      DateFormat('yyyy-MM-dd').format(dateTime);

                  // Set text colors based on availability
                  final textColor = available ? Colors.teal : Colors.red;

                  return ListTile(
                    title: Text(
                      '$formattedDate'
                      ":"
                      "التاريخ",
                      style: TextStyle(
                        color: textColor,
                        fontFamily: 'Cairo', // Set text color here
                      ),
                      textAlign: TextAlign.right, // Align text to the right
                    ),
                    subtitle: Text(
                      ' $formattedTime'
                      ":"
                      "الوقت",
                      style: TextStyle(
                        color: textColor,
                        fontFamily: 'Cairo', // Set text color here
                      ),
                      textAlign: TextAlign.right, // Align text to the right
                    ),
                  );
                }).toList();

                return ListView(
                  children: timeSlotWidgets,
                );
              },
            ),
          ),
          // Add new time slot
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Row(
                children: <Widget>[
                  Container(
                    height: 56, // Set the height to match the text field
                    child: ElevatedButton(
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

                          // Add the time slot to Firestore
                          await timeSlotsCollection.add({
                            'startTime': Timestamp.fromDate(selectedTime),
                            'available': true,
                            'lawyerId': '1',
                          });

                          // Clear the input fields
                          _dateController.clear();
                          setState(() {
                            _selectedHour = null;
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.teal,
                      ),
                      child: Text(
                        'اضافة',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Container(
                    height: 56, // Set the height to match the text field
                    width:
                        100, // Increase the width to accommodate the wider time format
                    child: DropdownButtonFormField<int>(
                      value: _selectedHour,
                      onChanged: (int? hour) {
                        setState(() {
                          _selectedHour = hour;
                        });
                      },
                      items: List.generate(24, (int hour) {
                        final formattedHour = hour.toString().padLeft(2, '0');
                        final formattedTime =
                            '$formattedHour:00'; // Add ':00' for zero minutes

                        return DropdownMenuItem<int>(
                          value: hour,
                          child: Text(
                            formattedTime,
                            style: TextStyle(fontSize: 16, color: Colors.teal),
                          ),
                        );
                      }),
                      decoration: InputDecoration(
                        labelText:
                            'الوقت', // Add label text to the drop-down button
                        labelStyle: TextStyle(fontSize: 16, color: Colors.teal),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.teal, width: 2),
                        ),
                      ),
                      validator: _selectedTimeValidator,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _dateController,
                      decoration: InputDecoration(
                        labelText: 'التاريخ',
                        labelStyle: TextStyle(fontSize: 18, color: Colors.teal),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.teal, width: 2),
                        ),
                      ),
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.teal), // Set text color here
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'ادخل التاريخ';
                        }
                        return null;
                      },
                      onTap: () async {
                        // Show custom date picker
                        final selectedDate =
                            await _showCustomDatePicker(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showCustomDatePicker(BuildContext context) async {
    DateTime currentDate = DateTime.now();
    DateTime? selectedDate = currentDate; // Initialize with the current date

    DateTime lastDateIn2023 = DateTime(2023, 12, 31);

    selectedDate = await showDialog<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Date'),
          content: Container(
            width: double.maxFinite,
            child: CalendarDatePicker(
              initialDate: currentDate, // Set initialDate to current date
              firstDate: currentDate, // Start date is the current date
              lastDate: lastDateIn2023, // End on the last day of 2023
              onDateChanged: (DateTime? newDate) {
                if (newDate != null && !newDate.isBefore(currentDate)) {
                  // Allow selecting dates starting from the current date
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

    if (selectedDate != null) {
      final formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate!);
      // Do something with the selected date, e.g., update the text controller
      _dateController.text = formattedDate;
    }
  }

  @override
  void dispose() {
    _timeController.dispose();
    super.dispose();
  }
}*/

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
                              'هذا الوقت موجود بالفعل',
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

    DateTime lastDateIn2023 = DateTime(2023, 12, 31);

    selectedDate = await showDialog<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Date'),
          content: Container(
            width: double.maxFinite,
            child: CalendarDatePicker(
              initialDate: currentDate,
              firstDate: currentDate,
              lastDate: lastDateIn2023,
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

//important code

/*class _TimeSlotScreenState extends State<TimeSlotScreen> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(255, 0, 128, 128),
       
        title: const Text("جدول مواعيدي",
            style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w500)),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          // Display existing time slots
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: timeSlotsCollection
                  .where('lawyerEmail', isEqualTo: _user?.email)
                  .snapshots(), // Filter time slots by lawyer's email
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }

                // Extract time slots from Firestore documents
                final timeSlots = snapshot.data!.docs;

                // Create a list of time slot widgets
                final timeSlotWidgets = timeSlots.map((timeSlot) {
                  final startTime = timeSlot['startTime'] as Timestamp;
                  final available = timeSlot['available'] as bool;
                  final lawyerEmail = timeSlot['lawyerEmail'] as String;

                  // Format Timestamp to DateTime
                  final dateTime = startTime.toDate();
                  final formattedTime =
                      '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
                  final formattedDate =
                      DateFormat('yyyy-MM-dd').format(dateTime);

                  // Set text colors based on availability
                  final textColor = available ? Colors.teal : Colors.red;

                  return ListTile(
                    title: Text(
                      '$formattedDate'
                      ":"
                      "التاريخ",
                      style: TextStyle(
                        color: textColor,
                        fontFamily: 'Cairo',
                      ),
                      textAlign: TextAlign.right,
                    ),
                    subtitle: Text(
                      ' $formattedTime'
                      ":"
                      "الوقت",
                      style: TextStyle(
                        color: textColor,
                        fontFamily: 'Cairo',
                      ),
                      textAlign: TextAlign.right,
                    ),
                  );
                }).toList();

                return ListView(
                  children: timeSlotWidgets,
                );
              },
            ),
          ),
          // Add new time slot
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Row(
                children: <Widget>[
                  Container(
                    height: 56,
                    child: ElevatedButton(
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

                          // Calculate endTime as startTime + 1 hour
                          final endTime = selectedTime.add(Duration(hours: 1));

                          // Check if a time slot with the same startTime and lawyer already exists
                          final existingTimeSlot = await timeSlotsCollection
                              .where('lawyerEmail', isEqualTo: _user!.email)
                              .where('startTime',
                                  isEqualTo: Timestamp.fromDate(selectedTime))
                              .limit(1)
                              .get();

                          if (existingTimeSlot.docs.isEmpty) {
                            // No existing time slot with the same lawyer and startTime, add the new one
                            await timeSlotsCollection.add({
                              'startTime': Timestamp.fromDate(selectedTime),
                              'endTime': Timestamp.fromDate(endTime),
                              'available': true,
                              'lawyerEmail': _user!.email,
                            });

                            // Show a success toast using OkToast
                            showToast(
                              'تمت إضافة الوقت بنجاح',
                              backgroundColor: Colors.black,
                              radius: 10.0,
                              textStyle: TextStyle(color: Colors.white),
                              textPadding: EdgeInsets.all(10.0),
                              position: ToastPosition.bottom,
                              duration: Duration(seconds: 2),
                            );

                            // Clear the input fields
                            _dateController.clear();
                            setState(() {
                              _selectedHour = null;
                            });
                          } else {
                            // A time slot with the same lawyer and startTime already exists, show an error toast using OkToast
                            showToast(
                              'هذا الوقت موجود بالفعل',
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
                      ),
                      child: Text(
                        'اضافة',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Container(
                    height: 56,
                    width: 100,
                    child: DropdownButtonFormField<int>(
                      value: _selectedHour,
                      onChanged: (int? hour) {
                        setState(() {
                          _selectedHour = hour;
                        });
                      },
                      items: List.generate(24, (int hour) {
                        final formattedHour = hour.toString().padLeft(2, '0');
                        final formattedTime = '$formattedHour:00';

                        return DropdownMenuItem<int>(
                          value: hour,
                          child: Text(
                            formattedTime,
                            style: TextStyle(fontSize: 16, color: Colors.teal),
                          ),
                        );
                      }),
                      decoration: InputDecoration(
                        labelText: 'الوقت',
                        labelStyle: TextStyle(fontSize: 16, color: Colors.teal),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.teal, width: 2),
                        ),
                      ),
                      validator: _selectedTimeValidator,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _dateController,
                      decoration: InputDecoration(
                        labelText: 'التاريخ',
                        labelStyle: TextStyle(fontSize: 18, color: Colors.teal),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.teal, width: 2),
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<DateTime?> _showCustomDatePicker(BuildContext context) async {
    DateTime currentDate = DateTime.now();
    DateTime? selectedDate = currentDate;

    DateTime lastDateIn2023 = DateTime(2023, 12, 31);

    selectedDate = await showDialog<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Date'),
          content: Container(
            width: double.maxFinite,
            child: CalendarDatePicker(
              initialDate: currentDate,
              firstDate: currentDate,
              lastDate: lastDateIn2023,
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
}*/




/*i dont know what is it exactly
   Expanded(
                    child: TextFormField(
                      controller: _timeController,
                      decoration: InputDecoration(
                        labelText: 'حدد الوقت',
                        labelStyle: TextStyle(fontSize: 18, color: Colors.teal),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.teal, width: 2),
                        ),
                      ),
                      style: TextStyle(fontSize: 18),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'يجب ادخال الوقت';
                        }
                        return null;
                      },
                      onTap: () async {
                        // Show custom time picker
                        await _showCustomTimePicker(context);
                      },
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: _dateController,
                      decoration: InputDecoration(
                        labelText: 'حدد التاريخ',
                        labelStyle: TextStyle(fontSize: 18, color: Colors.teal),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.teal, width: 2),
                        ),
                      ),
                      style: TextStyle(fontSize: 18),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'يجب ادخال التاريخ';
                        }
                        return null;
                      },
                      onTap: () async {
                        // Show custom date picker
                        final selectedDate =
                            await _showCustomDatePicker(context);
                      },
                    ),
                  ),*/
/* Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          controller: _timeController,
                          decoration: InputDecoration(
                            labelText: 'حدد الوقت',
                            labelStyle:
                                TextStyle(fontSize: 18, color: Colors.teal),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(color: Colors.teal, width: 2),
                            ),
                          ),
                          style: TextStyle(fontSize: 18),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'يجب ادخال الوقت';
                            }
                            return null;
                          },
                          onTap: () async {
                            // Show custom time picker
                            await _showCustomTimePicker(context);
                          },
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: _dateController,
                          decoration: InputDecoration(
                            labelText: 'حدد التاريخ',
                            labelStyle:
                                TextStyle(fontSize: 18, color: Colors.teal),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(color: Colors.teal, width: 2),
                            ),
                          ),
                          style: TextStyle(fontSize: 18),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'يجب ادخال التاريخ';
                            }
                            return null;
                          },
                          onTap: () async {
                            // Show custom date picker
                            final selectedDate =
                                await _showCustomDatePicker(context);
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                      width: 16), // Add spacing between text fields and button
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        // Convert the time and date strings to DateTime
                        final timeParts = _timeController.text.split(':');
                        final hour = int.parse(timeParts[0]);
                        final minute = int.parse(timeParts[1]);

                        final dateParts = _dateController.text.split('-');
                        final year = int.parse(dateParts[0]);
                        final month = int.parse(dateParts[1]);
                        final day = int.parse(dateParts[2]);

                        final selectedTime =
                            DateTime(year, month, day, hour, minute);

                        // Add the time slot to Firestore
                        await timeSlotsCollection.add({
                          'startTime': Timestamp.fromDate(selectedTime),
                          'available': true, // Initially available
                          'lawyerId': '1', // Replace with the lawyer's ID
                        });

                        // Clear the input fields
                        _timeController.clear();
                        _dateController.clear();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.teal,
                    ),
                    child: Text(
                      'اضافة ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),*/
      /* Expanded(
                    child: TextFormField(
                      controller: _timeController,
                      decoration: InputDecoration(
                        labelText: 'حدد الوقت',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'يجب ادخال الوقت';
                        }
                        return null;
                      },
                      onTap: () async {
                        // Show custom time picker
                        await _showCustomTimePicker(context);
                      },
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: _dateController,
                      decoration: InputDecoration(
                        labelText: 'حدد التاريخ',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'يجب ادخال التاريخ';
                        }
                        return null;
                      },
                      onTap: () async {
                        // Show custom date picker
                        final selectedDate =
                            await _showCustomDatePicker(context);
                      },
                    ),
                  ),*/

/*Future<void> _showCustomTimePicker(BuildContext context) async {
    TimeOfDay selectedTime =
        TimeOfDay.now(); // Initialize as non-nullable with a default value

    selectedTime = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Time'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text('Hour: '),
                  DropdownButton<int>(
                    value: selectedTime.hour,
                    onChanged: (int? hour) {
                      setState(() {
                        selectedTime = TimeOfDay(
                          hour: hour ?? 0,
                          minute: 0,
                        ); // Always set minutes to zero
                      });
                    },
                    items: List.generate(24, (int hour) {
                      return DropdownMenuItem<int>(
                        value: hour,
                        child: Text(
                          hour.toString().padLeft(2, '0'),
                          style: TextStyle(color: Colors.teal),
                        ),
                      );
                    }),
                  ),
                  Text(
                    ':',
                    style: TextStyle(color: Colors.teal),
                  ),
                  Text(
                    '00',
                    style: TextStyle(color: Colors.teal),
                  ), // Always set minutes to zero
                ],
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(selectedTime);
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

    if (selectedTime != null) {
      final formattedTime =
          '${selectedTime.hour.toString().padLeft(2, '0')}:00';
      // Do something with the selected time, e.g., update the text controller
      _timeController.text = formattedTime;
    }
  }

  Future<void> _showCustomDatePicker(BuildContext context) async {
    DateTime currentDate = DateTime.now();
    DateTime selectedDate = currentDate;
    DateTime lastDateIn2023 = DateTime(2023, 12, 31);

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Date'),
          content: Container(
            width: double.maxFinite,
            child: CalendarDatePicker(
              initialDate: currentDate, // Set initialDate to current date
              firstDate: currentDate, // Start date is the current date
              lastDate: lastDateIn2023, // End on the last day of 2023
              onDateChanged: (DateTime newDate) {
                if (!newDate.isBefore(currentDate)) {
                  // Allow selecting dates starting from the current date
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

    if (selectedDate != null) {
      final formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
      // Do something with the selected date, e.g., update the text controller
      _dateController.text = formattedDate;
    }
  }*/