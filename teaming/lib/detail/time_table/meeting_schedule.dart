import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:teaming/detail/navigation_bar.dart';
import 'package:teaming/detail/time_table/add_meeting.dart';
import 'package:teaming/detail/time_table/meeting_time_table.dart';
import 'package:teaming/detail/time_table/member_time_table.dart';
import 'package:teaming/detail/time_table/modify_meeting.dart';
import 'package:teaming/detail/time_table/time_table.dart';

class MeetingSchedulePage extends StatefulWidget {
  const MeetingSchedulePage({super.key});

  @override
  _MeetingSchedulePageState createState() => _MeetingSchedulePageState();
}

class _MeetingSchedulePageState extends State<MeetingSchedulePage> {
  OverlayEntry? _balloonOverlay;

  List<Map<String, dynamic>> meetings = [
    // 회의 일정 데이터
    {
      'title': '논문 조사 및 요약',
      'startDate': DateTime(2024, 8, 3, 13, 0),
      'endDate': DateTime(2024, 8, 3, 15, 15),
      'members': ['김세아', '오수진', '윤소윤'],
    },
    {
      'title': '공지 변경사항으로 회의',
      'startDate': DateTime(2024, 8, 7, 10, 0),
      'endDate': DateTime(2024, 8, 7, 19, 45),
      'members': ['김세아', '오수진'],
    },
    {
      'title': '자료조사 방법 정하기',
      'startDate': DateTime(2024, 7, 30, 9, 0),
      'endDate': DateTime(2024, 7, 30, 11, 30),
      'members': ['오수진', '윤소윤'],
    },
    {
      'title': '주제 결정하기',
      'startDate': DateTime(2024, 4, 28, 13, 0),
      'endDate': DateTime(2024, 4, 28, 14, 15),
      'members': ['김세아', '오수진', '윤소윤', '박익명', '김익명'],
    },
  ];

  void _deleteMeeting(Map<String, dynamic> meeting) {
    setState(() {
      meetings.remove(meeting);
    });
  }

  void _addMeeting(Map<String, dynamic> meeting) {
    setState(() {
      meetings.add(meeting);
      meetings.sort((a, b) => a['startDate'].compareTo(b['startDate']));
    });
  }

  void _editMeeting(
      Map<String, dynamic> oldMeeting, Map<String, dynamic> newMeeting) {
    setState(() {
      int index = meetings.indexOf(oldMeeting);
      meetings[index] = newMeeting;
      meetings.sort((a, b) => b['startDate'].compareTo(a['startDate']));
    });
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
        ),
      ],
      color: Colors.white,
    );
  }

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
                '팀 회의 일정 보기',
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
        actions: [
          IconButton(
            icon: Image.asset(
              'assets/icon/plus_icon.png',
              height: 30,
              width: 30,
            ),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddMeetingPage(),
                ),
              );
              if (result != null) {
                _addMeeting(result);
              }
            },
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        width: MediaQuery.of(context).size.width,
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
        child: meetings.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/icon/no_list_icon.png'),
                    SizedBox(height: 20),
                    Text(
                      '생성된 회의 일정이 없습니다\n우측 상단의 + 아이콘을 눌러 회의를 생성해주세요',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        fontSize: 13,
                        color: Color(0xFF404040),
                      ),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                itemCount: meetings.length,
                itemBuilder: (context, index) {
                  final meeting = meetings[index];
                  return MeetingBlock(
                    meeting: meeting,
                    onDelete: () {
                      _deleteMeeting(meeting);
                    },
                    onEdit: () async {
                      final editedMeeting = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ModifyMeetingPage(meeting: meeting),
                        ),
                      );
                      if (editedMeeting != null) {
                        _editMeeting(meeting, editedMeeting);
                      }
                    },
                  );
                },
              ),
      ),
      bottomNavigationBar: DetailNavigationBar(
        currentIndex: 0,
        currentPage: MeetingSchedulePage,
      ),
    );
  }
}

class MeetingBlock extends StatelessWidget {
  final Map<String, dynamic> meeting;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  MeetingBlock(
      {required this.meeting, required this.onDelete, required this.onEdit});

  String formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  String formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    bool isCompleted = meeting['endDate'].isBefore(DateTime.now());

    return GestureDetector(
      onLongPress: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              contentPadding: EdgeInsets.fromLTRB(13, 25, 13, 10),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${meeting['title']}',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                      color: Color(0xFF585454),
                      height: 1.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    '이 회의를 삭제하시겠습니까?',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                      color: Color(0xFF585454),
                      height: 1.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.grey[600],
                            backgroundColor: Color.fromRGBO(216, 216, 216, 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            '취소',
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(84, 84, 84, 1),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            onDelete();
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Color.fromRGBO(84, 84, 84, 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            '확인',
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
      onTap: onEdit,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isCompleted ? Color(0xFF535353) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              spreadRadius: 1,
              blurRadius: 5,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${formatDate(meeting['startDate'])} ${formatTime(meeting['startDate'])} ~ ${formatDate(meeting['endDate'])} ${formatTime(meeting['endDate'])}',
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                fontSize: 12,
                color: isCompleted ? Colors.white : Color(0xFF404040),
              ),
            ),
            SizedBox(height: 20),
            Text(
              '${_getMemberNames(meeting['members'])} 참여',
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                fontSize: 12,
                color: isCompleted ? Colors.white : Color(0xFF404040),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${meeting['title']}',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: isCompleted ? Colors.white : Color(0xFF404040),
                  ),
                ),
                if (isCompleted)
                  Text('완료된 회의',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: Colors.white,
                      ))
                else
                  Icon(Icons.arrow_forward_rounded, color: Color(0xFF404040)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getMemberNames(List<String> members) {
    if (members.length == 3) {
      return members.join(', ');
    } else if (members.length > 3) {
      return '${members.take(3).join(', ')} 외 ${members.length - 3}명';
    } else {
      return members.join(', ');
    }
  }
}
