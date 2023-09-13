import 'package:flutter/material.dart';
import 'package:qanuni_app/utils/colors.dart';

class CustomRadioButton extends StatelessWidget {
  final int value, groupValue;
  final String title, content;
  final Function onChangeFunction;
  const CustomRadioButton(
      {Key? key,
      required this.value,
      required this.groupValue,
      required this.onChangeFunction,
      required this.title,
      required this.content})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        decoration: BoxDecoration(
            color: value == groupValue
                ? ColorConstants.primaryColor.withOpacity(0.19)
                : null,
            border: Border.all(
                width: 1,
                color: value == groupValue
                    ? ColorConstants.primaryColor
                    : ColorConstants.borderColor),
            borderRadius: BorderRadius.circular(15)),
        padding: EdgeInsets.all(10),
        child: Row(children: [
          Theme(
            data: Theme.of(context)
                .copyWith(unselectedWidgetColor: ColorConstants.borderColor),
            child: Radio(
                value: value,
                activeColor: ColorConstants.primaryColor,
                groupValue: groupValue,
                onChanged: (value) => onChangeFunction(value)),
          ),
          SizedBox(
            width: 15,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(color: Colors.black, fontSize: 18),
              ),
              SizedBox(
                height: 2,
              ),
              Text(
                '   $content',
                style: TextStyle(color: Colors.black, fontSize: 14),
              )
            ],
          )
        ]),
      ),
    );
  }
}
