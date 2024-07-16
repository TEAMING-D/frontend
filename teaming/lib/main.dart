import 'package:teaming/home/project.dart';
import 'package:teaming/login/information_collab.dart';
import 'package:teaming/login/information_schedule.dart';
import 'package:teaming/login/login.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false, // 디버그 바 제거
      home: TeamProjectPage(
        projects: [
          {
            'name': '프로젝트명A',
            'members': ['김세아', '오수진', '윤소윤'],
            'class': '수업명A',
            'progress': 80,
            'startDate': '2024.03.04',
            'endDate': '2024.08.15',
          },
          {
            'name': '프로젝트명B',
            'members': ['김세아', '오수진', '윤소윤', '황익명', '박익명', '김익명', '이익명', '장익명'],
            'class': '수업명B',
            'progress': 45,
            'startDate': '2024.01.13',
            'endDate': '2024.07.20',
          },
          {
            'name': '프로젝트명C',
            'members': ['김세아', '박익명', '최익명'],
            'class': '대회명A',
            'progress': 100,
            'startDate': '2023.12.13',
            'endDate': '2024.05.23',
          },
          {
            'name': '프로젝트명D',
            'members': ['김세아', '이익명'],
            'class': '수업명C ',
            'progress': 20,
            'startDate': '2023.08.15',
            'endDate': '2024.02.21',
          },
          {
            'name': '프로젝트명E',
            'members': ['김세아', '이익명', '박익명'],
            'class': '대회명B',
            'progress': 95,
            'startDate': '2023.08.15',
            'endDate': '2023.12.21',
          },
          {
            'name': '프로젝트명F',
            'members': ['김세아', '박익명'],
            'class': '봉사명A',
            'progress': 20,
            'startDate': '2023.06.25',
            'endDate': '2023.08.10',
          },
        ],
        hasNotification: false,
      ),
    ), // 테스트용 설정
    // home: LoginPage(),
  );
}
