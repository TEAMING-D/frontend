import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget buildTextField(
    String label, String hint, TextEditingController? controllerName) {
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
  String hintText,
  TextEditingController? controllerName, {
  TextInputType keyboardType = TextInputType.text,
  List<TextInputFormatter>? inputFormatters,
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
          buildShortTextField(num1, controller1),
          SizedBox(width: 20),
          buildShortTextField(num2, controller2),
          SizedBox(width: 20),
          buildShortTextField(num3, controller3),
        ],
      ),
    ],
  );
}

// 생년월일 텍스트 필드 빌드 함수
Widget buildDateTextField(
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
          buildShortTextField(num1, controller1),
          SizedBox(width: 20),
          buildShortTextField(num2, controller2),
          SizedBox(width: 20),
          buildShortTextField(num3, controller3),
        ],
      ),
    ],
  );
}

Widget buildTextFieldOnly(String hint, TextEditingController? controllerName) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(
        height: 30,
        child: TextField(
          controller: controllerName,
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
