import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qanuni/presentation/screens/bookingListScreen.dart';
import 'package:qanuni/presentation/screens/client_signup_screen/view.dart';
import 'package:qanuni/presentation/screens/add_timeslots_Screen.dart';

import 'package:qanuni/presentation/screens/login_screen/view.dart';
import 'package:qanuni/presentation/screens/toggleBar.dart';
import 'package:qanuni/viewListOfLawyers.dart';

/*class LogoutPageLawyer extends StatefulWidget {
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
        //   .where('startTime',
        // isGreaterThanOrEqualTo: Timestamp.fromDate(futureStartTime))
        .where('available', isEqualTo: true)
        // .orderBy('startTime')
        .get();
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
      ), //navigation Bar
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
}*/

/// the replaced code with some logic errors
/*
class LogoutPageLawyer extends StatefulWidget {
  @override
  _LogoutPageLawyerState createState() => _LogoutPageLawyerState();
}

class _LogoutPageLawyerState extends State<LogoutPageLawyer> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User? _user;
  final CollectionReference timeSlotsCollection =
      FirebaseFirestore.instance.collection('timeSlots');
  late List<DateTime> availableDates; // List to store available dates
  late DateTime? selectedDate; // Selected date
  late Map<DateTime, List<DocumentSnapshot>> timeSlotsMap;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();

    _user = FirebaseAuth.instance.currentUser;
    super.initState();

    selectedDate = DateTime.now();
    super.initState();

    availableDates = [];
    super.initState();

    timeSlotsMap = {};
    super.initState();

    fetchAvailableTimeSlots();
    super.initState();
  }

  @override
  void dispose() {
    _isDisposed = true; // Set to true when disposing
    super.dispose();
  }

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

  Future<void> fetchAvailableTimeSlots() async {
    final snapshot = await getAvailableTimeSlots();
    final timeSlots = snapshot.docs;

    Map<DateTime, List<DocumentSnapshot>> map = {};
    for (var timeSlot in timeSlots) {
      if (_isDisposed) return; // Check if disposed before setState

      final startTime = (timeSlot['startTime'] as Timestamp).toDate().toLocal();
      final date = DateTime(startTime.year, startTime.month, startTime.day);

      if (map.containsKey(date)) {
        map[date]!.add(timeSlot);
      } else {
        map[date] = [timeSlot];
      }
    }

    if (!_isDisposed) {
      setState(() {
        timeSlotsMap = map;
      });
    }
  }

  Future<QuerySnapshot> getAvailableTimeSlots() async {
    final now = DateTime.now();
    final futureStartTime = now.add(Duration(hours: 1));

    return await timeSlotsCollection
        .where('lawyerEmail', isEqualTo: _user!.email)
        .where('available', isEqualTo: true)
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
          Container(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: timeSlotsMap.keys.length,
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
          Expanded(
            child: ListView.builder(
              itemCount: timeSlotsMap[selectedDate]?.length ?? 0,
              itemBuilder: (context, index) {
                final timeSlot = timeSlotsMap[selectedDate]![index];
                final startTime = (timeSlot['startTime'] as Timestamp).toDate();
                final formattedTime = DateFormat('HH:mm').format(startTime);

                return Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey,
                        width: 0.5,
                      ),
                    ),
                  ),
                  child: ListTile(
                    title: Text(
                      formattedTime,
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
}*/
class LogoutPageLawyer extends StatefulWidget {
  @override
  _LogoutPageLawyerState createState() => _LogoutPageLawyerState();
}

class _LogoutPageLawyerState extends State<LogoutPageLawyer> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User? _user;
  final CollectionReference timeSlotsCollection =
      FirebaseFirestore.instance.collection('timeSlots');
  late List<DateTime> availableDates;
  late DateTime? selectedDate;
  Map<DateTime, List<DocumentSnapshot>> timeSlotsMap = {};

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
    super.initState();
    selectedDate = DateTime.now();
    super.initState();
    availableDates = [];
    super.initState();
    fetchAvailableTimeSlots();
    super.initState();
  }

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

  Future<void> fetchAvailableTimeSlots() async {
    final snapshot = await getAvailableTimeSlots();
    final timeSlots = snapshot.docs;

    Map<DateTime, List<DocumentSnapshot>> map = {};
    for (var timeSlot in timeSlots) {
      final startTime = (timeSlot['startTime'] as Timestamp).toDate().toLocal();
      final date = DateTime(startTime.year, startTime.month, startTime.day);

      if (map.containsKey(date)) {
        map[date]!.add(timeSlot);
      } else {
        map[date] = [timeSlot];
      }
    }

    setState(() {
      timeSlotsMap = map;
    });
  }

  Future<QuerySnapshot> getAvailableTimeSlots() async {
    final now = DateTime.now();
    final futureStartTime = now.add(Duration(hours: 1));

    return await timeSlotsCollection
        .where('lawyerEmail', isEqualTo: _user!.email)
        .where('available', isEqualTo: true)
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
          Container(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: timeSlotsMap.keys.length,
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
          Expanded(
            child: ListView.builder(
              itemCount: timeSlotsMap.containsKey(selectedDate)
                  ? timeSlotsMap[selectedDate]!.length
                  : 0,
              itemBuilder: (context, index) {
                final timeSlot = timeSlotsMap[selectedDate]![index];
                final startTime = timeSlot['startTime'] as Timestamp;
                final formattedTime =
                    DateFormat('HH:mm').format(startTime.toDate());

                return Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey,
                        width: 0.5,
                      ),
                    ),
                  ),
                  child: ListTile(
                    title: Text(
                      formattedTime,
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
}
