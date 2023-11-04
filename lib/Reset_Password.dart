import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class resetPassword extends StatefulWidget {
  const resetPassword({super.key});

  @override
  State<resetPassword> createState() => _resetPasswordState();
}

class _resetPasswordState extends State<resetPassword> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future passwordReset() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());
      showDialog(
        context: this.context,
        builder: (context) {
          return AlertDialog(
            content: Text("تم ارسال رابط تغيير كلمة المرور"),
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      print(e);
      String formatMsg = "البريد الالكتروني الذي أدخلته غير صحيح";
      String existMsg = "البريد الكتروني الذي ادخلته غير مسجّل ";
      String emptyfield = "يرجى ادخال البريد الالكتروني";
      if (e.message.toString() == "The email address is badly formatted.") {
        showDialog(
          context: context,
          builder: (context) {
            return Center(
              child: SizedBox(
                width: 350, // Adjust the width as needed
                child: AlertDialog(
                  content: Text(formatMsg),
                ),
              ),
            );
          },
        );
      } else if (e.message.toString() ==
          "Unable to establish connection on channel.") {
        showDialog(
          context: context,
          builder: (context) {
            return Center(
              child: SizedBox(
                width: 300, // Adjust the width as needed
                child: AlertDialog(
                  content: Text(emptyfield),
                ),
              ),
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return Center(
              child: SizedBox(
                width: 350, // Adjust the width as needed
                child: AlertDialog(
                  content: Text(existMsg),
                ),
              ),
            );
          },
        );
      }
      //
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('إعادة ضبط كلمة المرور'),
          centerTitle: true,
        ),
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Text(
                  ' ادخل بريدك الالكتروني لارسال رابط تغيير كلمة المرور',
                  style: TextStyle(fontSize: 15),
                ),
              ),

              SizedBox(height: 15),

              // Email textfield
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'البريد الالكتروني',
                    alignLabelWithHint: true,
                    labelStyle: TextStyle(
                      color: Colors.black,
                    ),
                    isDense: true,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.teal),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintText: 'البريد الالكتروني',
                    fillColor: Colors.grey[200],
                    filled: true,
                  ),
                ),
              ),

              SizedBox(height: 30),

              MaterialButton(
                onPressed: (passwordReset),
                child: Text(
                  'اعادة ضبط كلمة المرور',
                  style: TextStyle(
                      fontSize: 18, fontFamily: 'poppins', color: Colors.white),
                ),
                color: Colors.teal,
                shape: RoundedRectangleBorder(
                    //to set border radius to button
                    borderRadius: BorderRadius.circular(12)),
                height: 50,
                minWidth: 325,
              ),
            ],
          ),
        ));
  }
}
