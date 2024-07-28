import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:teaming/detail/time_table/meeting_schedule.dart';
import 'package:teaming/detail/time_table/member_time_table.dart';
import 'package:teaming/detail/navigation_bar.dart';
import 'package:teaming/detail/time_table/time_table.dart';
import 'package:teaming/popup_widget.dart';

class MeetingTimePage extends StatefulWidget {
  const MeetingTimePage({super.key});

  @override
  _MeetingTimePageState createState() => _MeetingTimePageState();
}

class _MeetingTimePageState extends State<MeetingTimePage> {
  DateTime? _startDate;
  DateTime? _endDate;
  List<String> teamMembers = ['김세아', '오수진', '윤소윤', '김익명', '박익명'];
  List<String> selectedMembers = [];
  Map<String, List<int>> availableTimes = {};
  String dateAlertText = '일정은 최대 일주일로 설정 가능하며\n종료일이 시작일보다 앞설 수 없습니다';

  // _startDate 선택 부분
void _selectStartDate(BuildContext context) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    locale: const Locale('ko', 'KR'),
    initialDate: _startDate ?? DateTime.now(),
    firstDate: DateTime(2024),
    lastDate: DateTime(2030),
    builder: (BuildContext context, Widget? child) {
      return Theme(
        data: ThemeData.light().copyWith(
          colorScheme: ColorScheme.light(
            primary: Color(0xFF404040), // Header background color
            onPrimary: Colors.white, // Header text color
            onSurface: Color(0xFF404040), // Body text color
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: Color(0xFF404040), // Button text color
            ),
          ),
        ),
        child: child!,
      );
    },
  );
  if (picked != null) {
    setState(() {
      _startDate = picked;
      if (_endDate != null) {
        if (_startDate!.isAfter(_endDate!)) {
          showAlertDialog(
            context,
            dateAlertText,
          );
          _endDate = _startDate;
        } else if (_endDate!.difference(_startDate!).inDays > 7) {
          showAlertDialog(
            context,
            dateAlertText,
          );
          _endDate = _startDate!.add(Duration(days: 6));
        }
      }
    });
  }
}

// _endDate 선택 부분
void _selectEndDate(BuildContext context) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    locale: const Locale('ko', 'KR'),
    initialDate: _endDate ?? DateTime.now(),
    firstDate: DateTime(2024),
    lastDate: DateTime(2030),
    builder: (BuildContext context, Widget? child) {
      return Theme(
        data: ThemeData.light().copyWith(
          colorScheme: ColorScheme.light(
            primary: Color(0xFF404040), // Header background color
            onPrimary: Colors.white, // Header text color
            onSurface: Color(0xFF404040), // Body text color
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: Color(0xFF404040), // Button text color
            ),
          ),
        ),
        child: child!,
      );
    },
  );
  if (picked != null) {
    setState(() {
      _endDate = picked;
      if (_startDate != null) {
        if (_endDate!.isBefore(_startDate!)) {
          showAlertDialog(
            context,
            dateAlertText,
          );
          _endDate = _startDate;
        } else if (_endDate!.difference(_startDate!).inDays > 7) {
          showAlertDialog(
            context,
            dateAlertText,
          );
          _endDate = _startDate!.add(Duration(days: 6));
        }
      }
    });
  }
}
  void _selectMembers(BuildContext context) async {
    final List<String>? picked = await showGeneralDialog<List<String>>(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Center(
              child: Material(
                type: MaterialType.transparency,
                child: Container(
                  width: 200,
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Column(
                        children: teamMembers.map((member) {
                          return SizedBox(
                            width: 120,
                            child: CheckboxListTile(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 0),
                              value: selectedMembers.contains(member),
                              title: Text(
                                member,
                                style: TextStyle(fontSize: 16),
                              ),
                              controlAffinity: ListTileControlAffinity.leading,
                              onChanged: (isChecked) {
                                setState(() {
                                  if (isChecked!) {
                                    selectedMembers.add(member);
                                  } else {
                                    selectedMembers.remove(member);
                                  }
                                });
                              },
                              activeColor: Colors.black,
                              checkColor: Colors.white,
                              side: BorderSide(color: Colors.black),
                            ),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(foregroundColor: Colors.white,
                            backgroundColor: Colors.grey,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: Text(
                            '확인',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context, selectedMembers);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
      transitionDuration: Duration(milliseconds: 200),
    );

    if (picked != null) {
      setState(() {
        selectedMembers = picked;
      });
    }
  }

  String _getSelectedMembersText() {
    if (selectedMembers.isEmpty) {
      return '회의할 팀원 선택';
    } else if (selectedMembers.length == teamMembers.length) {
      return '팀원 전체';
    } else if (selectedMembers.length > 2) {
      return '${selectedMembers[0]}, ${selectedMembers[1]} 외 ${selectedMembers.length - 2}명';
    } else {
      return selectedMembers.join(', ');
    }
  }

void showAlertDialog(BuildContext context, String message) {
  showGeneralDialog(
    barrierLabel: "Popup",
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.3),
    transitionDuration: Duration(milliseconds: 300),
    context: context,
    pageBuilder: (context, anim1, anim2) {
      return PopupWidget(
        message: message,
      );
    },
    transitionBuilder: (context, anim1, anim2, child) {
      return FadeTransition(
        opacity: anim1,
        child: child,
      );
    },
  );
}

  void _checkAvailableTimes() {
    if (_startDate != null && _endDate != null && selectedMembers.isNotEmpty) {
      List<Map<String, dynamic>> availability = [
        // 김세아
        {'name': '김세아', 'day': '월', 'startHour': 0, 'endHour': 13},
        {'name': '김세아', 'day': '월', 'startHour': 16, 'endHour': 24},
        {'name': '김세아', 'day': '화', 'startHour': 0, 'endHour': 10},
        {'name': '김세아', 'day': '화', 'startHour': 11, 'endHour': 12},
        {'name': '김세아', 'day': '화', 'startHour': 13, 'endHour': 24},
        {'name': '김세아', 'day': '수', 'startHour': 0, 'endHour': 13},
        {'name': '김세아', 'day': '수', 'startHour': 16, 'endHour': 24},
        {'name': '김세아', 'day': '목', 'startHour': 0, 'endHour': 10},
        {'name': '김세아', 'day': '목', 'startHour': 11, 'endHour': 12},
        {'name': '김세아', 'day': '목', 'startHour': 13, 'endHour': 15},
        {'name': '김세아', 'day': '목', 'startHour': 19, 'endHour': 24},
        {'name': '김세아', 'day': '금', 'startHour': 0, 'endHour': 15},
        {'name': '김세아', 'day': '금', 'startHour': 19, 'endHour': 24},
        {'name': '김세아', 'day': '토', 'startHour': 0, 'endHour': 12},
        {'name': '김세아', 'day': '토', 'startHour': 20, 'endHour': 24},
        // 오수진
        {'name': '오수진', 'day': '월', 'startHour': 0, 'endHour': 13},
        {'name': '오수진', 'day': '월', 'startHour': 14, 'endHour': 24},
        {'name': '오수진', 'day': '화', 'startHour': 0, 'endHour': 10},
        {'name': '오수진', 'day': '화', 'startHour': 11, 'endHour': 12},
        {'name': '오수진', 'day': '화', 'startHour': 13, 'endHour': 24},
        {'name': '오수진', 'day': '수', 'startHour': 0, 'endHour': 10},
        {'name': '오수진', 'day': '수', 'startHour': 11, 'endHour': 12},
        {'name': '오수진', 'day': '수', 'startHour': 13, 'endHour': 13},
        {'name': '오수진', 'day': '수', 'startHour': 14, 'endHour': 24},
        {'name': '오수진', 'day': '목', 'startHour': 0, 'endHour': 10},
        {'name': '오수진', 'day': '목', 'startHour': 11, 'endHour': 12},
        {'name': '오수진', 'day': '목', 'startHour': 13, 'endHour': 24},
        {'name': '오수진', 'day': '금', 'startHour': 0, 'endHour': 12},
        {'name': '오수진', 'day': '금', 'startHour': 13, 'endHour': 13},
        {'name': '오수진', 'day': '금', 'startHour': 14, 'endHour': 24},
        // 윤소윤
        {'name': '윤소윤', 'day': '월', 'startHour': 0, 'endHour': 10},
        {'name': '윤소윤', 'day': '월', 'startHour': 11, 'endHour': 12},
        {'name': '윤소윤', 'day': '월', 'startHour': 12, 'endHour': 24},
        {'name': '윤소윤', 'day': '화', 'startHour': 0, 'endHour': 10},
        {'name': '윤소윤', 'day': '화', 'startHour': 11, 'endHour': 24},
        {'name': '윤소윤', 'day': '수', 'startHour': 0, 'endHour': 10},
        {'name': '윤소윤', 'day': '수', 'startHour': 11, 'endHour': 24},
        {'name': '윤소윤', 'day': '목', 'startHour': 0, 'endHour': 10},
        {'name': '윤소윤', 'day': '목', 'startHour': 11, 'endHour': 12},
        {'name': '윤소윤', 'day': '목', 'startHour': 12, 'endHour': 24},
        {'name': '윤소윤', 'day': '금', 'startHour': 0, 'endHour': 11},
        {'name': '윤소윤', 'day': '금', 'startHour': 12, 'endHour': 14},
        {'name': '윤소윤', 'day': '금', 'startHour': 15, 'endHour': 24},
      ];

      // 선택된 팀원의 가용 시간 필터링
    List<Map<String, dynamic>> filteredAvailability = availability
        .where((member) => selectedMembers.contains(member['name']))
        .toList();

    // 시작 날짜와 종료 날짜 사이의 요일 구하기
    Set<String> daysOfWeek = {};
    DateTime currentDate = _startDate!;
    while (currentDate.isBefore(_endDate!.add(Duration(days: 1)))) {
      daysOfWeek.add(_getDayString(currentDate.weekday - 1));
      currentDate = currentDate.add(Duration(days: 1));
    }

    // 요일별 초기화
    availableTimes = {
      '월': List.generate(24, (index) => 0),
      '화': List.generate(24, (index) => 0),
      '수': List.generate(24, (index) => 0),
      '목': List.generate(24, (index) => 0),
      '금': List.generate(24, (index) => 0),
      '토': List.generate(24, (index) => 0),
      '일': List.generate(24, (index) => 0),
    };

    // 가용 시간 계산
    for (var member in filteredAvailability) {
      String day = member['day'];
      if (availableTimes.containsKey(day)) {
        int startHour = member['startHour'];
        int endHour = member['endHour'];

        for (int hour = startHour; hour < endHour; hour++) {
          availableTimes[day]![hour] += 1;
        }
      }
    }

    // 사용하지 않는 요일 제거
    availableTimes.removeWhere((key, value) => !daysOfWeek.contains(key));

    setState(() {});
  }
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
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 13, vertical: 10),
                child: Column(
                  children: [
                    SizedBox(
                      height: kToolbarHeight +
                          MediaQuery.of(context).padding.top +
                          10,
                    ),
                    Text(
                      '원하는 일정과 팀원을 선택해\n가능한 회의 날짜와 시간을 조회합니다',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: Color(0xFF404040),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    Text(
                      '최대 일주일까지 조회할 수 있습니다\n',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: Color(0xFF404040),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: 33,
                      child: Divider(
                        color: Color(0xff858585),
                        thickness: 1,
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () => _selectStartDate(context),
                          child: Container(
                            height: 40,
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 3),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(5),
                              color: Color(0xFFF5F5F5),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  _startDate != null
                                      ? '${_startDate!.toLocal()}'.split(' ')[0]
                                      : '날짜 선택',
                                  style: TextStyle(
                                    color: Color(0xFF404040),
                                    fontSize: 15,
                                  ),
                                ),
                                SizedBox(width: 6),
                                Icon(Icons.calendar_today,
                                    size: 16, color: Color(0xFF404040)),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text('부터'),
                        SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: () => _selectEndDate(context),
                          child: Container(
                            height: 40,
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 3),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(5),
                              color: Color(0xFFF5F5F5),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  _endDate != null
                                      ? '${_endDate!.toLocal()}'.split(' ')[0]
                                      : '날짜 선택',
                                  style: TextStyle(
                                    color: Color(0xFF404040),
                                    fontSize: 15,
                                  ),
                                ),
                                SizedBox(width: 6),
                                Icon(Icons.calendar_today,
                                    size: 16, color: Color(0xFF404040)),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text('까지'),
                      ],
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () => _selectMembers(context),
                          child: Container(
                            height: 40,
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 3),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(5),
                              color: Color(0xFFF5F5F5),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  _getSelectedMembersText(),
                                  style: TextStyle(
                                    color: Color(0xFF404040),
                                    fontSize: 14,
                                  ),
                                ),
                                SizedBox(width: 6),
                                Icon(Icons.person_outline_rounded,
                                    size: 18, color: Color(0xFF404040)),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text('와(과) 회의'),
                      ],
                    ),
                    SizedBox(height: 30),
                    GestureDetector(
                      onTap: _checkAvailableTimes,
                      child: Container(
                        alignment: Alignment.center,
                        height: 40,
                        width: 160,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                          color: Color(0xff858585),
                        ),
                        child: Text(
                          '가능한 회의 시간 찾기',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: 33,
                      child: Divider(
                        color: Color(0xff858585),
                        thickness: 1,
                      ),
                    ),
                    SizedBox(height: 10),
                    if (availableTimes.isNotEmpty)
                      _buildScheduleTable()
                    else
                      Center(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 80,
                            ),
                            Image.asset('assets/icon/no_list_icon.png'),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              '가능한 회의 시간이 없습니다',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Color(0xFF404040),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 8),
                            Text(
                              '인원 또는 일정을 다시 설정해주세요',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                                color: Color(0xFF404040),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 30,
                            )
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: DetailNavigationBar(
        currentIndex: 0,
        currentPage: MeetingTimePage,
      ),
    );
  }

  Widget _buildScheduleTable() {
    List<String> dateHeaders = [];
  if (_startDate != null && _endDate != null) {
    DateTime currentDate = _startDate!;
    while (currentDate.isBefore(_endDate!.add(Duration(days: 1)))) {
      dateHeaders.add('${currentDate.month}/${currentDate.day}');
      currentDate = currentDate.add(Duration(days: 1));
    }
  }
  return Column(
    children: [ Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(width: 47.75),
          for (String date in dateHeaders)
            SizedBox(
              width: 47.75,
              child: Text(
                date,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  color: Colors.black,
                ),
              ),
            ),
          for (int i = dateHeaders.length; i < 7; i++) 
            SizedBox(width: 47.75), 
        ],
      ),
      SizedBox(height: 4,),
      Container(
        width: MediaQuery.of(context).size.width - 28,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey, width: 0.5),
          color: Colors.white,
        ),
        child: Column(
          children: [
            Table(
              columnWidths: {
                0: FixedColumnWidth(47.75),
                for (int i = 1; i <= 7; i++) i: FixedColumnWidth(47.75),
              },
              children: [
                _buildTableHeader(),
                for (int hour = 0; hour < 24; hour++) _buildTableRow(hour, 24),
              ],
            ),
          ],
        ),
      ),
      SizedBox(height: 70,)
    ],
  );
}

Widget _buildTableCell(String text,
    {bool isContent = false,
    bool isTopLeft = false,
    bool isTopRight = false,
    bool isBottomLeft = false,
    bool isBottomRight = false,
    int members = 0}) {
  Color getColor(int members) {
    return members == selectedMembers.length
        ? Colors.grey.withOpacity(0.5)
        : Colors.white;
  }

  return Container(
    width: 47.75,
    height: 36,
    decoration: BoxDecoration(
      border: Border(
        top: BorderSide(color: Colors.grey, width: 0.5),
        left: BorderSide(color: Colors.grey, width: 0.5),
        right: BorderSide(color: Colors.grey, width: 0.5),
        bottom: BorderSide(color: Colors.grey, width: 0.5),
      ),
      borderRadius: BorderRadius.only(
        topLeft: isTopLeft ? Radius.circular(10) : Radius.zero,
        topRight: isTopRight ? Radius.circular(10) : Radius.zero,
        bottomLeft: isBottomLeft ? Radius.circular(10) : Radius.zero,
        bottomRight: isBottomRight ? Radius.circular(10) : Radius.zero,
      ),
      color: isContent ? getColor(members) : Colors.white,
    ),
    child: Center(
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Inter',
          fontWeight: isContent ? FontWeight.w400 : FontWeight.w600,
          fontSize: 12,
          color: isContent ? Colors.transparent : Colors.black,
        ),
      ),
    ),
  );
}

TableRow _buildTableHeader() {
  return TableRow(
    children: [
      _buildTableCell('', isTopLeft: true), // 왼쪽 상단 셀
      _buildTableCell('월'),
      _buildTableCell('화'),
      _buildTableCell('수'),
      _buildTableCell('목'),
      _buildTableCell('금'),
      _buildTableCell('토'),
      _buildTableCell('일', isTopRight: true), // 오른쪽 상단 셀
    ],
  );
}

TableRow _buildTableRow(int hour, int totalHours) {
  return TableRow(
    children: [
      _buildTableCell('$hour'.padLeft(2, '0'),
          isBottomLeft: hour == totalHours - 1),
      for (int day = 0; day < 7; day++)
        _buildTableCell(
          '',
          isContent: availableTimes.containsKey(_getDayString(day)),
          isBottomRight: hour == totalHours - 1 && day == 6,
          members: availableTimes[_getDayString(day)]?[hour] ?? 0,
        ),
    ],
  );
}

  String _getDayString(int dayIndex) {
    switch (dayIndex) {
      case 0:
        return '월';
      case 1:
        return '화';
      case 2:
        return '수';
      case 3:
        return '목';
      case 4:
        return '금';
      case 5:
        return '토';
      case 6:
        return '일';
      default:
        return '';
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
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => TeamSchedulePage(),
                transitionDuration: Duration(milliseconds: 500),
                transitionsBuilder: (_, a, __, c) =>
                    FadeTransition(opacity: a, child: c),
              ),
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
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => MemberSchedulePage(),
                transitionDuration: Duration(milliseconds: 500),
                transitionsBuilder: (_, a, __, c) =>
                    FadeTransition(opacity: a, child: c),
              ),
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
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => MeetingSchedulePage(),
                transitionDuration: Duration(milliseconds: 500),
                transitionsBuilder: (_, a, __, c) =>
                    FadeTransition(opacity: a, child: c),
              ),
            );
          },
        ),
      ],
      color: Colors.white,
    );
  }
}

class MultiSelectDialog extends StatefulWidget {
  final List<String> teamMembers;
  final List<String> selectedMembers;

  MultiSelectDialog({required this.teamMembers, required this.selectedMembers});

  @override
  _MultiSelectDialogState createState() => _MultiSelectDialogState();
}

class _MultiSelectDialogState extends State<MultiSelectDialog> {
  late List<String> _tempSelectedMembers;

  @override
  void initState() {
    super.initState();
    _tempSelectedMembers = List.from(widget.selectedMembers);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('회의할 팀원 선택'),
      content: SingleChildScrollView(
        child: ListBody(
          children: widget.teamMembers.map((member) {
            return CheckboxListTile(
              value: _tempSelectedMembers.contains(member),
              title: Text(member),
              controlAffinity: ListTileControlAffinity.leading,
              onChanged: (isChecked) {
                setState(() {
                  if (isChecked!) {
                    _tempSelectedMembers.add(member);
                  } else {
                    _tempSelectedMembers.remove(member);
                  }
                });
              },
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
          child: Text('취소'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        TextButton(
          child: Text('확인'),
          onPressed: () {
            Navigator.pop(context, _tempSelectedMembers);
          },
        ),
      ],
    );
  }
}
