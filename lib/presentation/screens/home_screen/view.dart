import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qanuni_app/main.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'الصفحة الرئيسية',
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
            10.verticalSpace,
            ElevatedButton(
                onPressed: () async {
                  await auth.signOut();
                },
                child: Text('تسجيل خروج'))
          ],
        ),
      ),
    );
  }
}
