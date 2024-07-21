import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:teaming/detail/modify_project.dart';
import 'package:teaming/detail/time_table.dart';

class DetailNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Type currentPage;

  const DetailNavigationBar({
    super.key,
    required this.currentIndex,
    required this.currentPage,
  });
  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => TeamSchedulePage()),
        );
        break;
      case 1:
        // Add your navigation logic here
        break;
      case 2:
        // Add your navigation logic here
        break;
      case 3:
        // Add your navigation logic here
        break;
      case 4:
      
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ModifyProjectPage()),
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