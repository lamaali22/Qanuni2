import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final double? width, height, borderRadius;
  final Color? color;
  final String title;

  const CustomButton(
      {Key? key,
      required this.width,
      required this.height,
      required this.borderRadius,
      required this.color,
      required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: color,
          borderRadius: borderRadius != null
              ? BorderRadius.circular(borderRadius!)
              : null),
      child: Text(title),
    );
  }
}
