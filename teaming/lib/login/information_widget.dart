import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget buildTextField(
  String label,
  String hint, {
  TextEditingController? controllerName,
  TextInputType keyboardType = TextInputType.text,
  List<TextInputFormatter>? inputFormatters,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(
          fontFamily: 'Inter',
          fontWeight: FontWeight.w500,
          fontSize: 16,
          color: Color(0xFF484848),
        ),
      ),
      SizedBox(
        height: 30,
        child: TextField(
          obscureText: label.contains('비밀번호') ? true : false,
          controller: controllerName,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          style: TextStyle(fontSize: 15, color: Colors.black),
          decoration: InputDecoration(
            hintText: hint,
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 5),
            hintStyle: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              fontSize: 15,
              color: Color(0xFFA9A9A9),
            ),
          ),
        ),
      ),
      SizedBox(height: 3),
      Divider(color: Color(0xFF9C9C9C), thickness: 1),
    ],
  );
}

Widget buildDivideTextField(
    String label,
    String categoryHint,
    String detailHint,
    TextEditingController? controllerName1,
    TextEditingController? controllerName2) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(
          fontFamily: 'Inter',
          fontWeight: FontWeight.w500,
          fontSize: 16,
          color: Color(0xFF484848),
        ),
      ),
      Row(
        children: [
          SizedBox(
            width: 82,
            child: Column(
              children: [
                SizedBox(
                  height: 30,
                  child: TextField(
                    controller: controllerName1,
                    style: TextStyle(fontSize: 15, color: Colors.black),
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: categoryHint,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 5),
                      hintStyle: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
                          color: Color(0xFF828282)),
                    ),
                  ),
                ),
                Divider(color: Color(0xFF828282), thickness: 1),
              ],
            ),
          ),
          SizedBox(width: 20),
          Expanded(
            child: Column(
              children: [
                SizedBox(
                  height: 30,
                  child: TextField(
                    controller: controllerName2,
                    style: TextStyle(fontSize: 15, color: Colors.black),
                    decoration: InputDecoration(
                      hintText: detailHint,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 5),
                      hintStyle: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
                          color: Color(0xFF828282)),
                    ),
                  ),
                ),
                Divider(color: Color(0xFF828282), thickness: 1),
              ],
            ),
          ),
        ],
      )
    ],
  );
}

Widget buildShortTextField(
  String hintText, {
  TextEditingController? controllerName,
  TextInputType keyboardType = TextInputType.text,
  List<TextInputFormatter>? inputFormatters,
  Function(String)? onChanged,
  Function(String)? onSubmitted,
  VoidCallback? onEditingComplete,
}) {
  return Expanded(
    child: Column(
      children: [
        SizedBox(
          height: 30,
          child: TextField(
            controller: controllerName,
            style: TextStyle(fontSize: 15, color: Colors.black),
            textAlign: TextAlign.center,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            onChanged: onChanged,
            onSubmitted: onSubmitted,
            onEditingComplete: onEditingComplete,
            decoration: InputDecoration(
              hintText: hintText,
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 5),
              hintStyle: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                  color: Color(0xFF828282)),
            ),
          ),
        ),
        Divider(color: Color(0xFF828282), thickness: 1),
      ],
    ),
  );
}

Widget buildPhoneTextField(
    String label,
    String num1,
    String num2,
    String num3,
    TextEditingController? controller1,
    TextEditingController? controller2,
    TextEditingController? controller3) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(
          fontFamily: 'Inter',
          fontWeight: FontWeight.w500,
          fontSize: 16,
          color: Color(0xFF484848),
        ),
      ),
      Row(
        children: [
          buildShortTextField(
            num1,
            controllerName: controller1,
          ),
          SizedBox(width: 20),
          buildShortTextField(num2, controllerName: controller2),
          SizedBox(width: 20),
          buildShortTextField(num3, controllerName: controller3),
        ],
      ),
    ],
  );
}

// 날짜 텍스트 필드 빌드 함수
Widget buildDateTextField(
  String label,
  String num1,
  String num2,
  String num3, {
  TextEditingController? controller1,
  TextEditingController? controller2,
  TextEditingController? controller3,
  TextInputType keyboardType = TextInputType.text,
  List<TextInputFormatter>? inputFormatters,
  Function(String)? onChanged1,
  Function(String)? onChanged2,
  Function(String)? onChanged3,
  Function(String)? onSubmitted1,
  Function(String)? onSubmitted2,
  Function(String)? onSubmitted3,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(
          fontFamily: 'Inter',
          fontWeight: FontWeight.w500,
          fontSize: 16,
          color: Color(0xFF484848),
        ),
      ),
      SizedBox(height: 5),
      Row(
        children: [
          buildShortTextField(
            num1,
            controllerName: controller1,
            inputFormatters: inputFormatters,
            keyboardType: keyboardType,
            onChanged: onChanged1,
            onSubmitted: onSubmitted1,
          ),
          SizedBox(width: 20),
          buildShortTextField(
            num2,
            controllerName: controller2,
            inputFormatters: inputFormatters,
            keyboardType: keyboardType,
            onChanged: onChanged2,
            onSubmitted: onSubmitted2,
          ),
          SizedBox(width: 20),
          buildShortTextField(
            num3,
            controllerName: controller3,
            inputFormatters: inputFormatters,
            keyboardType: keyboardType,
            onChanged: onChanged3,
            onSubmitted: onSubmitted3,
          ),
        ],
      ),
    ],
  );
}

Widget buildTextFieldOnly(
  String hint, {
  TextEditingController? controllerName,
  bool centerHintText = false,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(
        height: 30,
        child: TextField(
          controller: controllerName,
          style: TextStyle(fontSize: 15, color: Colors.black),
          textAlign: centerHintText ? TextAlign.center : TextAlign.start,
          decoration: InputDecoration(
            hintText: hint,
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 5),
            hintStyle: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              fontSize: 15,
              color: Color(0xFFA9A9A9),
            ),
          ),
        ),
      ),
      SizedBox(height: 3),
      Divider(color: Color(0xFF9C9C9C), thickness: 1),
    ],
  );
}
