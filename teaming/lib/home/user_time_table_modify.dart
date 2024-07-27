import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:teaming/login/information_widget.dart';
import 'package:teaming/popup_widget.dart';

class ScheduleEditPage extends StatefulWidget {
  const ScheduleEditPage({super.key});

  @override
  _ScheduleEditPageState createState() => _ScheduleEditPageState();
}

class _ScheduleEditPageState extends State<ScheduleEditPage> {
  final ScrollController _scrollController = ScrollController();
  OverlayEntry? _balloonOverlay;

  List<Map<String, dynamic>> schedules = [
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
  ];

  final Map<String, bool> _selectedDays = {
    '월': false,
    '화': false,
    '수': false,
    '목': false,
    '금': false,
    '토': false,
    '일': false,
  };

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _startHourController = TextEditingController();
  final TextEditingController _startMinuteController = TextEditingController();
  final TextEditingController _endHourController = TextEditingController();
  final TextEditingController _endMinuteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_removeBalloon);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_removeBalloon);
    _scrollController.dispose();
    _removeBalloon();
    super.dispose();
  }

  void _showBalloon(BuildContext context, TapDownDetails details,
      Map<String, dynamic> schedule) {
    _removeBalloon();
    final position = details.globalPosition;
    _balloonOverlay = OverlayEntry(
      builder: (context) => BalloonOverlay(
        position: position,
        onDelete: () {
          setState(() {
            schedules.remove(schedule);
          });
          _removeBalloon();
        },
      ),
    );
    Overlay.of(context).insert(_balloonOverlay!);
  }

  void _removeBalloon() {
    _balloonOverlay?.remove();
    _balloonOverlay = null;
  }


  void _showAddSchedulePopup(BuildContext context) {
    showGeneralDialog(
      barrierLabel: "Popup",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.3),
      transitionDuration: Duration(milliseconds: 300),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return Align(
          alignment: Alignment.center,
          child: Material(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            child: Container(
              width: 360, // 가로 길이를 줄임
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                    child: Column(
                      children: [
                        SizedBox(
                            width: 280,
                            child: buildTextFieldOnly('일정명을 입력해주세요',
                                controllerName: _titleController,
                                centerHintText: true)),
                        SizedBox(height: 10),
                        SizedBox(
                          width: 310,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ...['월', '화', '수', '목', '금', '토', '일'].map((day) {
                                return Column(
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          width: 25,
                                          height: 23,
                                          alignment: Alignment.center,
                                          child: StatefulBuilder(
                                            builder: (context, setState) {
                                              return Checkbox(
                                                activeColor: Color(0xff404040),
                                                value:
                                                    _selectedDays[day] ?? false,
                                                onChanged: (bool? value) {
                                                  setState(() {
                                                    _selectedDays[day] = value!;
                                                  });
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 2),
                                          child: Text(
                                            day,
                                            style: TextStyle(fontSize: 13),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              }),
                            ],
                          ),
                        ),
                        SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(width: 20),
                            buildShortTextField('00',
                                controllerName: _startHourController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(2),
                                ]),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: Text(':'),
                            ),
                            buildShortTextField('00',
                                controllerName: _startMinuteController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(2),
                                ]),
                            SizedBox(width: 10),
                            Text(' ~ '),
                            SizedBox(width: 10),
                            buildShortTextField('00',
                                controllerName: _endHourController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(2),
                                ]),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: Text(':'),
                            ),
                            buildShortTextField('00',
                                controllerName: _endMinuteController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(2),
                                ]),
                            SizedBox(width: 20),
                          ],
                        ),
                        SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                style: ElevatedButton.styleFrom(foregroundColor: Colors.grey,
                                  backgroundColor: Color(0xffD8D8D8),
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
                                  if (_titleController.text.isNotEmpty &&
                                      _selectedDays.containsValue(true) &&
                                      _startHourController.text.isNotEmpty &&
                                      _startMinuteController.text.isNotEmpty &&
                                      _endHourController.text.isNotEmpty &&
                                      _endMinuteController.text.isNotEmpty) {
                                        
                                    // 일정 추가 로직
                                    int startHour =
                                        int.parse(_startHourController.text);
                                    int startMinute =
                                        int.parse(_startMinuteController.text);
                                    int endHour =
                                        int.parse(_endHourController.text);
                                    int endMinute =
                                        int.parse(_endMinuteController.text);

                                    if (startHour >= 0 &&
                                        startHour <= 23 &&
                                        startMinute >= 0 &&
                                        startMinute <= 59 &&
                                        endHour >= 0 &&
                                        endHour <= 23 &&
                                        endMinute >= 0 &&
                                        endMinute <= 59 &&
                                        (startHour < endHour ||
                                            (startHour == endHour &&
                                                startMinute < endMinute))) {
                                      _selectedDays.forEach((day, selected) {
                                        if (selected) {
                                          setState(() {
                                            schedules.add({
                                              'name': '김세아',
                                              'day': day,
                                              'startHour': startHour,
                                              'startMinute': startMinute,
                                              'endHour': endHour,
                                              'endMinute': endMinute,
                                              'title': _titleController.text
                                            });
                                          });
                                        }
                                      });
                                      Navigator.of(context).pop();
                                    } 
                                  }
                                },
                                style: ElevatedButton.styleFrom(foregroundColor: Colors.white,
                                  backgroundColor:
                                      Color.fromRGBO(84, 84, 84, 1),
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
                  ),
                ],
              ),
            ),
          ),
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

  Widget _buildScheduleTable() {
    List<Map<String, dynamic>> filteredSchedule = schedules.toList();

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
              child: GestureDetector(
                onTapDown: (TapDownDetails details) {
                  _showBalloon(context, details, schedule);
                },
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
                        fontWeight: FontWeight.normal,
                        fontSize: 12,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ));
          }
        }
      }
    }

    return Center(
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
                          topLeft: Radius.circular(10),
                        ),
                      ),
                    ),
                    for (int i = 0; i < 7; i++)
                      Container(
                        width: 47.75,
                        height: 36,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 0.5),
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topRight:
                                i == 6 ? Radius.circular(10) : Radius.zero,
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
                          border: Border.all(color: Colors.grey, width: 0.5),
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            bottomLeft:
                                i == 23 ? Radius.circular(10) : Radius.zero,
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
                          border: Border.all(color: Colors.grey, width: 0.5),
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            bottomRight:
                                i == 23 ? Radius.circular(10) : Radius.zero,
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
    );
  }

  List<Widget> _buildEmptyCells() {
  List<Widget> cells = [];
  for (int hour = 0; hour < 24; hour++) {
    for (int minute = 0; minute < 60; minute += 15) {
      for (int day = 0; day < 7; day++) {
        cells.add(Positioned(
          left: (47.75 * (day + 1)).toDouble(),
          top: (36 * (hour * 4 + minute / 15 + 1)).toDouble(),
          width: 47.75.toDouble(),
          height: 36.toDouble(),
          child: GestureDetector(
            onTap: _removeBalloon,
            onLongPress: () {
              _showAddSchedulePopup(context);
            },
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
          ),
        ));
      }
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

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
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
          title: Text(
            '내 시간표 수정',
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w800,
              fontSize: 16,
              color: Color(0xFF404040),
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
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                SizedBox(
                  height:
                      kToolbarHeight + MediaQuery.of(context).padding.top + 3,
                ),
                Text(
                  '시간표에서 빈 부분을 길게 눌러\n일정을 추가할 수 있습니다',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    fontSize: 11,
                    color: Color(0xFF404040),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  '기존 일정을 길게 눌러 삭제할 수 있습니다',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    fontSize: 11,
                    color: Color(0xFF404040),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '에브리타임 시간표 URL',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff484848),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: buildTextFieldOnly('URL을 복사한 뒤 붙여넣어 주세요'),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.file_download_outlined),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                _buildScheduleTable(),
                SizedBox(
                  height: 90,
                )
              ],
            ),
          ),
        ),
      ),
      Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
              child: SizedBox(
                height: 80,
                width: double.infinity,
              ),
            ),
          )),
      Positioned(
        left: 50,
        right: 50,
        bottom: 30,
        child: ElevatedButton(
          onPressed: () {
            // 저장 버튼 눌렀을 때 처리할 코드
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromRGBO(84, 84, 84, 1),
            foregroundColor: Colors.white,
            disabledBackgroundColor:
                Color.fromARGB(255, 228, 228, 228).withOpacity(0.7),
            minimumSize: Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: Text(
            '저장하기',
            style: TextStyle(
              fontSize: 18,
              fontFamily: 'Inter',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    ]);
  }
}

class BalloonOverlay extends StatelessWidget {
  final Offset position;
  final VoidCallback onDelete;

  const BalloonOverlay({
    super.key,
    required this.position,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position.dx - 40,
      top: position.dy - 50,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: Color(0xff454545),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 5,
              ),
            ],
          ),
          child: GestureDetector(
            onTap: onDelete,
            child: Text(
              '삭제하기',
              style: TextStyle(color: Colors.white, fontSize: 13),
            ),
          ),
        ),
      ),
    );
  }
}
