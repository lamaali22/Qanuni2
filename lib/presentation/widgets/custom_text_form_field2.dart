import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:qanuni/utils/colors.dart';

class CustomTextFormField2 extends StatelessWidget {
  final String hinttext;
  final Function(String)? onChanged;

  final Widget? prefixWidget;
  final Widget? suffixWidget;
  final TextEditingController? mycontroller;
  final String? Function(String?) valid;
  final int? maxLength;
  final bool? obscureText;
  final bool? isNumber;
  final Color? filledColor;
  final TextDirection? textDirection;
  final double? height;
  final double? width;

  const CustomTextFormField2({
    Key? key,
    this.obscureText,
    this.onChanged,
    required this.hinttext,
    required this.prefixWidget,
    required this.suffixWidget,
    required this.mycontroller,
    required this.valid,
    this.isNumber,
    required this.textDirection,
    this.maxLength,
    this.filledColor,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: textDirection!,
      child: Container(
        width: width,
        child: TextFormField(
          validator: valid,
          controller: mycontroller,
          textAlignVertical: TextAlignVertical.center,
          style: TextStyle(height: 1.4, fontSize: 14, color: Colors.black),
          obscureText:
              obscureText == null || obscureText == false ? false : true,
          maxLength: maxLength,
          onChanged: (value) {
            if (onChanged != null) {
              onChanged!(value);
            }
          },
          keyboardType: isNumber != null ? TextInputType.number : null,
          decoration: InputDecoration(
              counterText: '',
              errorStyle: TextStyle(color: Colors.red, fontSize: 14),
              fillColor: filledColor,
              filled: filledColor != null,
              isCollapsed: false,
              hintText: hinttext,
              hintStyle: TextStyle(fontSize: 14, color: Colors.grey[500]!),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              prefixIcon: prefixWidget,
              suffixIcon: suffixWidget,
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      width: 1, color: Color(0xFF008080).withOpacity(0.28)),
                  borderRadius: BorderRadius.circular(15)),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      width: 1, color: Color(0xFF008080).withOpacity(0.28)),
                  borderRadius: BorderRadius.circular(15)),
              border: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(15))),
        ),
      ),
    );
  }
}
