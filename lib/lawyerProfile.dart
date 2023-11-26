import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qanuni/MyprofileLawyer.dart';
import 'package:qanuni/Notifications.dart';
import 'package:qanuni/consultationLawyer.dart';
import 'package:qanuni/homePageLawyer.dart';
import 'package:qanuni/lawyerEvaluations.dart';
import 'package:qanuni/presentation/screens/login_screen/view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewProfileLawyer extends StatefulWidget {
  @override
  _ViewProfileLawyerState createState() => _ViewProfileLawyerState();
}

class _ViewProfileLawyerState extends State<ViewProfileLawyer> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User? _user;
  String? email = "";
  Future<void> getEmailAndUpdateToken() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      email = user.email!;

      print('User email: $email');
      Token().updateTokenInDB(email, true, "lawyers");
    }
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

  List<Map<String, dynamic>> itemList = [
    {"text": "الملف الشخصي", "icon": Icons.person_outline},
    {"text": "تقييمات المستفيدين", "icon": Icons.star_border_outlined},
    {"text": "تسجيل الخروج", "icon": Icons.logout},
    {"text": "حذف الحساب", "icon": Icons.delete},
  ];

  // Function to handle "الملف الشخصي"
  void handleMyProfile() {
    print("Opening My Profile");
    // Add your logic for handling "الملف الشخصي"
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MyProfile_Lawyer(),
      ),
    );
  }

  // Function to handle "تسجيل الخروج"
  Future<void> handleLogOut() async {
    print("Logging Out");

    Token().updateTokenInDB(email, false, "lawyers");


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
          ),textAlign: TextAlign.right,
        ),
        content: Text("هل أنت متأكد أنك تريد تسجيل الخروج؟",
          style: TextStyle(
            color: const Color.fromARGB(255, 14, 16, 16),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),textAlign: TextAlign.right,
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
            .collection('lawyers')
            .where('email', isEqualTo: userEmail)
            .get()
            .then((querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            doc.reference.delete();
          });
        });


 await _db    
            .collection('bookings')
            .where('lawyerEmail', isEqualTo: userEmail)
            .get()
            .then((querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            doc.reference.delete();
          });
        });


 await _db
            .collection('reporters')
            .where('lawyerEmail', isEqualTo: userEmail)
            .get()
            .then((querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            doc.reference.delete();
          });
        });

await _db
            .collection('reviews')
            .where('lawyerEmail', isEqualTo: userEmail)
            .get()
            .then((querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            doc.reference.delete();
          });
        });
     
     await _db
            .collection('timeSlots')
            .where('lawyerEmail', isEqualTo: userEmail)
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




  void handleClientsEvaluations(BuildContext context) {
    print("client evaluations");
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LawyerEvaluations(),
      ),
    );
  }

  void handleItemSelected(Map<String, dynamic> selectedItem) {
    String text = selectedItem["text"];
    IconData icon = selectedItem["icon"];

    switch (text) {
      case "الملف الشخصي":
        handleMyProfile();
        break;
      case "تقييمات المستفيدين":
        handleClientsEvaluations(context);
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
                    : (itemList[index]["text"] == "تقييمات المستفيدين"
                        ? Icon(Icons.arrow_back_ios_new_rounded,
                            color: Colors.teal)
                        : null),
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
    home: ViewProfileLawyer(),
  ));
}
