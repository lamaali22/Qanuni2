import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qanuni/utils/colors.dart';

class CustomTextFormField extends StatelessWidget {
  final String hinttext;
  final Function? onChanged;
  final double? fontSize;
  final Widget? icon;
  final TextEditingController? mycontroller;
  final String? Function(String?) valid;
  final int? maxLength;
  final bool? obscureText;
  final Color? filledColor;
  final double? height;
  final double? width;
  final int? numberOfLines;
  final bool? showCounter;
  final int? currentLength;
  final List<TextInputFormatter>? inputFormatters;

  const CustomTextFormField(
      {Key? key,
      this.obscureText,
      this.onChanged,
      required this.hinttext,
      required this.icon,
      required this.mycontroller,
      required this.valid,
      this.maxLength,
      this.filledColor,
      this.width,
      this.height,
      this.numberOfLines,
      this.fontSize,
      this.showCounter,
      this.currentLength,
      this.inputFormatters})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        width: width,
        child: TextFormField(
          validator: valid,
          maxLines: numberOfLines ?? 1,
          controller: mycontroller,
          onChanged: (String text) {
            if (onChanged != null) {
              onChanged!();
            }
          },
          inputFormatters: inputFormatters,
          textAlignVertical: TextAlignVertical.center,
          style: TextStyle(
              height: 1.4, fontSize: fontSize ?? 14, color: Colors.black),
          obscureText:
              obscureText == null || obscureText == false ? false : true,
          maxLength: maxLength,
          decoration: InputDecoration(
              counterText:
                  showCounter != null && showCounter! && maxLength != null
                      ? null
                      : '',
              errorStyle: TextStyle(color: Colors.red, fontSize: 14),
              fillColor: filledColor,
              filled: filledColor != null,
              isCollapsed: false,
              hintText: hinttext,
              counter: showCounter != null && showCounter!
                  ? Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '$currentLength/$maxLength',
                        style: TextStyle(color: Colors.black),
                      ),
                    )
                  : null,
              hintStyle:
                  TextStyle(fontSize: fontSize ?? 14, color: Colors.grey),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
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
                  borderSide: BorderSide(width: 0.5, color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(10)),
              border: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(10))),
        ),
      ),
    );
  }
}
