import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:qanuni/homePageLawyer.dart';
import 'package:qanuni/lawyerProfile.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

void main() {
  runApp(MyApp());
}

class Booking {
  final String clientEmail;
  final Timestamp startTime;
  final Timestamp endTime;
  final String bookingId;

  Booking({
    required this.clientEmail,
    required this.startTime,
    required this.endTime,
    required this.bookingId,
  });

  factory Booking.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Booking(
      clientEmail: data['clientEmail'],
      startTime: data['startTime'],
      endTime: data['endTime'],
      bookingId: doc.id,
    );
  }
}

class Client {
  final String email;
  final String firstName;
  final String lastName;

  Client({
    required this.email,
    required this.firstName,
    required this.lastName,
  });

  factory Client.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Client(
      email: data['email'],
      firstName: data['firstName'],
      lastName: data['lastName'],
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BookingListScreen(),
    );
  }
}

class BookingListScreen extends StatefulWidget {
  @override
  _BookingListScreenState createState() => _BookingListScreenState();
}

class _BookingListScreenState extends State<BookingListScreen>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late User? _user;
  late TabController _tabController;
  List<Booking> upcomingAppointments = [];
  List<Booking> previousAppointments = [];
  // bool showUpcomingAppointments = true; // To switch between upcoming and previous appointments

  void switchToPreviousAppointmentsTab() {
    // Switch to the "Previous Appointments" tab (index 1)
    _tabController.animateTo(1);
  }

  @override
  void initState() {
    super.initState();

    _pageController = PageController(initialPage: 0);
    _user = FirebaseAuth.instance.currentUser;
    _tabController = TabController(length: 2, vsync: this);

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
    _pageController.animateToPage(0,
        duration: Duration(milliseconds: 300), curve: Curves.ease);
  }

  void switchToPreviousAppointments() {
    _pageController.animateToPage(1,
        duration: Duration(milliseconds: 300), curve: Curves.ease);
  }

  Future<void> fetchUpcomingAppointments(String lawyerEmail) async {
    final currentTime = Timestamp.now();

    final querySnapshot = await FirebaseFirestore.instance
        .collection('bookings')
        .where('lawyerEmail', isEqualTo: lawyerEmail)
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

  Future<List<Booking>> fetchPreviousAppointments(String lawyerEmail) async {
    final previousAppointments = <Booking>[];
    final currentTime = Timestamp.now();

    final querySnapshot = await FirebaseFirestore.instance
        .collection('bookings')
        .where('lawyerEmail', isEqualTo: lawyerEmail)
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

  List<Booking> filterPreviousAppointments(List<Booking> bookings) {
    final currentTime = Timestamp.now();
    return bookings
        .where((booking) =>
            booking.endTime.toDate().isBefore(currentTime.toDate()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      // Place DefaultTabController here
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Color.fromARGB(255, 0, 128, 128),
          title: const Text(
            "مواعيدي",
            style: TextStyle(
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w500,
                color: Colors.white),
          ),
          centerTitle: true,
          actions: [],
          // Add the TabBar to the appBar
          bottom: TabBar(
            //  controller: _tabController,
            tabs: <Widget>[
              Tab(text: "المواعيد القادمة"),
              Tab(text: "المواعيد السابقة"),
            ],
          ),
        ),
        body: TabBarView(
          // controller: _tabController,
          children: <Widget>[
            _buildAppointmentsList(
                upcomingAppointments), // Upcoming Appointments Page
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
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/calendar.png',
                            width: 170, // Set the desired width
                            height: 170, // Set the desired height
                          ),
                          SizedBox(
                              height: 16), // Add space between icon and text
                          Text(
                            'لايوجد مواعيد سابقة',
                            style: TextStyle(
                              color: Color.fromARGB(255, 52, 188, 174),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
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
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.black,
          showUnselectedLabels: true,
          onTap: (index) => _navigateToScreen(context, index),
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.person_2_outlined),
              label: 'حسابي',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.calendar_month_outlined,
                color: Colors.teal,
              ),
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
    // Sort the appointments in ascending order (oldest first)
    appointments.sort((a, b) => a.startTime.compareTo(b.startTime));
    if (appointments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/calendar.png',
              width: 170, // Set the desired width
              height: 170, // Set the desired height
            ),
            SizedBox(height: 16), // Add space between icon and text
            Text(
              'لايوجد مواعيد قادمة',
              style: TextStyle(
                color: Color.fromARGB(255, 52, 188, 174),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    } else {
      return ListView.builder(
        itemCount: appointments.length,
        itemBuilder: (context, index) {
          return FutureBuilder<Map<String, String>>(
            future: fetchClientInfo(appointments[index].clientEmail),
            builder: (context, clientSnapshot) {
              if (clientSnapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (clientSnapshot.hasError) {
                return Text('Error: ${clientSnapshot.error}');
              } else if (clientSnapshot.hasData) {
                final clientInfo = clientSnapshot.data!;
                final booking = appointments[index];
                final startTimeDate = booking.startTime.toDate();
                final dateFormatted =
                    DateFormat('yyyy-MM-dd').format(startTimeDate);
                final timeFormatted = DateFormat('HH:mm').format(startTimeDate);
                final currentTime = DateTime.now();
                final scheduledTime = startTimeDate;
                final endTimeDate = booking.endTime.toDate();

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
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "ساعة واحدة",
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 15.0,
                                fontFamily: 'Cairo',
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.right,
                            ),
                            const SizedBox(width: 12),
                            Icon(
                              Icons.hourglass_empty,
                              color: const Color(0xFF008080),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              " ${clientInfo['firstName']} ${clientInfo['lastName']}",
                              style: TextStyle(color: Colors.black),
                              textAlign: TextAlign.right,
                            ),
                            const SizedBox(width: 12),
                            Icon(
                              Icons.person_2_outlined,
                              color: const Color(0xFF008080),
                            ),
                          ],
                        ),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(width: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                const SizedBox(
                                    width: 24), // Adjust the width as needed
                                Text(
                                  "$timeFormatted",
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 15.0,
                                    fontFamily: 'Cairo',
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                                const SizedBox(width: 12),
                                Icon(
                                  Icons.access_time,
                                  color: const Color(0xFF008080),
                                ),
                              ],
                            ),
                            SizedBox(
                                width:
                                    35), // Add space between title and subtitle
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  "$dateFormatted",
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 15.0,
                                    fontFamily: 'Cairo',
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                                const SizedBox(width: 12),
                                Icon(
                                  Icons.date_range,
                                  color: const Color(0xFF008080),
                                ),
                              ],
                            ),
                            // Add space between rows
                          ],
                        ),
                      ),
                      if (booking.endTime.toDate().isAfter(DateTime
                          .now())) // Show the button only for upcoming appointments
                        ElevatedButton.icon(
                          onPressed: () {
                            // Handle button click here to initiate a video call
                            // You can use Zego or any other video call implementation
                            if (currentTime.isAfter(scheduledTime) &&
                                currentTime.isBefore(endTimeDate)) {
                              // Allow the session to start only if it's after the scheduled time
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CallPage(
                                    callID: booking.bookingId,
                                  ),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            primary: currentTime.isAfter(scheduledTime) &&
                                    currentTime.isBefore(endTimeDate)
                                ? Color.fromARGB(
                                    255, 0, 128, 128) // Active session style
                                : Colors.white, // Inactive session style
                            onPrimary: currentTime.isAfter(scheduledTime)
                                ? Colors.white // Text color for active session
                                : Color.fromARGB(255, 0, 128,
                                    128), // Text color for inactive session
                            minimumSize: Size(350, 35),
                            side: BorderSide(color: Colors.black),
                          ),
                          icon: Icon(
                            Icons.chat,
                            color: currentTime.isAfter(scheduledTime) &&
                                    currentTime.isBefore(endTimeDate)
                                ? Colors.white // Icon color for active session
                                : Color.fromARGB(255, 0, 128,
                                    128), // Icon color for inactive session
                          ),
                          label: Text(
                            "ابدأ الاستشارة",
                            style: TextStyle(
                              color: currentTime.isAfter(scheduledTime) &&
                                      currentTime.isBefore(endTimeDate)
                                  ? Colors
                                      .white // Text color for active session
                                  : Color.fromARGB(255, 0, 128,
                                      128), // Text color for inactive session
                              fontWeight: currentTime.isAfter(scheduledTime) &&
                                      currentTime.isBefore(endTimeDate)
                                  ? FontWeight
                                      .bold // Bold text for active session
                                  : FontWeight
                                      .normal, // Normal text for inactive session
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

  Future<Map<String, String>> fetchClientInfo(String clientEmail) async {
    final clientInfo = <String, String>{};
    final querySnapshot = await FirebaseFirestore.instance
        .collection('Clients')
        .where('email', isEqualTo: clientEmail)
        .get();
    querySnapshot.docs.forEach((doc) {
      final client = Client.fromFirestore(doc);
      clientInfo['firstName'] = client.firstName;
      clientInfo['lastName'] = client.lastName;
    });
    return clientInfo;
  }
}

class CallPage extends StatelessWidget {
  const CallPage({Key? key, required this.callID}) : super(key: key);
  final String callID;

  @override
  Widget build(BuildContext context) {
    // Assuming you have a way to get the lawyer's first and last name
    final lawyerFirstName =
        'Lawyer First Name'; // Replace with the actual lawyer's first name
    final lawyerLastName =
        'Lawyer Last Name'; // Replace with the actual lawyer's last name
    final lawyerName = '$lawyerFirstName $lawyerLastName';

    return ZegoUIKitPrebuiltCall(
      appID: 1464607761,
      appSign:
          'c10ad908a7e7cb650c8d4c27f74be82d0645530aebd37f670361d49d5d90b9ec',
      userID: FirebaseAuth.instance.currentUser?.email ?? '',
      userName: lawyerName,
      callID: callID,
      config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
        ..onOnlySelfInRoom = (context) => Navigator.of(context).pop(),
    );
  }
}
