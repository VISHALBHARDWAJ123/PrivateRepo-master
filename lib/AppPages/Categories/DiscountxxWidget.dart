import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

Widget discountWidget(
    {required String actualPrice,
    required bool isSpace,
    required double fontSize,
    required double width}) {
  return Container(
    width: 50.w,
    child: Align(
      alignment: Alignment.centerLeft,
      child: Text(
        !isSpace?actualPrice:'',
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: fontSize,
            color: Colors.grey.shade500,
            fontWeight: FontWeight.bold),
      ),
    ),
  );
}
