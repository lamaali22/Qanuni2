import 'package:flutter/material.dart';
import 'package:qanuni/homePageLawyer.dart';
import 'package:qanuni/presentation/screens/bookingListScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ToggleBarExample(),
    );
  }
}

class ToggleBarExample extends StatefulWidget {
  @override
  _ToggleBarExampleState createState() => _ToggleBarExampleState();
}

class _ToggleBarExampleState extends State<ToggleBarExample> {
  List<bool> isSelected = [true, false]; // To track which section is selected

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(255, 0, 128, 128),
        title: const Text(
          "استشاراتي",
          style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        actions: [],
      ),
      body: Column(
        children: [
          ToggleButtons(
            children: [
              Text('الحالية'),
              Text(' السابقة'),
            ],
            isSelected: isSelected,
            onPressed: (index) {
              setState(() {
                // Update the selection
                for (int buttonIndex = 0;
                    buttonIndex < isSelected.length;
                    buttonIndex++) {
                  if (buttonIndex == index) {
                    isSelected[buttonIndex] = true;
                  } else {
                    isSelected[buttonIndex] = false;
                  }
                }
              });
            },
          ),
          isSelected[0] // Check which section is selected
              ? BookingListScreen() // Display Section 1 content
              : LogoutPageLawyer(), // Display Section 2 content
        ],
      ),
    );
  }
}
