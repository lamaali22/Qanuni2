import 'package:flutter/material.dart';
import 'package:qanuni/consultationLawyer.dart';
import 'package:qanuni/homePageLawyer.dart';
import 'package:qanuni/lawyerEvaluations.dart';

class ViewProfileLawyer extends StatefulWidget {
  @override
  _ViewProfileLawyerState createState() => _ViewProfileLawyerState();
}

class _ViewProfileLawyerState extends State<ViewProfileLawyer> {
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
          "حسابي",
          style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        actions: [],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return LawyerEvaluations();
                }));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Color(0xFF008080), // Set the background color of the button
                padding: EdgeInsets.all(8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Text(
                'تقييمات المستفيدين',
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.0,
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.w800,
                  height: 2,
                ),
              ),
            ),
          ],
        ),
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

void main() {
  runApp(MaterialApp(
    home: ViewProfileLawyer(),
  ));
}
