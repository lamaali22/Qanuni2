
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:oktoast/oktoast.dart';
import 'package:qanuni/homePage.dart';
import 'package:qanuni/presentation/screens/client_review/view.dart';
import 'package:qanuni/providers/client_review/cubit/client_review_cubit.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

void main() {
  runApp(MyApp());
}

class Booking {
  final String lawyerEmail;
  final Timestamp startTime;
  final Timestamp endTime;
  final String bookingId;
  final String? review;
  final double? rate;

  Booking(
      {required this.lawyerEmail,
      required this.startTime,
      required this.endTime,
      required this.bookingId,
      this.review,
      this.rate});

  factory Booking.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Booking(
      lawyerEmail: data['lawyerEmail'],
      startTime: data['startTime'],
       endTime: data['endTime'],
      bookingId: doc.id,
      review: data['review'] ?? '',
      rate: data['rate'] != null
          ? (data['rate'] is int
              ? (data['rate'] as int).toDouble()
              : data['rate'])
          : null,
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

class _BookingListScreenState extends State<BookingClientScreen>
    with TickerProviderStateMixin {
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
    _pageController.animateToPage(0,
        duration: Duration(milliseconds: 300), curve: Curves.ease);
  }

  void switchToPreviousAppointments() {
    _pageController.animateToPage(1,
        duration: Duration(milliseconds: 300), curve: Curves.ease);
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
    return DefaultTabController(
      // Place DefaultTabController here
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
        body: TabBarView(
          // controller: _pageController,
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
      ),
    );
  }

  Widget _buildAppointmentsList(List<Booking> appointments) {
    // Sort the appointments in ascending order (oldest first)
  appointments.sort((a, b) => a.startTime.compareTo(b.startTime));
    if (appointments.isEmpty) {
      return Center(child: Text('لايوجد مواعيد محجوزة'));
    } else {
      return ListView.builder(
        itemCount: appointments.length,
        itemBuilder: (context, index) {
          return FutureBuilder<Map<String, dynamic>>(
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
                final dateFormatted =
                    DateFormat('yyyy-MM-dd').format(startTimeDate);
                final timeFormatted = DateFormat('HH:mm').format(startTimeDate);
                final currentTime = DateTime.now();
                final endTimeDate= booking.endTime.toDate();

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
                    /*ElevatedButton.icon(
                        onPressed: () {
                          // Handle button click here
                          if (booking.review != null &&
                              booking.review!.isNotEmpty &&
                              booking.rate != null) {
                                showToast('تم التقييم مسبقا',position:ToastPosition.bottom);
                          } else {
                            ClientReviewCubit.get(context).init(
                                lawyerInfo['firstName'] +
                                    ' ' +
                                    lawyerInfo['lastName'],
                                lawyerInfo['photoURL'],
                                lawyerInfo['AverageRating'],
                                booking.bookingId,
                                lawyerInfo['specialties'],
                                booking.lawyerEmail,
                                booking.review,
                                booking.rate);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ClientReviewScreen(),
                                ));
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          onPrimary: Colors.blue,
                          minimumSize: Size(350, 35),
                          side: BorderSide(color: Colors.black),
                        ),
                        icon: Icon(
                          Icons.chat,
                          color: booking.review != null &&
                                  booking.review!.isNotEmpty &&
                                  booking.rate != null
                              ? Colors.grey
                              : Colors.teal,
                        ),
                        label: Text(
                          "اترك تعليق",
                          style: TextStyle(
                            color: booking.review != null &&
                                    booking.review!.isNotEmpty &&
                                    booking.rate != null
                                ? Colors.grey
                                : Colors.black,
                          ),
                        ),
                      ),*/
                     ElevatedButton.icon(
  onPressed: () {
    if (appointments[index].startTime.toDate().isBefore(DateTime.now()) && appointments[index].endTime.toDate().isBefore(DateTime.now())) {
      // Handle button click here
      if (booking.review != null &&
          booking.review!.isNotEmpty &&
          booking.rate != null) {
        showToast('تم التقييم مسبقا', position: ToastPosition.bottom);
      } else {
        ClientReviewCubit.get(context).init(
          lawyerInfo['firstName'] + ' ' + lawyerInfo['lastName'],
          lawyerInfo['photoURL'],
          lawyerInfo['AverageRating'],
          booking.bookingId,
          lawyerInfo['specialties'],
          booking.lawyerEmail,
          booking.review,
          booking.rate,
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ClientReviewScreen(),
          ),
        );
      }
      // Handle "Consultation Evaluation" action for previous appointments
    } else if (currentTime.isAfter(startTimeDate) && currentTime.isBefore(endTimeDate)) {
      // Handle "Start Session" action when the session is active
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
  icon: Icon(
    appointments[index].startTime.toDate().isBefore(DateTime.now())  && appointments[index].endTime.toDate().isBefore(DateTime.now())
        ? Icons.star // Star icon for "Consultation Evaluation" in previous appointments
        : Icons.chat, // Chat icon for "Start Consultation" in upcoming appointments
    color: appointments[index].startTime.toDate().isBefore(DateTime.now())  && appointments[index].endTime.toDate().isBefore(DateTime.now())
        ? Colors.amber // Set color to yellow for the star icon in past appointments
        : Color.fromARGB(255, 0, 128, 128),
// Set color to teal for the chat icon in upcoming appointments
  ),
  label: Text(
    appointments[index].startTime.toDate().isBefore(DateTime.now())  && appointments[index].endTime.toDate().isBefore(DateTime.now())
        ? "تقييم الاستشارة" // "Consultation Evaluation" for previous appointments
        : "ابدا الاستشارة", // "Start Session" for upcoming appointments
    style: TextStyle(
      color: currentTime.isAfter(startTimeDate) && currentTime.isBefore(endTimeDate)
          ? Colors.white // Text color is white for "Start Session"
          : Colors.black, // Text color is black for other cases
    ),
  ),
  style: ElevatedButton.styleFrom(
    primary: currentTime.isAfter(startTimeDate) && currentTime.isBefore(endTimeDate)
        ? Color.fromARGB(255, 0, 128, 128) // Active session, background color is teal
        : Colors.white, // Inactive session, background color is white
    minimumSize: const Size(350, 35),
    side: const BorderSide(color: Colors.black),
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

  Future<Map<String, dynamic>> fetchLawyerInfo(String lawyerEmail) async {
    final lawyerInfo = <String, dynamic>{};
    final querySnapshot = await FirebaseFirestore.instance
        .collection('lawyers')
        .where('email', isEqualTo: lawyerEmail)
        .get();
    querySnapshot.docs.forEach((doc) {
      final lawyer = Lawyer.fromFirestore(doc);
      lawyerInfo['photoURL'] = lawyer.photoURL;
      lawyerInfo['specialties'] = lawyer.specialties;
      lawyerInfo['AverageRating'] = lawyer.averageRating;
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
  final String photoURL;
  final String averageRating;
  final List<dynamic> specialties;

  Lawyer(
      {required this.email,
      required this.firstName,
      required this.lastName,
      required this.photoURL,
      required this.averageRating,
      required this.specialties});

  factory Lawyer.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Lawyer(
        email: data['email'],
        firstName: data['firstName'],
        lastName: data['lastName'],
        photoURL: data['photoURL'],
        averageRating: data['AverageRating'],
        specialties: data['specialties'] != null ? data['specialties'] : []);
  }
}

class CallPage extends StatelessWidget {
  const CallPage({Key? key, required this.callID}) : super(key: key);
  final String callID;

  @override
  Widget build(BuildContext context) {
     // Assuming you have a way to get the lawyer's first and last name
    final clientFirstName = 'Lawyer First Name';  // Replace with the actual lawyer's first name
    final clientLastName = 'Lawyer Last Name';    // Replace with the actual lawyer's last name
    final clientName = '$clientFirstName $clientLastName';

    
    return ZegoUIKitPrebuiltCall(
      appID: 1464607761,
      appSign: 'c10ad908a7e7cb650c8d4c27f74be82d0645530aebd37f670361d49d5d90b9ec',
      userID: FirebaseAuth.instance.currentUser?.email ?? '',
      userName: clientName,
      callID: callID,
      config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
        ..onOnlySelfInRoom = (context) => Navigator.of(context).pop(),
    );
  }
}




/*import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:qanuni/homePage.dart';
import 'package:qanuni/homePageLawyer.dart';
import 'package:qanuni/presentation/screens/client_review/view.dart';
import 'package:qanuni/providers/client_review/cubit/client_review_cubit.dart';

void main() {
  runApp(MyApp());
}

class Booking {
  final String lawyerEmail;
  final Timestamp startTime;
  final String bookingId;

  Booking(
      {required this.lawyerEmail,
      required this.startTime,
      required this.bookingId});

  factory Booking.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Booking(
        lawyerEmail: data['lawyerEmail'],
        startTime: data['startTime'],
        bookingId: doc.id);
  }
}

class Lawyer {
  final String email;
  final String firstName;
  final String lastName;
  final String photoURL;
  final String averageRating;
  final List<dynamic> specialties;

  Lawyer(
      {required this.email,
      required this.firstName,
      required this.lastName,
      required this.photoURL,
      required this.averageRating,
      required this.specialties});

  factory Lawyer.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Lawyer(
        email: data['email'],
        firstName: data['firstName'],
        lastName: data['lastName'],
        photoURL: data['photoURL'],
        averageRating: data['AverageRating'],
        specialties: data['specialties'] != null ? data['specialties'] : []);
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

class _BookingListScreenState extends State<BookingClientScreen> {
  late User? _user; // To store the currently logged-in user

  @override
  void initState() {
    super.initState();
    // Initialize the user using Firebase Authentication
    _user = FirebaseAuth.instance.currentUser;
  }

  Future<List<Booking>> fetchBookings(String clientEmail) async {
    final bookings = <Booking>[];
    final querySnapshot = await FirebaseFirestore.instance
        .collection('bookings')
        .where('clientEmail', isEqualTo: clientEmail)
        .get();
    querySnapshot.docs.forEach((doc) {
      final booking = Booking.fromFirestore(doc);
      bookings.add(booking);
    });
    return bookings;
  }

  Future<Map<String, dynamic>> fetchLawyerInfo(String lawyerEmail) async {
    final lawyerInfo = <String, dynamic>{};
    final querySnapshot = await FirebaseFirestore.instance
        .collection('lawyers')
        .where('email', isEqualTo: lawyerEmail)
        .get();
    querySnapshot.docs.forEach((doc) {
      final lawyer = Lawyer.fromFirestore(doc);
      lawyerInfo['photoURL'] = lawyer.photoURL;
      lawyerInfo['specialties'] = lawyer.specialties;
      lawyerInfo['AverageRating'] = lawyer.averageRating;
      lawyerInfo['firstName'] = lawyer.firstName;
      lawyerInfo['lastName'] = lawyer.lastName;
    });
    return lawyerInfo;
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
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(255, 0, 128, 128),
        title: const Text(
          "مواعيدي",
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
              return Center(
                child: Container(
                  margin: EdgeInsets.all(16),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.teal),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.teal[50], // Teal background color
                  ),
                  child: Text(
                    'لايوجد مواعيد قادمة',
                    style: TextStyle(
                      color: Colors.teal,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            } else {
              return ListView.builder(
                itemCount: bookings.length,
                itemBuilder: (context, index) {
                  return FutureBuilder<Map<String, dynamic>>(
                    future: fetchLawyerInfo(bookings[index].lawyerEmail),
                    builder: (context, lawyerSnapshot) {
                      if (lawyerSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (lawyerSnapshot.hasError) {
                        return Text('Error: ${lawyerSnapshot.error}');
                      } else if (lawyerSnapshot.hasData) {
                        final lawyerInfo = lawyerSnapshot.data!;
                        final booking = bookings[index];
                        final startTimeDate = booking.startTime.toDate();
                        final dateFormatted =
                            DateFormat('yyyy-MM-dd').format(startTimeDate);
                        final timeFormatted =
                            DateFormat('HH:mm').format(startTimeDate);

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
                                  ClientReviewCubit.get(context).init(
                                      lawyerInfo['firstName'] +
                                          ' ' +
                                          lawyerInfo['lastName'],
                                      lawyerInfo['photoURL'],
                                      lawyerInfo['AverageRating'],
                                      booking.bookingId,
                                      lawyerInfo['specialties'],
                                      booking.lawyerEmail);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const ClientReviewScreen(),
                                      ));
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
          } else {
            return Center(child: Text('No data available.'));
          }
        },
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