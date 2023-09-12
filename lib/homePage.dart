/*import 'package:flutter/material.dart';



class homePage extends StatelessWidget{
  get signUserOut => null;


  //Sign user out method
  void SignUserOut() {
  //FirebaseAuth auth = FirebaseAuth.instance;
 FirebaseAuth.instance.signOut();
  }

  void logout() {
  // Add code here to perform logout actions
}

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
        IconButton(
          onPressed: signUserOut,
           icon: Icon(Icons.logout),
           )
      ],
      ),
      body: Center(child: Text("LOGGED IN!")),
    );
  }
}*/

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatelessWidget {
  // Sign user out method
  void signUserOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      // You can add any additional logout actions here
    } catch (e) {
      print("Error signing out: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: signUserOut,
            icon: Icon(Icons.logout),
          )
        ],
      ),
      body: Center(child: Text("LOGGED IN!")),
    );
  }
}



