import 'package:flutter/material.dart';
import 'package:qanuni/homePage.dart';
import 'package:qanuni/presentation/screens/home_screen/view.dart';

import '../viewListOfLawyers.dart';

class viewLawyerProfilePage extends StatelessWidget {
  String riyal = "ريال";
  final Lawyer lawyer; // Pass the lawyer object

//navigation bar method
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
        MaterialPageRoute(builder: (context) => LogoutPage()),
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
    case 3:
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
        (route) => false,
      );
      break;
  }
}



  viewLawyerProfilePage(this.lawyer);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            IconButton(
              padding: EdgeInsets.only(right: 30),
              alignment: Alignment.centerRight,
              icon: Icon(Icons.arrow_forward, color: Colors.teal),
              onPressed: () {
                Navigator.pop(context); // Navigate back to the previous page
              },
            ),
          ],
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment(20, 0),
                colors: [Color(0x21008080), Colors.white.withOpacity(0)],
              ),
            ),
          ),
        ),

        //navigation Bar
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Color(0x7F008080),
          unselectedItemColor: Colors.black,
          showUnselectedLabels: true,
          onTap: (index) => _navigateToScreen(context, index),
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'الصفحةالرئيسية',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.message_outlined),
              label: 'الرسائل',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month_outlined),
              label: 'استشاراتي',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_2_outlined),
              label: 'حسابي',
            ),
          ],
        ),

        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(0, -1),
              end: Alignment(0, 0),
              colors: [Color(0x21008080), Colors.white.withOpacity(0)],
            ),
          ),
          child: SafeArea(
            child: ListView(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipOval(
                        child: Image.network(
                      lawyer.photoURL,
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/default_photo.jpg',
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                        );
                      },
                    )),
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${lawyer.firstName} ${lawyer.lastName}',
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Cairo',
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${riyal}${lawyer.price}',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.699999988079071),
                        fontSize: 14.0,
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.w400,
                        height: 1,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5.0,
                )

                //rating box
                ,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 42,
                      height: 18,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 0,
                            top: 0,
                            child: Container(
                              width: 42,
                              height: 18,
                              decoration: ShapeDecoration(
                                color: Color(0x26FFC126),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6)),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 2.0,
                            top: 0,
                            child: Icon(
                              Icons.star,
                              size: 17.0,
                              color: Colors.amber[400],
                            ),
                          ),
                          Positioned(
                            left: 20.40,
                            top: 2.40,
                            child: Text(
                              '3.8',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 13.02,
                                fontFamily: 'Cairo',
                                fontWeight: FontWeight.w400,
                                height: 1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(
                  height: 15.0,
                )

                //specality box
                ,
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: lawyer.specialties.map((specialty) {
                        return Container(
                          width: lawyer.specialties.length * 30.0,
                          height: 24,
                          margin:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            color: Color(0x7F008080),
                            borderRadius: BorderRadius.circular(11.74),
                          ),
                          child: Text(
                            specialty,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontFamily: 'Cairo',
                              fontWeight: FontWeight.w500,
                              height: 0,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                //end specality box

                SizedBox(
                  height: 15.0,
                ),
                Expanded(
                  child: Container(
                    width: double
                        .infinity, // Set the desired width of the container

                    padding: EdgeInsets.all(
                        20), // Set the padding around the container content

                    decoration: ShapeDecoration(
                      color: Color.fromARGB(255, 255, 255, 255),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      shadows: [
                        BoxShadow(
                          color: Color(0x0C000000),
                          blurRadius: 40,
                          offset: Offset(0, -5),
                          spreadRadius: 0,
                        )
                      ],
                    ),

                    //inside box

                    child: Column(
                      mainAxisSize: MainAxisSize
                          .min, // Limit the vertical size of the column to its content

                      crossAxisAlignment: CrossAxisAlignment.end,

                      children: [
                        Text(
                          'السيرة الذاتية',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        //Bio

                        Padding(
                            padding: EdgeInsets.only(right: 20),
                            child: Text(
                              '${lawyer.bio}',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                              ),
                            )),

                        Divider(
                          thickness: 0.5,
                        ), // Add a vertical spacing between the text and buttons

                        Text(
                          'المراجعات',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        Card(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: Color(0xFF008080),
                              width: 0.5,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          margin: EdgeInsets.all(8.0),
                          child: ListTile(
                            trailing: CircleAvatar(
                              backgroundImage:
                                  AssetImage('assets/default_photo.jpg'),
                            ),
                            title: Text(
                              'مح*****',
                              textAlign: TextAlign.right,
                              style:
                                  TextStyle(fontFamily: 'Cairo', fontSize: 12),
                            ),
                            subtitle: Column(
                              children: [
                                //RatingBar(rating: 4.5),
                                SizedBox(height: 5.0),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Great product! I am very satisfied with my purchase.',
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                        fontSize: 14.0, fontFamily: 'Cairo'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(
                            height:
                                8), // Add a vertical spacing between buttons

                        //Book button

                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  // Button action
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(
                                      0xFF008080), // Set the background color of the button
                                  padding: EdgeInsets.all(8.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                child: Text(
                                  'حجز موعد استشارة',
                                  style: TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
