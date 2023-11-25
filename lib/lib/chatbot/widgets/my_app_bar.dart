import 'package:flutter/material.dart';
import 'package:qanuni/homePage.dart';
import '../providers/active_theme_provider.dart';
import 'theme_switch.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        'روبوت قانوني',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      centerTitle: true, // Center the title
      backgroundColor:Color(0xFF008080),
      leading: null, // Remove the leading back button
      actions: [
        IconButton(
          icon: Icon(Icons.arrow_forward),
          color: Colors.white,
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => LogoutPage()),
              (route) => false,
            );
          },
        ),
        Row(
          
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
