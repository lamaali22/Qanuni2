/*import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qanuni/Notifications.dart';
import 'package:qanuni/consultationFromClient.dart';
import 'package:qanuni/editProfileClient.dart';
import 'package:qanuni/homePage.dart';
import 'package:qanuni/presentation/screens/login_screen/view.dart';

class ClientProfile extends StatefulWidget {
  @override
  _ClientProfileState createState() => _ClientProfileState();
}

class _ClientProfileState extends State<ClientProfile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User? _user;
  String? email = "";
  Future<void> getEmailAndUpdateToken() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      email = user.email!;
      print('User email: $email');
      Token().updateTokenInDB(email, true, "Clients");
    }
  }

  void _navigateToScreen(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => ClientProfile()),
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

  List<Map<String, dynamic>> itemList = [
    {"text": "الملف الشخصي", "icon": Icons.person_outline},
    {"text": "تسجيل الخروج", "icon": Icons.logout},
    {"text": "حذف الحساب", "icon": Icons.delete},
  ];

  // Function to handle "الملف الشخصي"
  void handleMyProfile(BuildContext context) {
    print("Opening My Profile");
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AccountInfoScreen(),
      ),
    );
    // Add your logic for handling "الملف الشخصي"
  }

  // Function to handle "تسجيل الخروج"
  Future<void> handleLogOut() async {
    print("Logging Out");
    Token().updateTokenInDB(email, false, "Clients");
    await _auth.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginScreen(),
      ),
    );
    // Add your logic for handling "تسجيل الخروج"
  }

  // Function to handle "حذف الحساب"
  void handleDeleteAccount() {
    print("Deleting Account");
    // Add your logic for handling "حذف الحساب"
  }

  void handleItemSelected(Map<String, dynamic> selectedItem) {
    String text = selectedItem["text"];
    IconData icon = selectedItem["icon"];

    switch (text) {
      case "الملف الشخصي":
        handleMyProfile(context);
        break;
      case "تسجيل الخروج":
        handleLogOut();
        break;
      case "حذف الحساب":
        handleDeleteAccount();
        break;
      default:
        print("Invalid selection");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(255, 0, 128, 128),
        title: const Text(
          " حسابي",
          style: TextStyle(
              fontFamily: 'Cairo',
              fontWeight: FontWeight.w500,
              color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: itemList.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              ListTile(
                leading: itemList[index]["text"] == "الملف الشخصي"
                    ? Icon(Icons.arrow_back_ios_new_rounded, color: Colors.teal)
                    : null,
                title: Text(
                  itemList[index]["text"],
                  style: TextStyle(
                    color: itemList[index]["text"] == "حذف الحساب"
                        ? Colors.red
                        : Colors.teal,
                    fontFamily: 'Cairo',
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                  ),
                  textAlign: TextAlign.right,
                ),
                trailing: Icon(
                  itemList[index]["icon"],
                  color: itemList[index]["text"] == "حذف الحساب"
                      ? Colors.red
                      : Colors.teal,
                  size: 30,
                ),
                onTap: () {
                  handleItemSelected(itemList[index]);
                },
              ),
              Divider(
                color: itemList[index]["text"] == "حذف الحساب"
                    ? Colors.red
                    : Colors.teal,
              ),
            ],
          );
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
            label: ' حسابي',
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
    home: ClientProfile(),
  ));
}
*/
/* مو مره ضابط 
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qanuni/Notifications.dart';
import 'package:qanuni/consultationFromClient.dart';
import 'package:qanuni/editProfileClient.dart';
import 'package:qanuni/homePage.dart';
import 'package:qanuni/presentation/screens/login_screen/view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ClientProfile extends StatefulWidget {
  @override
  _ClientProfileState createState() => _ClientProfileState();
}

class _ClientProfileState extends State<ClientProfile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User? _user;
  String? email = "";
  Future<void> getEmailAndUpdateToken() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      email = user.email!;
      print('User email: $email');
      Token().updateTokenInDB(email, true, "Clients");
    }
  }

  void _navigateToScreen(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => ClientProfile()),
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

Future<void> performDeleteAccount(BuildContext context) async {
  try {
    // Fetch the current user
    User? currentUser = _auth.currentUser;

    if (currentUser != null) {

        // Get the user's email
      String userEmail = currentUser.email ?? "";

       // Update token in the database (if needed)
      Token().updateTokenInDB(userEmail, false, "Clients");

 

 // Delete user data in your database (Firestore)
      await FirebaseFirestore.instance.collection('Clients').doc(userEmail).delete();

      // Delete user account in Firebase Authentication
      await currentUser.delete();


// Sign out the user after deleting the account
    await _auth.signOut();

    // After deleting the account, navigate to the login screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginScreen(),
      ),
    );
  } else {
      print("No user found. Unable to delete account.");
    }
    }
    catch (e) {
    print("Error deleting account: $e");
    // Handle errors as needed
  }
}

  void handleDeleteAccount() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("تأكيد حذف الحساب",
            style: TextStyle(
              color: const Color.fromARGB(255, 14, 16, 16),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),),
        content: Text("هل أنت متأكد أنك تريد حذف حسابك؟",
            style: TextStyle(
              color: const Color.fromARGB(255, 14, 16, 16),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
            },
            child: Text("إلغاء"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // Close the dialog
              await performDeleteAccount(context);
            },
            child: Text("حذف"),
          ),
        ],
      );
    },
  );
}
  

  List<Map<String, dynamic>> itemList = [
    {"text": "الملف الشخصي", "icon": Icons.person_outline},
    {"text": "تسجيل الخروج", "icon": Icons.logout},
    {"text": "حذف الحساب", "icon": Icons.delete},
  ];

  // Function to handle "الملف الشخصي"
  void handleMyProfile(BuildContext context) {
    print("Opening My Profile");
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AccountInfoScreen(),
      ),
    );
    // Add your logic for handling "الملف الشخصي"
  }

  // Function to handle "تسجيل الخروج"
  Future<void> handleLogOut() async {
    print("Logging Out");
    Token().updateTokenInDB(email, false, "Clients");


  // Show confirmation dialog
  bool confirmLogout = await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("تأكيد تسجيل الخروج",
          style: TextStyle(
            color: const Color.fromARGB(255, 14, 16, 16),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text("هل أنت متأكد أنك تريد تسجيل الخروج؟",
          style: TextStyle(
            color: const Color.fromARGB(255, 14, 16, 16),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, false); // Close the dialog and pass false
            },
            child: Text("إلغاء"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, true); // Close the dialog and pass true
            },
            child: Text("تسجيل الخروج"),
          ),
        ],
      );
    },
  );

// If the user confirms the logout, proceed with the logout logic
  if (confirmLogout == true) {
    await _auth.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginScreen(),
      ),
    );
  }
    // Add your logic for handling "تسجيل الخروج"
  }

  

  void handleItemSelected(Map<String, dynamic> selectedItem) {
    String text = selectedItem["text"];
    IconData icon = selectedItem["icon"];

    switch (text) {
      case "الملف الشخصي":
        handleMyProfile(context);
        break;
      case "تسجيل الخروج":
        handleLogOut();
        break;
      case "حذف الحساب":
        handleDeleteAccount();
        break;
      default:
        print("Invalid selection");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(255, 0, 128, 128),
        title: const Text(
          " حسابي",
          style: TextStyle(
              fontFamily: 'Cairo',
              fontWeight: FontWeight.w500,
              color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: itemList.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              ListTile(
                leading: itemList[index]["text"] == "الملف الشخصي"
                    ? Icon(Icons.arrow_back_ios_new_rounded, color: Colors.teal)
                    : null,
                title: Text(
                  itemList[index]["text"],
                  style: TextStyle(
                    color: itemList[index]["text"] == "حذف الحساب"
                        ? Colors.red
                        : Colors.teal,
                    fontFamily: 'Cairo',
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                  ),
                  textAlign: TextAlign.right,
                ),
                trailing: Icon(
                  itemList[index]["icon"],
                  color: itemList[index]["text"] == "حذف الحساب"
                      ? Colors.red
                      : Colors.teal,
                  size: 30,
                ),
                onTap: () {
                  handleItemSelected(itemList[index]);
                },
              ),
              Divider(
                color: itemList[index]["text"] == "حذف الحساب"
                    ? Colors.red
                    : Colors.teal,
              ),
            ],
          );
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
            label: ' حسابي',
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
    home: ClientProfile(),
  ));
}
*/


/*8888888888888888888888888888888888888888888888888888888888888888888888888888888888888
مو ضابط مره
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qanuni/Notifications.dart';
import 'package:qanuni/consultationFromClient.dart';
import 'package:qanuni/editProfileClient.dart';
import 'package:qanuni/homePage.dart';
import 'package:qanuni/presentation/screens/login_screen/view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ClientProfile extends StatefulWidget {
  @override
  _ClientProfileState createState() => _ClientProfileState();
}

class _ClientProfileState extends State<ClientProfile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User? _user;
  String? email = "";
  Future<void> getEmailAndUpdateToken() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      email = user.email!;
      print('User email: $email');
      Token().updateTokenInDB(email, true, "Clients");
    }
  }

  void _navigateToScreen(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => ClientProfile()),
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

  List<Map<String, dynamic>> itemList = [
    {"text": "الملف الشخصي", "icon": Icons.person_outline},
    {"text": "تسجيل الخروج", "icon": Icons.logout},
    {"text": "حذف الحساب", "icon": Icons.delete},
  ];

  // Function to handle "الملف الشخصي"
  void handleMyProfile(BuildContext context) {
    print("Opening My Profile");
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AccountInfoScreen(),
      ),
    );
    // Add your logic for handling "الملف الشخصي"
  }

  // Function to handle "تسجيل الخروج"
  Future<void> handleLogOut() async {
    print("Logging Out");
    Token().updateTokenInDB(email, false, "Clients");


  // Show confirmation dialog
  bool confirmLogout = await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("تأكيد تسجيل الخروج",
          style: TextStyle(
            color: const Color.fromARGB(255, 14, 16, 16),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ), textAlign: TextAlign.right,
        ),
        content: Text("هل أنت متأكد أنك تريد تسجيل الخروج؟",
          style: TextStyle(
            color: const Color.fromARGB(255, 14, 16, 16),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ), textAlign: TextAlign.right,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, false); // Close the dialog and pass false
            },
            child: Text("إلغاء"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, true); // Close the dialog and pass true
            },
            child: Text("تسجيل الخروج"),
          ),
        ],
      );
    },
  );

// If the user confirms the logout, proceed with the logout logic
  if (confirmLogout == true) {
    await _auth.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginScreen(),
      ),
    );
  }
    // Add your logic for handling "تسجيل الخروج"
  }


  Future<void> deleteUserData(String userEmail) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference users = firestore.collection('Clients');

  // Query for the user based on their email
  QuerySnapshot querySnapshot =
      await users.where('email', isEqualTo: userEmail).get();

  // Delete each document found
  for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
    await documentSnapshot.reference.delete();
  }
}

  // Function to handle "حذف الحساب"
  void handleDeleteAccount() async{
    print("Deleting Account");
   showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("تأكيد الحذف",
          style: TextStyle(
            color: const Color.fromARGB(255, 14, 16, 16),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ), textAlign: TextAlign.right,),
        content: Text("هل أنت متأكد أنك تريد حذف الحساب؟",
          style: TextStyle(
            color: const Color.fromARGB(255, 14, 16, 16),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ), textAlign: TextAlign.right,),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text("إلغاء"),
          ),
          TextButton(
            onPressed: () async {
              // Close the dialog
              Navigator.of(context).pop();
              try {
              // Delete user data in the database
                     await deleteUserData(email!);
            if (mounted) {
                 // Delete the user account
                await _auth.currentUser?.delete();

            // Update token in the database
        Token().updateTokenInDB(email, false, "Clients");
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ),
                );
              } 
              }
              catch (e) {
                print("Error deleting account: $e");
                // Handle the error (e.g., display an error message to the user)
              }
            },
            child: Text("تأكيد"),
          ),
        ],
      );
    },
  );
}

  void handleItemSelected(Map<String, dynamic> selectedItem) {
    String text = selectedItem["text"];
    IconData icon = selectedItem["icon"];

    switch (text) {
      case "الملف الشخصي":
        handleMyProfile(context);
        break;
      case "تسجيل الخروج":
        handleLogOut();
        break;
      case "حذف الحساب":
        handleDeleteAccount();
        break;
      default:
        print("Invalid selection");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(255, 0, 128, 128),
        title: const Text(
          " حسابي",
          style: TextStyle(
              fontFamily: 'Cairo',
              fontWeight: FontWeight.w500,
              color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: itemList.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              ListTile(
                leading: itemList[index]["text"] == "الملف الشخصي"
                    ? Icon(Icons.arrow_back_ios_new_rounded, color: Colors.teal)
                    : null,
                title: Text(
                  itemList[index]["text"],
                  style: TextStyle(
                    color: itemList[index]["text"] == "حذف الحساب"
                        ? Colors.red
                        : Colors.teal,
                    fontFamily: 'Cairo',
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                  ),
                  textAlign: TextAlign.right,
                ),
                trailing: Icon(
                  itemList[index]["icon"],
                  color: itemList[index]["text"] == "حذف الحساب"
                      ? Colors.red
                      : Colors.teal,
                  size: 30,
                ),
                onTap: () {
                  handleItemSelected(itemList[index]);
                },
              ),
              Divider(
                color: itemList[index]["text"] == "حذف الحساب"
                    ? Colors.red
                    : Colors.teal,
              ),
            ],
          );
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
            label: ' حسابي',
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
    home: ClientProfile(),
  ));
}
*/

/*import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qanuni/Notifications.dart';
import 'package:qanuni/consultationFromClient.dart';
import 'package:qanuni/editProfileClient.dart';
import 'package:qanuni/homePage.dart';
import 'package:qanuni/presentation/screens/login_screen/view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ClientProfile extends StatefulWidget {
  @override
  _ClientProfileState createState() => _ClientProfileState();
}

class _ClientProfileState extends State<ClientProfile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User? _user;
  String? email = "";
  Future<void> getEmailAndUpdateToken() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      email = user.email!;
      print('User email: $email');
      Token().updateTokenInDB(email, true, "Clients");
    }
  }



  void _navigateToScreen(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => ClientProfile()),
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

  List<Map<String, dynamic>> itemList = [
    {"text": "الملف الشخصي", "icon": Icons.person_outline},
    {"text": "تسجيل الخروج", "icon": Icons.logout},
    {"text": "حذف الحساب", "icon": Icons.delete},
  ];

  // Function to handle "الملف الشخصي"
  void handleMyProfile(BuildContext context) {
    print("Opening My Profile");
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AccountInfoScreen(),
      ),
    );
    // Add your logic for handling "الملف الشخصي"
  }

 // Function to handle "تسجيل الخروج"
  Future<void> handleLogOut() async {
    print("Logging Out");
    Token().updateTokenInDB(email, false, "Clients");


  // Show confirmation dialog
  bool confirmLogout = await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("تأكيد تسجيل الخروج",
          style: TextStyle(
            color: const Color.fromARGB(255, 14, 16, 16),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ), textAlign: TextAlign.right,
        ),
        content: Text("هل أنت متأكد أنك تريد تسجيل الخروج؟",
          style: TextStyle(
            color: const Color.fromARGB(255, 14, 16, 16),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ), textAlign: TextAlign.right,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, false); // Close the dialog and pass false
            },
            child: Text("إلغاء"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, true); // Close the dialog and pass true
            },
            child: Text("تسجيل الخروج"),
          ),
        ],
      );
    },
  );

// If the user confirms the logout, proceed with the logout logic
  if (confirmLogout == true) {
    await _auth.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginScreen(),
      ),
    );
  }
    // Add your logic for handling "تسجيل الخروج"
  }

/*// Function to handle "حذف الحساب"
  void handleDeleteAccount() async{
    print("Deleting Account");
    try {
    await _auth.currentUser?.delete();
    Token().updateTokenInDB(email, false, "Clients");
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginScreen(),
      ),
    );
  } catch (e) {
    print("Error deleting account: $e");
    // Handle the error (e.g., display an error message to the user)
  }
}

  */



  // Function to handle "حذف الحساب"
  
  
  
  
  /*void handleDeleteAccount() async {
    print("Deleting Account");
    try {
      // Delete the user from Firebase Authentication
      await _auth.currentUser?.delete();

      // Delete user-related data from Firestore
      await deleteUserData(email!);

      // Update token in the database
      Token().updateTokenInDB(email, false, "Clients");

      // Navigate to the login screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ),
      );
    } catch (e) {
      print("Error deleting account: $e");
      // Handle the error (e.g., display an error message to the user)
    }
  }

  // Function to delete user-related data from Firestore
  Future<void> deleteUserData(String userEmail) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference users = firestore.collection('Clients');

    try {
      // Query for the user based on their email
      QuerySnapshot querySnapshot =
          await users.where('email', isEqualTo: userEmail).get();

      // Delete each document found
      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        await documentSnapshot.reference.delete();
      }
    } catch (e) {
      print("Error deleting user data: $e");
      // Handle the error (e.g., display an error message to the user)
    }
  }

*/

 void handleDeleteAccount() async{
   print("Deleting Account");
bool confirmLogout = await showDialog(
  context: context,
  builder: (BuildContext context) {
    return AlertDialog(
      title: const Text('Delete your Account?'),
      content: const Text(
'''If you select Delete we will delete your account on our server.

Your app data will also be deleted and you won't be able to retrieve it.

Since this is a security-sensitive operation, you eventually are asked to login before your account can be deleted.'''),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
        TextButton(
          child: const Text(
            'Delete',
              style: TextStyle( color: Colors.red,), ),
          onPressed: () async{
            // Call the delete account function
             await deleteAccount();
                Navigator.of(context).pop(true);

          },
        ),
      ],
    );
  },
);


 }

Future<void> deleteAccount() async {
    try {
      // Delete the user from Firebase Authentication
      await _auth.currentUser?.delete();

      // Delete user-related data from Firestore
      await deleteUserData(email!);

      // Update token in the database
      Token().updateTokenInDB(email, false, "Clients");

      // Navigate to the login screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ),
      );
    } catch (e) {
      print("Error deleting account: $e");
      // Handle the error (e.g., display an error message to the user)
    }
  }


  Future<void> deleteUserData(String userEmail) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference users = firestore.collection('Clients');

    try {
      // Query for the user based on their email
      QuerySnapshot querySnapshot =
          await users.where('email', isEqualTo: userEmail).get();

      // Delete each document found
      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        await documentSnapshot.reference.delete();
      }
    } catch (e) {
      print("Error deleting user data: $e");
      // Handle the error (e.g., display an error message to the user)
    }
  }




  void handleItemSelected(Map<String, dynamic> selectedItem) {
    String text = selectedItem["text"];
    IconData icon = selectedItem["icon"];

    switch (text) {
      case "الملف الشخصي":
        handleMyProfile(context);
        break;
      case "تسجيل الخروج":
        handleLogOut();
        break;
      case "حذف الحساب":
        handleDeleteAccount();
        break;
      default:
        print("Invalid selection");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(255, 0, 128, 128),
        title: const Text(
          " حسابي",
          style: TextStyle(
              fontFamily: 'Cairo',
              fontWeight: FontWeight.w500,
              color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: itemList.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              ListTile(
                leading: itemList[index]["text"] == "الملف الشخصي"
                    ? Icon(Icons.arrow_back_ios_new_rounded, color: Colors.teal)
                    : null,
                title: Text(
                  itemList[index]["text"],
                  style: TextStyle(
                    color: itemList[index]["text"] == "حذف الحساب"
                        ? Colors.red
                        : Colors.teal,
                    fontFamily: 'Cairo',
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                  ),
                  textAlign: TextAlign.right,
                ),
                trailing: Icon(
                  itemList[index]["icon"],
                  color: itemList[index]["text"] == "حذف الحساب"
                      ? Colors.red
                      : Colors.teal,
                  size: 30,
                ),
                onTap: () {
                  handleItemSelected(itemList[index]);
                },
              ),
              Divider(
                color: itemList[index]["text"] == "حذف الحساب"
                    ? Colors.red
                    : Colors.teal,
              ),
            ],
          );
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
            label: ' حسابي',
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
    home: ClientProfile(),
  ));
}


*/

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qanuni/Notifications.dart';
import 'package:qanuni/consultationFromClient.dart';
import 'package:qanuni/editProfileClient.dart';
import 'package:qanuni/homePage.dart';
import 'package:qanuni/presentation/screens/login_screen/view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ClientProfile extends StatefulWidget {
  @override
  _ClientProfileState createState() => _ClientProfileState();
}

class _ClientProfileState extends State<ClientProfile> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User? _user;
  String? email = "";
  Future<void> getEmailAndUpdateToken() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      email = user.email!;
      print('User email: $email');
      Token().updateTokenInDB(email, true, "Clients");
    }
  }

  void _navigateToScreen(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => ClientProfile()),
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

  List<Map<String, dynamic>> itemList = [
    {"text": "الملف الشخصي", "icon": Icons.person_outline},
    {"text": "تسجيل الخروج", "icon": Icons.logout},
    {"text": "حذف الحساب", "icon": Icons.delete},
  ];

  // Function to handle "الملف الشخصي"
  void handleMyProfile(BuildContext context) {
    print("Opening My Profile");
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AccountInfoScreen(),
      ),
    );
    // Add your logic for handling "الملف الشخصي"
  }

 // Function to handle "تسجيل الخروج"
  Future<void> handleLogOut() async {
    print("Logging Out");
    Token().updateTokenInDB(email, false, "Clients");


  // Show confirmation dialog
  bool confirmLogout = await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("تأكيد تسجيل الخروج",
          style: TextStyle(
            color: const Color.fromARGB(255, 14, 16, 16),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ), textAlign: TextAlign.right,
        ),
        content: Text("هل أنت متأكد أنك تريد تسجيل الخروج؟",
          style: TextStyle(
            color: const Color.fromARGB(255, 14, 16, 16),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ), textAlign: TextAlign.right,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, false); // Close the dialog and pass false
            },
            child: Text("إلغاء"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, true); // Close the dialog and pass true
            },
            child: Text("تسجيل الخروج"),
          ),
        ],
      );
    },
  );

// If the user confirms the logout, proceed with the logout logic
  if (confirmLogout == true) {
    await _auth.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginScreen(),
      ),
    );
  }
  }


  // Function to handle "حذف الحساب"

  void handleDeleteAccount()async {
    print("Deleting Account");

      await showDeleteConfirmationDialog(context);

    try {
      User? user = _auth.currentUser;

      if (user != null) {
        String userEmail = user.email ?? "";

        // Delete user documents in 'Clients' collection
        await _db
            .collection('Clients')
            .where('email', isEqualTo: userEmail)
            .get()
            .then((querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            doc.reference.delete();
          });
        });


 await _db    
            .collection('bookings')
            .where('clientEmail', isEqualTo: userEmail)
            .get()
            .then((querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            doc.reference.delete();
          });
        });


 await _db
            .collection('reporters')
            .where('clientEmail', isEqualTo: userEmail)
            .get()
            .then((querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            doc.reference.delete();
          });
        });

await _db
            .collection('reviews')
            .where('clientEmail', isEqualTo: userEmail)
            .get()
            .then((querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            doc.reference.delete();
          });
        });
     

        // Add similar code for other collections as needed

        // Finally, delete the user from authentication
        await user.delete();

        Token().updateTokenInDB(userEmail, false, "Clients");

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ),
        );
      }
    } catch (e) {
      print("Error deleting account and associated documents: $e");
    }
  }

Future<void> showDeleteConfirmationDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('تأكيد الحذف',
          style: TextStyle(
            color: const Color.fromARGB(255, 14, 16, 16),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ), textAlign: TextAlign.right,),


        content: Text('هل أنت متأكد أنك تريد حذف حسابك؟',
          style: TextStyle(
            color: const Color.fromARGB(255, 14, 16, 16),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ), textAlign: TextAlign.right,),

          
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              // Call your delete account function here
              handleDeleteAccount();
              Navigator.of(context).pop();
            },
            child: Text('حذف'),
          ),
        ],
      );
    },
  );
}


  void handleItemSelected(Map<String, dynamic> selectedItem) {
    String text = selectedItem["text"];
    IconData icon = selectedItem["icon"];

    switch (text) {
      case "الملف الشخصي":
        handleMyProfile(context);
        break;
      case "تسجيل الخروج":
        handleLogOut();
        break;
      case "حذف الحساب":
        handleDeleteAccount();
        break;
      default:
        print("Invalid selection");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(255, 0, 128, 128),
        title: const Text(
          " حسابي",
          style: TextStyle(
              fontFamily: 'Cairo',
              fontWeight: FontWeight.w500,
              color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: itemList.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              ListTile(
                leading: itemList[index]["text"] == "الملف الشخصي"
                    ? Icon(Icons.arrow_back_ios_new_rounded, color: Colors.teal)
                    : null,
                title: Text(
                  itemList[index]["text"],
                  style: TextStyle(
                    color: itemList[index]["text"] == "حذف الحساب"
                        ? Colors.red
                        : Colors.teal,
                    fontFamily: 'Cairo',
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                  ),
                  textAlign: TextAlign.right,
                ),
                trailing: Icon(
                  itemList[index]["icon"],
                  color: itemList[index]["text"] == "حذف الحساب"
                      ? Colors.red
                      : Colors.teal,
                  size: 30,
                ),
                onTap: () {
                  handleItemSelected(itemList[index]);
                },
              ),
              Divider(
                color: itemList[index]["text"] == "حذف الحساب"
                    ? Colors.red
                    : Colors.teal,
              ),
            ],
          );
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
            label: ' حسابي',
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
    home: ClientProfile(),
  ));
}