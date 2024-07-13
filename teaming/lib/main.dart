import 'package:teaming/login/information_collab.dart';
import 'package:teaming/login/information_schedule.dart';
import 'package:teaming/login/login.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false, // 디버그 바 제거
    home: GetSchedulePage(), // 테스트용 설정
    // home: LoginPage(),
  ));
}
