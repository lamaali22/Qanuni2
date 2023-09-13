import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qanuni_app/utils/colors.dart';

class CustomTextFormField extends StatelessWidget {
  final String hinttext;
  final Function? onChanged;

  final Widget? icon;
  final TextEditingController? mycontroller;
  final String? Function(String?) valid;

  final bool? obscureText;
  final Color? filledColor;
  final double? height;
  final double? width;

  const CustomTextFormField({
    Key? key,
    this.obscureText,
    this.onChanged,
    required this.hinttext,
    required this.icon,
    required this.mycontroller,
    required this.valid,
    this.filledColor,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: width,
            height: height,
            child: TextFormField(
              validator: valid,
              controller: mycontroller,
              textAlignVertical: TextAlignVertical.center,
              style: TextStyle(height: 1.4, fontSize: 14, color: Colors.black),
              obscureText:
                  obscureText == null || obscureText == false ? false : true,
              decoration: InputDecoration(
                  fillColor: filledColor,
                  filled: filledColor != null,
                  isCollapsed: true,
                  hintText: hinttext,
                  hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  prefixIcon: icon,
                  prefixIconColor: MaterialStateColor.resolveWith((states) =>
                      states.contains(MaterialState.focused)
                          ? ColorConstants.primaryColor
                          : Colors.grey),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 0.5, color: ColorConstants.primaryColor),
                      borderRadius: BorderRadius.circular(10)),
                  enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 0.5, color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(10)),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(10))),
            ),
          ),
        ],
      ),
    );
  }
}
