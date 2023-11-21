import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:qanuni/presentation/screens/login_screen/view.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Added GlobalKey for the Form

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> passwordReset(BuildContext context) async {
    try {
      if (_formKey.currentState?.validate() ?? false) {
        // Only proceed if the form is valid
        await FirebaseAuth.instance
            .sendPasswordResetEmail(email: _emailController.text.trim());
        showToast(
          "تم ارسال رابط تغيير كلمة المرور",
          duration: Duration(seconds: 3),
          position: ToastPosition.bottom,
          backgroundColor: Colors.green,
          radius: 8.0,
          textStyle: TextStyle(color: Colors.white),
        );

        // Navigate back to the LoginScreen
        Navigator.pop(context);
      }
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
          backgroundColor: Colors.red,
          radius: 8.0,
          textStyle: TextStyle(color: Colors.white),
        );
      } else if (e.message.toString() ==
          "There is no user record corresponding to this identifier. The user may have been deleted.") {
        showToast(
          existMsg,
          duration: Duration(seconds: 3),
          position: ToastPosition.bottom,
          backgroundColor: Colors.red,
          radius: 8.0,
          textStyle: TextStyle(color: Colors.white),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text('إعادة ضبط كلمة المرور'),
        centerTitle: true,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Form(
          key: _formKey, // Set the key for the Form
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 28.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "ادخل بريدك الالكتروني لارسال رابط تغيير كلمة المرور",
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Cairo',
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15),
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
                  validator: (value) {
                    print('Validator executed');
                    if (value == null || value.trim().isEmpty) {
                      return 'البريد الالكتروني مطلوب';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 28.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    ' يجب أن تتضمن كلمة المرور الجديدة على ثمانية خانات و رقم واحد على الأقل',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Cairo',
                      color: const Color.fromARGB(255, 246, 86, 75),
                    ),
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
                    borderRadius: BorderRadius.circular(12)),
                height: 50,
                minWidth: 325,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
