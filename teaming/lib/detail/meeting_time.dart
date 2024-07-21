import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:teaming/detail/member_time_table.dart';
import 'package:teaming/detail/time_table.dart';

class MeetingTimePage extends StatelessWidget {
  const MeetingTimePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
            child: Container(
              color: Colors.transparent,
            ),
          ),
        ),
        scrolledUnderElevation: 0,
        title: GestureDetector(
          onTap: () => _showDropdownMenu(context),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '가능한 회의 날짜 및 시간 조회',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                  color: Color(0xFF404040),
                ),
              ),
              Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF404040)),
            ],
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.center,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                Color.fromRGBO(138, 138, 138, 1),
              ],
            ),
          ),
          child: Column(
            children: [
              SizedBox(
                height: kToolbarHeight + MediaQuery.of(context).padding.top + 10,
              ),
              Text(
                '원하는 일정과 팀원을 선택해\n가능한 회의 날짜와 시간을 조회합니다',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  fontSize: 11,
                  color: Color(0xFF404040),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 10,
              ),Text(
                '최대 일주일까지 조회할 수 있습니다',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  fontSize: 11,
                  color: Color(0xFF404040),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          )),
    );
  }
}

void _showDropdownMenu(BuildContext context) {
  final RenderBox renderBox = context.findRenderObject() as RenderBox;
  final position = renderBox.localToGlobal(Offset.zero);

  showMenu(
    context: context,
    position: RelativeRect.fromLTRB(
      (MediaQuery.of(context).size.width / 4),
      position.dy + kToolbarHeight + 20,
      (MediaQuery.of(context).size.width / 4 * 3),
      0,
    ),
    items: [
      PopupMenuItem(
        child: Container(
            alignment: Alignment.center,
            child: Text(
              '팀 시간표',
              textAlign: TextAlign.center,
            )),
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => TeamSchedulePage()),
          );
        },
      ),
      PopupMenuItem(
        child: Container(
            alignment: Alignment.center,
            child: Text(
              '팀원별 시간표 조회',
              textAlign: TextAlign.center,
            )),
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MemberSchedulePage()),
          );
        },
      ),
    ],
    color: Colors.white,
  );
}
