import 'package:flutter/material.dart';
//import the lawyer model
import 'models/lawyer.dart';

class viewLawyerProfilePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    home: Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column( 
          children: [
            CircleAvatar(
              radius: 50.0,
              backgroundColor:Colors.amber  ,
              ),
              Text('محمد العيد',
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'Cairo',
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
              ),
              Text('٥٠ استشارة',
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: Colors.black.withOpacity(0.699999988079071),
                  fontSize: 14.0,
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.w400,
                  height: 1,
                ),
              )
              ,
              SizedBox(height: 5.0,)
               //rating box
              ,Container( 
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
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                          ),
                        ),
                      ),
                      Positioned(
                        left:2.0,
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
                          '4.8',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 13.02,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                            height: 1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              SizedBox(height: 15.0,)
                //specality box
                ,Container(
                  width: 88.36,
                  height: 24,
                  padding: const EdgeInsets.only(
                    top: 2,
                    left: 10.68,
                    right: 9.68,
                    bottom: 8,
                  ),
                  decoration: ShapeDecoration(
                    color: Color(0x7F008080),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(11.74),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'قانون تجاري ',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.41,
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.w500,
                          height: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              
              SizedBox(height: 15.0,)
              
              ,Expanded(
                 child: Container(
                  width:double.infinity , // Set the desired width of the container
                  padding: EdgeInsets.all(20), // Set the padding around the container content
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
                      mainAxisSize: MainAxisSize.min, // Limit the vertical size of the column to its content
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
                          child:Text(
                          'مرحبا مرحا ' 'مرجبت ا ' 'السلام عليكم ',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          ),
                         )
                        ),
                        
                        Divider(thickness: 0.5,), // Add a vertical spacing between the text and buttons

                        Text(
                          'المراجعات',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        
                        Card(
                          margin: EdgeInsets.all(8.0),
                          child: ListTile(
                            trailing: CircleAvatar(
                              backgroundImage: AssetImage('images/user-avatar.png'),
                            ),
                            title: 
                            Text('مح*****',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 12 ),
                            ),
                            subtitle: Column(
                              children: [
                                //RatingBar(rating: 4.5),
                                SizedBox(height: 5.0),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child:  Text( 'Great product! I am very satisfied with my purchase.',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontSize: 14.0
                                    ,fontFamily: 'Cairo'
                                    ),
                                ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 8), // Add a vertical spacing between buttons
                        
                        //Book button 
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  // Button action
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF008080), // Set the background color of the button
                                  padding: EdgeInsets.all(8.0)
                                  // Other style properties (e.g., textStyle, padding, shape, etc.)
                                ),
                                child: Text('حجز موعد استشارة',
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
                )
              
          ],
        ),
      ),
  ),
  );
  }
}
