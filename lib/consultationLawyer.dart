/*import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:qanuni/homePageLawyer.dart';
import 'package:qanuni/viewProfileLawyer.dart';

void main() {
  runApp(MyApp());
}

class Booking {
  final String clientEmail;
  final Timestamp startTime;

  Booking({
    required this.clientEmail,
    required this.startTime,
  });

  factory Booking.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Booking(
      clientEmail: data['clientEmail'],
      startTime: data['startTime'],
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

class _BookingListScreenState extends State<BookingListScreen> {
  late User? _user; // To store the currently logged-in user

  @override
  void initState() {
    super.initState();
    // Initialize the user using Firebase Authentication
    _user = FirebaseAuth.instance.currentUser;
  }

  Future<List<Booking>> fetchBookings(String lawyerEmail) async {
    final bookings = <Booking>[];
    final querySnapshot = await FirebaseFirestore.instance
        .collection('bookings')
        .where('lawyerEmail', isEqualTo: lawyerEmail)
        .get();
    querySnapshot.docs.forEach((doc) {
      final booking = Booking.fromFirestore(doc);
      bookings.add(booking);
    });
    return bookings;
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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(255, 0, 128, 128),
        title: const Text(
          "استشاراتي",
          style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        actions: [],
      ),
      body: FutureBuilder<List<Booking>>(
        future:
            fetchBookings(_user?.email ?? ''), // Use the logged-in user's email
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final bookings = snapshot.data!;
            if (bookings.isEmpty) {
              return Center(child: Text('لايوجد مواعيد محجوزة'));
            } else {
              return ListView.builder(
                itemCount: bookings.length,
                itemBuilder: (context, index) {
                  return FutureBuilder<Map<String, String>>(
                    future: fetchClientInfo(bookings[index].clientEmail),
                    builder: (context, clientSnapshot) {
                      if (clientSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (clientSnapshot.hasError) {
                        return Text('Error: ${clientSnapshot.error}');
                      } else if (clientSnapshot.hasData) {
                        final clientInfo = clientSnapshot.data!;
                        final booking = bookings[index];
                        final startTimeDate = booking.startTime.toDate();
                        final dateFormatted =
                            DateFormat('yyyy-MM-dd').format(startTimeDate);
                        final timeFormatted =
                            DateFormat('HH:mm').format(startTimeDate);
                        //final startTime = booking.startTime.toDate();
                        print(
                            "Raw Timestamp: ${booking.startTime}"); // Debug print
                        print("Formatted Time: $timeFormatted"); // Debug print
                        print(booking.startTime.toDate());
                        return Container(
                          margin:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ListTile(
                                title: Text(
                                  " ${clientInfo['firstName']} ${clientInfo['lastName']}",
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
                                  primary: Colors
                                      .white, // Background color of the button
                                  onPrimary: Colors.blue,
                                  minimumSize:
                                      Size(350, 35), // Color of text and icon
                                  side: BorderSide(
                                      color: Colors.black), // Border color
                                ),
                                icon: Icon(
                                  Icons.chat,
                                  color: Colors.teal,
                                ), // Icon on the left
                                label: Text(
                                  "ابدأ الاستشارة", // Text on the right
                                  style: TextStyle(
                                    color: Colors.black, // Text color
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
          } else {
            return Center(child: Text('No data available.'));
          }
        },
      ),
      //navigation bar
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
*/

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:qanuni/homePageLawyer.dart';

void main() {
  runApp(MyApp());
}

class Booking {
  final String clientEmail;
  final Timestamp startTime;
  final Timestamp endTime;

  Booking({
    required this.clientEmail,
    required this.startTime,
    required this.endTime,
  });

  factory Booking.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Booking(
      clientEmail: data['clientEmail'],
      startTime: data['startTime'],
      endTime: data['endTime'],
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

class _BookingListScreenState extends State<BookingListScreen> with TickerProviderStateMixin{
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
    _pageController.animateToPage(0, duration: Duration(milliseconds: 300), curve: Curves.ease);
  }

  void switchToPreviousAppointments() {
    _pageController.animateToPage(1, duration: Duration(milliseconds: 300), curve: Curves.ease);
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






  List<Booking> filterPreviousAppointments(List<Booking> bookings) {
    final currentTime = Timestamp.now();
    return bookings.where((booking) => booking.endTime.toDate().isBefore(currentTime.toDate())).toList();
  }

 /* Future<Map<String, String>> fetchClientInfo(String clientEmail) async {
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
  }*/

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
        //  controller: _tabController,
          tabs: <Widget>[
            Tab(text: "المواعيد القادمة"),
            Tab(text: "المواعيد السابقة"),
          ],
        ),
      ),
  body: TabBarView(
 // controller: _tabController,
  children:<Widget>[
     _buildAppointmentsList(upcomingAppointments), // Upcoming Appointments Page
    FutureBuilder<List<Booking>>(
      future:fetchPreviousAppointments(_user?.email ?? ''),
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
                                " ${clientInfo['firstName']} ${clientInfo['lastName']}",
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
                           /* ElevatedButton.icon(
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
                            )*/
    ElevatedButton.icon(
  onPressed: () {
    if (appointments[index].startTime.toDate().isBefore(DateTime.now())) {
      // Handle "Consultation Evaluation" action for previous appointments
    } else {
      // Handle "Start Consultation" action for upcoming appointments
    }
  },
  style: ElevatedButton.styleFrom(
    primary: Colors.white,
    onPrimary: Colors.blue,
    minimumSize: const Size(350, 35),
    side: const BorderSide(color: Colors.black),
  ),
  icon: Icon(
    appointments[index].startTime.toDate().isBefore(DateTime.now())
        ? Icons.star // Star icon for "Consultation Evaluation" in previous appointments
        : Icons.chat, // Chat icon for "Start Consultation" in upcoming appointments
    color: Colors.teal,
  ),
  label: Text(
    appointments[index].startTime.toDate().isBefore(DateTime.now())
        ? "تقييم الأستشارة" // "Consultation Evaluation" for previous appointments
        : "ابدأ الأستشارة", // "Start Consultation" for upcoming appointments
    style: TextStyle(
      color: Colors.black,
    ),
  ),
)


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
   

