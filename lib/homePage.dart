import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qanuni/clientSignUp.dart';
import 'package:qanuni/presentation/screens/login_screen/view.dart';
import 'package:qanuni/viewListOfLawyers.dart';

class LogoutPage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
                icon: Icon(Icons.exit_to_app, color: Colors.white, size: 30,),
                onPressed: () async {
                  await _auth.signOut();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),// go to sign in page
                    ),
                  ); // Replace '/login' with your login screen route
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
                    TextSpan(
                      text: 'محمد الصالح',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.12,
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.w600,
                        height: 0.06,
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
  
    );
  }
}





// class HomeScreen extends StatefulWidget{
//   const HomeScreen ({super.key});

//   @override 
//   State<HomeScreen> createState() => _HomeScreenState();

// }

// class _HomeScreenState extends State<HomeScreen> {
//   @override 
//   Widget build(BuildContext context) {
// return Scaffold(
// appBar: AppBar(
//   // backgroundColor: Colors.teal ,
//   // title: const Text("FlutterPhone Auth"),
//   // actions: [
//   //   IconButton(
//   //     onPressed: () {},
//   //      icon: Icon (Icons.exit_to_app),
//   //   ),
//   //     ],
//      ),
//       );

//   }
// }

// /*class HomePage extends StatelessWidget{
// const HomePage({Key? key}) : super(key: key ): 

//  @override 
// State<HomePage> createState() => _HomePageState();
// }


//  class _HomePageState extends State<HomePage>{
// final user = FirebaseAuth.instanceFor.currentUser! ;

// @override
//  Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text('signde in as:'+user.email!),
//           MaterialButton(
//             onPressed: (){
//               FirebaseAuth.instance.signOut();
//             } ,
//             color: Colors.green, 
//             child: Text('sign out'),
//           )
//           ],
//           ),

//       ),
//     );

//  }*/
