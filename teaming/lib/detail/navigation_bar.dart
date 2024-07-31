import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:teaming/detail/archive/file_archive.dart';
import 'package:teaming/detail/archive/file_item.dart';
import 'package:teaming/detail/archive/member_information.dart';
import 'package:teaming/detail/modify/modify_project.dart';
import 'package:teaming/detail/participation/participation.dart';
import 'package:teaming/detail/work/team_work.dart';
import 'package:teaming/detail/time_table/time_table.dart';

class DetailNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Type currentPage;

  List<Map<String, dynamic>> tasks = [
  {
    'title': 'PPT 제작',
    'members': ['김세아'],
    'description': 'PPT 디자인 및 내용 정리',
    'startDate': '2024.05.01',
    'endDate': '2024.05.04',
    'progress': 50,
  },
  {
    'title': '자료조사',
    'members': ['오수진', '윤소윤'],
    'description': '지정 주제 관련 기사 및 논문 조사',
    'startDate': '2024.04.30',
    'endDate': '2024.05.02',
    'progress': 90,
  },
  {
    'title': '주제 선정',
    'members': ['김세아', '오수진', '윤소윤'],
    'description': '수업 내용에 맞는 적절한 주제 선정',
    'startDate': '2024.04.03',
    'endDate': '2024.04.25',
    'progress': 100,
  },
  {
    'title': '교수님 피드백 정리',
    'members': ['김세아', '오수진', '윤소윤'],
    'description': '회의하면서 주제 아이디어안도 생각',
    'startDate': '2024.04.01',
    'endDate': '2024.04.20',
    'progress': 100,
  },
  {
    'title': '수업 사전조사',
    'members': ['김세아', '오수진', '윤소윤'],
    'description': '수업 내용에 맞는 논문 및 기사 조사하고 노션에 따로 정리하기',
    'startDate': '2024.04.01',
    'endDate': '2024.04.18',
    'progress': 100,
  },
];

  List<FileItem> sampleFiles = [
      FileItem(
        name: '최종 보고서.pptx',
        uploader: '김세아',
        uploadDate: DateTime(2024, 7, 28),
        size: '98MB',
      ),
      FileItem(
        name: '보고서 초안_수정.pptx',
        uploader: '김세아',
        uploadDate: DateTime(2024, 7, 2),
        size: '34MB',
      ),
      FileItem(
        name: '논문 파일 모음.zip',
        uploader: '윤소윤',
        uploadDate: DateTime(2024, 7, 1),
        size: '1GB',
      ),
      FileItem(
        name: '주제 조사 내용.pdf',
        uploader: '오수진',
        uploadDate: DateTime(2024, 6, 23),
        size: '5MB',
      ),
      FileItem(
        name: '수업 중 발표에 대한 안내문.pdf',
        uploader: '오수진',
        uploadDate: DateTime(2024, 6, 15),
        size: '1MB',
      ),
    ];


  DetailNavigationBar({
    super.key,
    required this.currentIndex,
    required this.currentPage,
  });
  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => TeamSchedulePage(),
            transitionDuration: Duration(milliseconds: 500),
            transitionsBuilder: (_, a, __, c) =>
                FadeTransition(opacity: a, child: c),
          ),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => TeamWorkPage(),
            transitionDuration: Duration(milliseconds: 500),
            transitionsBuilder: (_, a, __, c) =>
                FadeTransition(opacity: a, child: c),
          ),
        );
        break;
      case 2:
        Navigator.pushReplacement(context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => ParticipationAnalysisPage(tasks: tasks, teamMembers: ['윤소윤', '오수진', '김세아'],),
            transitionDuration: Duration(milliseconds: 500),
            transitionsBuilder: (_, a, __, c) =>
                FadeTransition(opacity: a, child: c),),
        );
        break;
      case 3:
        Navigator.pushReplacement(context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => FileArchivePage(files: sampleFiles,),
            transitionDuration: Duration(milliseconds: 500),
            transitionsBuilder: (_, a, __, c) =>
                FadeTransition(opacity: a, child: c),),
        );
        break;
      case 4:
        Navigator.push(
          context,PageRouteBuilder(
            pageBuilder: (_, __, ___) => ModifyProjectPage(),
            transitionDuration: Duration(milliseconds: 500),
            transitionsBuilder: (_, a, __, c) =>
                FadeTransition(opacity: a, child: c),
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.schedule),
              label: '시간표',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.task),
              label: '업무관리',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: '참여도',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.archive),
              label: '아카이브',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.edit),
              label: '수정',
            ),
          ],
          currentIndex: currentIndex,
          selectedItemColor: Color(0xff3A3A3A),
          unselectedItemColor: Color(0xff787878),
          selectedLabelStyle: TextStyle(
            fontFamily: 'Leferi',
            fontWeight: FontWeight.bold,
            fontSize: 10,
          ),
          unselectedLabelStyle: TextStyle(
            fontFamily: 'Leferi',
            fontWeight: FontWeight.bold,
            fontSize: 10,
          ),
          onTap: (index) => _onItemTapped(context, index),
          backgroundColor: Colors.white.withOpacity(0.6),
        ),
      ),
    );
  }
}
