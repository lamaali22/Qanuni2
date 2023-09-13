import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget{
  const HomeScreen ({super.key});

  @override 
  State<HomeScreen> createState() => _HomeScreenState();

}

class _HomeScreenState extends State<HomeScreen> {
  @override 
  Widget build(BuildContext context) {
final ap = Provider.of<AuthProvider>(context, listen: false);

return Scaffold(
appBar: AppBar(
  backgroundColor: Colors.teal ,
  title: const Text("FlutterPhone Auth"),
  actions: [
    IconButton(
      onPressed: () {},
       icon: Icon (Icons.exit_to_app),
    ),
      ],
     ),
      );

  }
}

mixin AuthProvider {
}


/*class HomePage extends StatelessWidget{
const HomePage({Key? key}) : super(key: key ): 

 @override 
State<HomePage> createState() => _HomePageState();
}


 class _HomePageState extends State<HomePage>{
final user = FirebaseAuth.instanceFor.currentUser! ;

@override
 Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('signde in as:'+user.email!),
          MaterialButton(
            onPressed: (){
              FirebaseAuth.instance.signOut();
            } ,
            color: Colors.green, 
            child: Text('sign out'),
          )
          ],
          ),

      ),
    );

 }*/
