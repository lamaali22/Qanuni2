import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:qanuni/presentation/screens/login_screen/view.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> passwordReset(BuildContext context) async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());
      showToast(
        "تم ارسال رابط تغيير كلمة المرور",
        duration: Duration(seconds: 3),
        position: ToastPosition.bottom,
        backgroundColor: Colors.black,
        radius: 8.0,
        textStyle: TextStyle(color: Colors.white),
      );

      // Navigate back to the LoginScreen
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      print(e);
      String formatMsg = "البريد الالكتروني الذي أدخلته غير صحيح";
      String existMsg = "البريد الكتروني الذي ادخلته غير مسجّل ";
      String emptyfield = "يرجى ادخال البريد الالكتروني";
      if (e.message.toString() == "The email address is badly formatted.") {
        showToast(
          formatMsg,
          duration: Duration(seconds: 3),
          position: ToastPosition.bottom,
          backgroundColor: Colors.black,
          radius: 8.0,
          textStyle: TextStyle(color: Colors.white),
        );
      } else if (e.message.toString() ==
          "Unable to establish connection on channel.") {
        showToast(
          emptyfield,
          duration: Duration(seconds: 3),
          position: ToastPosition.bottom,
          backgroundColor: Colors.black,
          radius: 8.0,
          textStyle: TextStyle(color: Colors.white),
        );
      } else {
        showToast(
          existMsg,
          duration: Duration(seconds: 3),
          position: ToastPosition.bottom,
          backgroundColor: Colors.black,
          radius: 8.0,
          textStyle: TextStyle(color: Colors.white),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
<<<<<<< HEAD
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text('إعادة ضبط كلمة المرور'),
        centerTitle: true,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Instructions for the new password

            Text(
              '1. يجب أن تتضمن كلمة المرور الجديدة على رقم واحد على الأقل.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
=======
        appBar: AppBar(
          title: const Text('إعادة ضبط كلمة المرور'),
          centerTitle: true,
          backgroundColor: Colors.teal,
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
>>>>>>> main
              ),
              textAlign: TextAlign.right,
            ),
            Text(
              '2. يجب أن تتضمن كلمة المرور الجديدة على ثمانية خانات على الأقل.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
              textAlign: TextAlign.right,
            ),
            SizedBox(height: 50),
            Text(
              ' ادخل بريدك الالكتروني لارسال رابط تغيير كلمة المرور',
              style: TextStyle(
                fontSize: 15,
                color: Colors.black,
              ),
              textAlign: TextAlign.right,
            ),
            SizedBox(height: 15),
            // Email textfield
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextFormField(
                controller: _emailController,
                style: TextStyle(color: Colors.black),
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
              onPressed: () => passwordReset(context),
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
      ),
    );
  }
}