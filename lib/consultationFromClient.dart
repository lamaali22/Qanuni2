import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:qanuni/homePage.dart';

void main() {
  runApp(MyApp());
}

class Booking {
  final String lawyerEmail;
  final Timestamp startTime;

  Booking({
    required this.lawyerEmail,
    required this.startTime,
  });

  factory Booking.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Booking(
      lawyerEmail: data['lawyerEmail'],
      startTime: data['startTime'],
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BookingClientScreen(),
    );
  }
}

class BookingClientScreen extends StatefulWidget {
  @override
  _BookingListScreenState createState() => _BookingListScreenState();
}

class _BookingListScreenState extends State<BookingClientScreen> with TickerProviderStateMixin {
  late PageController _pageController;
  late User? _user; // To store the currently logged-in user
  late TabController _tabController;
  List<Booking> upcomingAppointments = [];
  List<Booking> previousAppointments = []; 
  
  void switchToPreviousAppointmentsTab() {
    // Switch to the "Previous Appointments" tab (index 1)
    _tabController.animateTo(1);
  }

  @override
  void initState() {
  super.initState();
      _pageController = PageController(initialPage: 0);
  // Initialize the user using Firebase Authentication
  _user = FirebaseAuth.instance.currentUser;
  _tabController = TabController(length: 2, vsync: this);

  // Set the default tab to be the first one (Upcoming Appointments)
  _tabController.index = 0;

  // Fetch and populate the upcoming appointments
  fetchUpcomingAppointments(_user?.email ?? '');

  // Fetch and populate the previous appointments
  fetchPreviousAppointments(_user?.email ?? '');
}

  @override
  void dispose() {
     _pageController.dispose();
    super.dispose();
  }

  void switchToUpcomingAppointments() {
    _pageController.animateToPage(0, duration: Duration(milliseconds: 300), curve: Curves.ease);
  }

  void switchToPreviousAppointments() {
    _pageController.animateToPage(1, duration: Duration(milliseconds: 300), curve: Curves.ease);
  }

  Future<void> fetchUpcomingAppointments(String clientEmail) async {
    final currentTime = Timestamp.now();

    final querySnapshot = await FirebaseFirestore.instance
        .collection('bookings')
        .where('clientEmail', isEqualTo: clientEmail)
        .where('endTime', isGreaterThan: currentTime)
        .get();

    final upcomingAppointmentsResult = <Booking>[];

    querySnapshot.docs.forEach((doc) {
      final booking = Booking.fromFirestore(doc);
      upcomingAppointmentsResult.add(booking);
    });

    // Update the upcomingAppointments list
    setState(() {
      upcomingAppointments = upcomingAppointmentsResult;
    });
  }

  Future<List<Booking>> fetchPreviousAppointments(String clientEmail) async {
    final previousAppointments = <Booking>[];
    final currentTime = Timestamp.now();

    final querySnapshot = await FirebaseFirestore.instance
        .collection('bookings')
        .where('clientEmail', isEqualTo: clientEmail)
        .where('endTime', isLessThan: currentTime)
        .get();

    querySnapshot.docs.forEach((doc) {
      final booking = Booking.fromFirestore(doc);
      previousAppointments.add(booking);
    });

    return previousAppointments;
  }

  void _navigateToScreen(BuildContext context, int index) {
    switch (index) {
      case 0:
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => LogoutPage()),
    (route) => false,
  );
  break;
case 1:
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => BookingClientScreen()),
    (route) => false,
  );
  break;
case 2:
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => LogoutPage()),
    (route) => false,
  );
  break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController( // Place DefaultTabController here
      length: 2, // Number of tabs
      child: Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(255, 0, 128, 128),
        title: const Text(
          "استشاراتي",
          style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        actions: [],
                // Add the TabBar to the appBar
        bottom: TabBar(
         // controller: _tabController,
          tabs: <Widget>[
            Tab(text: "المواعيد القادمة"),
            Tab(text: "المواعيد السابقة"),
          ],
        ),
      ),
      body:TabBarView(
 // controller: _pageController,
  children: <Widget>[
    _buildAppointmentsList(upcomingAppointments), // Upcoming Appointments Page
    FutureBuilder<List<Booking>>(
      future: fetchPreviousAppointments(_user?.email ?? ''),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final previousAppointments = snapshot.data!;
          if (previousAppointments.isEmpty) {
            return Center(child: Text('No previous appointments.'));
          } else {
            return _buildAppointmentsList(previousAppointments);
          }
        } else {
          return Center(child: Text('No data available.'));
        }
      },
    ),
        ],
      ),
      // Navigation bar
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Color(0x7F008080),
        unselectedItemColor: Colors.black,
        showUnselectedLabels: true,
        onTap: (index) => _navigateToScreen(context, index),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.person_2_outlined),
            label: 'جسابي',
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
    ),
    );
  }

  Widget _buildAppointmentsList(List<Booking> appointments) {
    if (appointments.isEmpty) {
      return Center(child: Text('لايوجد مواعيد محجوزة'));
    } else {
      return ListView.builder(
        itemCount: appointments.length,
        itemBuilder: (context, index) {
          return FutureBuilder<Map<String, String>>(
            future: fetchLawyerInfo(appointments[index].lawyerEmail),
            builder: (context, lawyerSnapshot) {
              if (lawyerSnapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (lawyerSnapshot.hasError) {
                return Text('Error: ${lawyerSnapshot.error}');
              } else if (lawyerSnapshot.hasData) {
                final lawyerInfo = lawyerSnapshot.data!;
                final booking = appointments[index];
                final startTimeDate = booking.startTime.toDate();
                final dateFormatted = DateFormat('yyyy-MM-dd').format(startTimeDate);
                final timeFormatted = DateFormat('HH:mm').format(startTimeDate);

                return Container(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ListTile(
                        title: Text(
                          " ${lawyerInfo['firstName']} ${lawyerInfo['lastName']}",
                          style: TextStyle(color: Colors.black),
                          textAlign: TextAlign.right,
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "تاريخ الجلسة: $dateFormatted",
                              style: TextStyle(color: Colors.black),
                              textAlign: TextAlign.right,
                            ),
                            Text(
                              "موعد الجلسة: $timeFormatted",
                              style: TextStyle(color: Colors.black),
                              textAlign: TextAlign.right,
                            ),
                            Text(
                              "مدة الجلسة: ساعة واحدة",
                              style: TextStyle(color: Colors.black),
                              textAlign: TextAlign.right,
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          // Handle button click here
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          onPrimary: Colors.blue,
                          minimumSize: Size(350, 35),
                          side: BorderSide(color: Colors.black),
                        ),
                        icon: Icon(
                          Icons.chat,
                          color: Colors.teal,
                        ),
                        label: Text(
                          "ابدأ الاستشارة",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return Text('No data available.');
              }
            },
          );
        },
      );
    }
  }

  Future<Map<String, String>> fetchLawyerInfo(String lawyerEmail) async {
    final lawyerInfo = <String, String>{};
    final querySnapshot = await FirebaseFirestore.instance
        .collection('lawyers')
        .where('email', isEqualTo: lawyerEmail)
        .get();
    querySnapshot.docs.forEach((doc) {
      final lawyer = Lawyer.fromFirestore(doc);
      lawyerInfo['firstName'] = lawyer.firstName;
      lawyerInfo['lastName'] = lawyer.lastName;
    });
    return lawyerInfo;
  }
}

class Lawyer {
  final String email;
  final String firstName;
  final String lastName;

  Lawyer({
    required this.email,
    required this.firstName,
    required this.lastName,
  });

  factory Lawyer.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Lawyer(
      email: data['email'],
      firstName: data['firstName'],
      lastName: data['lastName'],
    );
  }
}
