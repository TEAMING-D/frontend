import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:teaming/detail/meeting_time.dart';
import 'package:teaming/detail/member_time_table.dart';
import 'package:teaming/detail/navigation_bar.dart';

class TeamSchedulePage extends StatefulWidget {
  const TeamSchedulePage({super.key});

  @override
  _TeamSchedulePageState createState() => _TeamSchedulePageState();
}

class _TeamSchedulePageState extends State<TeamSchedulePage> {
  OverlayEntry? _balloonOverlay;
  final ScrollController _scrollController = ScrollController();

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
                '팀 시간표',
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
      body: GestureDetector(
        onTap: _removeBalloon,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.white, Color.fromRGBO(138, 138, 138, 1)],
              ),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: kToolbarHeight + MediaQuery.of(context).padding.top,
                ),
                Text(
                  '수업 또는 기존 일정이 없는 시간을 바탕으로\n회의 가능한 시간을 보여줍니다',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: Color(0xFF404040),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: 33,
                  child: Divider(
                    color: Color(0xFF858585),
                    thickness: 1,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  '색상이 진할수록 더 많은 사람이 가능한 시간입니다\n터치하여 어떤 팀원이 가능한지 확인할 수 있습니다',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: Color(0xFF6B6969),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30),
                _buildScheduleTable(),
                SizedBox(height: 50,)
              ],
            ),
          ),
        ),
      ),
       bottomNavigationBar: DetailNavigationBar(
        currentIndex: 0,
        currentPage: TeamSchedulePage,
      ),
    );
  }

  Widget _buildScheduleTable() {
    return GestureDetector(
      onTapUp: (details) => _handleTap(details),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey, width: 0.5),
          color: Colors.white,
        ),
        child: Table(
          columnWidths: {
            0: FixedColumnWidth(47.75),
            1: FixedColumnWidth(47.75),
            2: FixedColumnWidth(47.75),
            3: FixedColumnWidth(47.75),
            4: FixedColumnWidth(47.75),
            5: FixedColumnWidth(47.75),
            6: FixedColumnWidth(47.75),
            7: FixedColumnWidth(47.75),
          },
          children: [
            _buildTableHeader(),
            for (int hour = 0; hour < 24; hour++) _buildTableRow(hour, 24),
          ],
        ),
      ),
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
      switch (members) {
        case 1:
          return Colors.grey.withOpacity(0.3);
        case 2:
          return Colors.grey.withOpacity(0.5);
        case 3:
          return Colors.grey.withOpacity(0.7);
        default:
          return Colors.white;
      }
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
        _buildTableCell('$hour'.padLeft(2, '0'), isBottomLeft: hour == totalHours - 1),
        for (int day = 0; day < 7; day++)
          _buildTableCell(
            '',
            isContent: true,
            isBottomRight: hour == totalHours - 1 && day == 6,
            members: availability
                .where((avail) =>
                    avail['day'] == _getDayString(day) &&
                    hour >= avail['startHour'] &&
                    hour < avail['endHour'])
                .length,
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

  void _showBalloon(BuildContext context, TapUpDetails details, List<String> members) {
    _removeBalloon(); // 기존 말풍선 제거

    final position = details.globalPosition;

    _balloonOverlay = OverlayEntry(
      builder: (context) => Positioned(
        left: position.dx - 40,
        top: position.dy - 50,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Text(
              members.join(', '),
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_balloonOverlay!);
  }

  void _removeBalloon() {
    _balloonOverlay?.remove();
    _balloonOverlay = null;
  }

  void _handleTap(TapUpDetails details) {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    Offset localPosition = renderBox.globalToLocal(details.globalPosition);

    // 스크롤 오프셋 보정
    double scrollOffset = _scrollController.offset;

    int day = ((localPosition.dx - 65) / 47.75).floor();
    int hour = ((localPosition.dy + scrollOffset - kToolbarHeight - MediaQuery.of(context).padding.top) / 36 - 5).floor();

    String dayString = _getDayString(day);
    List<String> members = availability
        .where((avail) =>
            avail['day'] == dayString &&
            hour >= avail['startHour'] &&
            hour < avail['endHour'])
        .map((avail) => avail['name'])
        .toList()
        .cast<String>();

    if (members.isNotEmpty) {
      _showBalloon(context, details, members);
    } else {
      _removeBalloon();
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
              MaterialPageRoute(
                  builder: (context) => MeetingTimePage()),
            );
          },
        ),
      ],
      color: Colors.white,
    );
  }
}



class Balloon extends StatelessWidget {
  final String text;
  final Offset position;

  const Balloon({super.key, required this.text, required this.position});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position.dx - 40,
      top: position.dy - 50,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Text(
            text,
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }
}
