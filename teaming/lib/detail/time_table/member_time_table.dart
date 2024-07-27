import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:teaming/detail/time_table/meeting_schedule.dart';
import 'package:teaming/detail/time_table/meeting_time_table.dart';
import 'package:teaming/detail/navigation_bar.dart';
import 'package:teaming/detail/time_table/time_table.dart';

class MemberSchedulePage extends StatefulWidget {
  const MemberSchedulePage({super.key});

  @override
  _MemberSchedulePageState createState() => _MemberSchedulePageState();
}

class _MemberSchedulePageState extends State<MemberSchedulePage> {
  String selectedMember = '김세아'; // 기본 선택된 팀원
  bool isSchedulePublic = true; // 시간표 공개 여부
  final ScrollController _scrollController = ScrollController();

  final List<Map<String, dynamic>> availability = [
    // 김세아
    {
      'name': '김세아',
      'day': '월',
      'startHour': 13,
      'endHour': 16,
      'title': '수업명A'
    },
    {
      'name': '김세아',
      'day': '화',
      'startHour': 10,
      'endHour': 11,
      'title': '수업명B'
    },
    {
      'name': '김세아',
      'day': '화',
      'startHour': 12,
      'endHour': 13,
      'title': '수업명C'
    },
    {
      'name': '김세아',
      'day': '수',
      'startHour': 13,
      'endHour': 16,
      'title': '수업명D'
    },
    {
      'name': '김세아',
      'day': '목',
      'startHour': 10,
      'endHour': 11,
      'title': '수업명E'
    },
    {
      'name': '김세아',
      'day': '목',
      'startHour': 12,
      'endHour': 13,
      'title': '수업명F'
    },
    {
      'name': '김세아',
      'day': '금',
      'startHour': 15,
      'endHour': 19,
      'title': '수업명G'
    },
    {
      'name': '김세아',
      'day': '토',
      'startHour': 12,
      'endHour': 20,
      'title': '수업명H'
    },
    // 윤소윤
    {'name': '윤소윤', 'day': '월', 'startHour': 10, 'endHour': 11, 'title': '일정I'},
    {'name': '윤소윤', 'day': '월', 'startHour': 12, 'endHour': 13, 'title': '일정J'},
    {'name': '윤소윤', 'day': '화', 'startHour': 10, 'endHour': 11, 'title': '일정K'},
    {'name': '윤소윤', 'day': '수', 'startHour': 10, 'endHour': 11, 'title': '일정L'},
    {'name': '윤소윤', 'day': '수', 'startHour': 13, 'endHour': 16, 'title': '일정M'},
    {'name': '윤소윤', 'day': '목', 'startHour': 10, 'endHour': 11, 'title': '일정N'},
    {'name': '윤소윤', 'day': '목', 'startHour': 12, 'endHour': 13, 'title': '일정O'},
    {'name': '윤소윤', 'day': '금', 'startHour': 14, 'endHour': 15, 'title': '일정P'},
    {'name': '윤소윤', 'day': '금', 'startHour': 15, 'endHour': 19, 'title': '일정Q'},
  ];

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
                '팀원별 시간표 조회',
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
              '팀원들의 개인 시간표 조회가 가능합니다\n공개 설정된 경우에만 확인할 수 있습니다',
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
            ),
            _buildMemberTabs(),
            SizedBox(
              height: 15,
            ),
            isSchedulePublic ? _buildScheduleTable() : _buildPrivateMessage(),
            SizedBox(
              height: 55,
            ),
          ],
        ),
      ),
      bottomNavigationBar: DetailNavigationBar(
        currentIndex: 0,
        currentPage: MemberSchedulePage,
      ),
    );
  }

  Widget _buildMemberTabs() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildMemberTab('김세아'),
        _buildMemberTab('오수진'),
        _buildMemberTab('윤소윤'),
      ],
    );
  }

  Widget _buildMemberTab(String member) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedMember = member;
          isSchedulePublic = member != '오수진'; //비공개 팀원 설정
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 2,
              color:
                  selectedMember == member ? Colors.black : Colors.transparent,
            ),
          ),
        ),
        child: Text(
          member,
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight:
                selectedMember == member ? FontWeight.w800 : FontWeight.w400,
            fontSize: 16,
            color: selectedMember == member
                ? Color(0xFF404040)
                : Color(0xFFAAAAAA),
          ),
        ),
      ),
    );
  }

  Widget _buildScheduleTable() {
    List<Map<String, dynamic>> filteredSchedule =
        availability.where((entry) => entry['name'] == selectedMember).toList();

    List<Widget> rows = [];
    for (var day in ['월', '화', '수', '목', '금', '토', '일']) {
      for (int hour = 0; hour < 24; hour++) {
        bool isAvailable = filteredSchedule.any((entry) =>
            entry['day'] == day &&
            hour >= entry['startHour'] &&
            hour < entry['endHour']);
        if (isAvailable) {
          var schedule = filteredSchedule.firstWhere((entry) =>
              entry['day'] == day &&
              hour >= entry['startHour'] &&
              hour < entry['endHour']);
          if (hour == schedule['startHour']) {
            rows.add(Positioned(
              left: 47.75 * (dayIndex(day) + 1).toDouble(),
              top: (36 * (hour + 1)).toDouble(),
              width: 47.75.toDouble(),
              height: (36 * (schedule['endHour'] - schedule['startHour']))
                  .toDouble(),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.7),
                  border: Border.all(color: Colors.grey, width: 0.5),
                ),
                child: Center(
                  child: Text(
                    schedule['title'],
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.normal, // normal weight로 변경
                      fontSize: 12,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ));
          }
        }
      }
    }

    return Expanded(
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 47.9 * 8,
              height: (25.05 * 36).toDouble(),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 0.5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Stack(
                children: [
                  // 요일 헤더
                  Positioned(
                    left: 0,
                    top: 0,
                    right: 0,
                    height: 36,
                    child: Row(
                      children: [
                        Container(
                          width: 47.75,
                          height: 36,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 0.5),
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(
                                  10),
                            ),
                          ),
                        ),
                        for (int i = 0; i < 7; i++)
                          Container(
                            width: 47.75,
                            height: 36,
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.grey, width: 0.5),
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topRight: i == 6
                                    ? Radius.circular(10)
                                    : Radius.zero,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                ['월', '화', '수', '목', '금', '토', '일'][i],
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  // 시간 표시
                  Positioned(
                    left: 0,
                    top: 36,
                    bottom: 0,
                    width: 47.75,
                    child: Column(
                      children: [
                        for (int i = 0; i < 24; i++)
                          Container(
                            width: 47.75,
                            height: 36,
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.grey, width: 0.5),
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                bottomLeft: i == 23
                                    ? Radius.circular(10)
                                    : Radius
                                        .zero,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                '$i'.padLeft(2, '0'),
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Positioned(
                    right: 0,
                    top: 36,
                    bottom: 0,
                    width: 47.75,
                    child: Column(
                      children: [
                        for (int i = 0; i < 24; i++)
                          Container(
                            width: 47.75,
                            height: 36,
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.grey, width: 0.5),
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                bottomRight: i == 23
                                    ? Radius.circular(10)
                                    : Radius
                                        .zero,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                '',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  // 시간표의 빈 셀
                  ..._buildEmptyCells(),
                  // 일정이 있는 셀
                  ...rows,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildEmptyCells() {
    List<Widget> cells = [];
    for (int hour = 0; hour < 24; hour++) {
      for (int day = 0; day < 7; day++) {
        cells.add(Positioned(
          left: (47.75 * (day + 1)).toDouble(),
          top: (36 * (hour + 1)).toDouble(),
          width: 47.75.toDouble(),
          height: 36.toDouble(),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 0.5),
              color: Colors.white,
            ),
            child: Center(
              child: Text(
                '',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ));
      }
    }
    return cells;
  }

  int dayIndex(String day) {
    switch (day) {
      case '월':
        return 0;
      case '화':
        return 1;
      case '수':
        return 2;
      case '목':
        return 3;
      case '금':
        return 4;
      case '토':
        return 5;
      case '일':
        return 6;
      default:
        return 0;
    }
  }

  Widget _buildPrivateMessage() {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/icon/locked_icon.png'),
            SizedBox(height: 20),
            Text(
              '해당 팀원의 시간표는\n비공개 처리되어 있습니다',
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Color(0xFF404040),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              '본인에게 공개 설정을 요청해보세요',
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                fontSize: 12,
                color: Color(0xFF404040),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 60,
            )
          ],
        ),
      ),
    );
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
                '가능한 회의 날짜 및 시간 조회',
                textAlign: TextAlign.center,
              )),
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MeetingTimePage()),
            );
          },
        ),PopupMenuItem(
          child: Container(
              alignment: Alignment.center,
              child: Text(
                '팀 회의 일정 조회',
                textAlign: TextAlign.center,
              )),
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => MeetingSchedulePage()),
            );
          },
        ),
      ],
      color: Colors.white,
    );
  }
}
