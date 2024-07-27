import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:teaming/detail/work/add_work.dart';
import 'package:teaming/detail/work/delete_work.dart';
import 'package:teaming/detail/work/detail_work.dart';
import 'package:teaming/detail/navigation_bar.dart';

class TeamWorkPage extends StatefulWidget {
final Map<String, dynamic>? updatedTask;

TeamWorkPage({this.updatedTask});

  @override
  _TeamWorkPageState createState() => _TeamWorkPageState();
}

class _TeamWorkPageState extends State<TeamWorkPage> {
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

 @override
  void initState() {
    super.initState();
    if (widget.updatedTask != null) {
      int index = tasks.indexWhere((t) => t['title'] == widget.updatedTask!['title']);
      if (index != -1) {
        setState(() {
          tasks[index] = widget.updatedTask!;
        });
      }
    }
  }


  String _selectedView = '블록 형태로 보기';

  void _addTask() {
    // 업무 추가 로직
  }

  void _deleteTask() {
    // 업무 삭제 로직
  }

  void _showDropdownMenu(BuildContext context) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        (MediaQuery.of(context).size.width / 4 * 3),
        position.dy + kToolbarHeight + 70,
        0,
        0,
      ),
      items: [
        (_selectedView == '타임라인 형태로 보기')
            ? PopupMenuItem(
                child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      '블록 형태로 보기',
                      textAlign: TextAlign.center,
                    )),
                onTap: () {
                  setState(() {
                    _selectedView = '블록 형태로 보기';
                  });
                },
              )
            : PopupMenuItem(
                child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      '타임라인 형태로 보기',
                      textAlign: TextAlign.center,
                    )),
                onTap: () {
                  setState(() {
                    _selectedView = '타임라인 형태로 보기';
                  });
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
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xff585858)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '업무 관리',
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w800,
            fontSize: 16,
            color: Color(0xFF404040),
          ),
        ),
        centerTitle: true,
        actions: [
          if (tasks.isNotEmpty)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.0),
              child: SizedBox(
                width: 33,
                height: 33,
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: Image.asset(
                    'assets/icon/minus_icon.png',
                    width: 33,
                    height: 33,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DeleteWorkPage(
                          tasks: tasks,
                          view: _selectedView,
                          onDelete: (updatedTasks) {
                            setState(() {
                              tasks = updatedTasks;
                            });
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.0),
            child: SizedBox(
              width: 33,
              height: 33,
              child: CupertinoButton(
                padding: EdgeInsets.zero,
                child: Image.asset(
                  'assets/icon/plus_icon.png',
                  width: 33,
                  height: 33,
                ),
                onPressed: () async {
                  final newTask = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddWorkPage(
                        onAddProject: (task) {
                          task['progress'] = 0;
                          task['startDate'] = DateTime.now()
                              .toString()
                              .substring(0, 10)
                              .replaceAll('-', '.');
                          setState(() {
                            tasks.insert(0, task);
                          });
                        },
                        teamMembers: ['김세아', '오수진', '윤소윤'],
                      ),
                    ),
                  );

                  if (newTask != null) {
                    newTask['progress'] = 0;
                    newTask['startDate'] = DateTime.now()
                        .toString()
                        .substring(0, 10)
                        .replaceAll('-', '.');
                    setState(() {
                      tasks.insert(0, newTask);
                    });
                  }
                },
              ),
            ),
          ),
          SizedBox(
            width: 8,
          )
        ],
        backgroundColor: Color.fromRGBO(255, 255, 255, 0.8),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 80),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                tasks.isEmpty
                    ? SizedBox()
                    : TextButton.icon(
                        icon: Icon(Icons.keyboard_arrow_down_outlined,
                            color: Colors.black),
                        onPressed: () => _showDropdownMenu(context),
                        label: Text(
                          _selectedView,
                          style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                              fontSize: 14),
                        ),
                        iconAlignment: IconAlignment.end,
                      ),
              ],
            ),
            Expanded(
              child: tasks.isEmpty ? _buildEmptyView() : _buildTaskView(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: DetailNavigationBar(
        currentIndex: 1,
        currentPage: TeamWorkPage,
      ),
    );
  }

  Widget _buildEmptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/icon/no_work_icon.png'),
          SizedBox(height: 20),
          Text(
            '등록되어 있는 업무가 없습니다\n우측 상단의 + 아이콘을 눌러 등록해보세요',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 15, color: Color(0xff797979), fontFamily: 'Inter'),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskView() {
    if (_selectedView == '블록 형태로 보기') {
      return _buildBlockView();
    } else {
      return _buildTimelineView();
    }
  }

  Widget _buildBlockView() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(
          bottom: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: tasks.map((task) {
            var displayMembers = task['members'].length > 3
                ? '${task['members'].take(3).join(', ')} 외 ${task['members'].length - 3}인'
                : task['members'].join(', ');

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WorkDetailPage(
                      task: task,
                      onUpdate: (updatedTask) {
                        setState(() {
                          int index = tasks.indexOf(task);
                          tasks[index] = updatedTask;
                        });
                      }, // 샘플로 작업
                      teamMembers: ['오수진', '윤소윤', '김세아'],
                      currentUser: '김세아',
                    ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  width: MediaQuery.of(context).size.width - 40,
                  margin: EdgeInsets.symmetric(vertical: 10),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: task['progress'] == 100
                        ? Color(0xff737373)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        spreadRadius: 4,
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            task['title'],
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.2,
                              color: task['progress'] == 100
                                  ? Colors.white
                                  : Color(0xff5A5A5A),
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            '담당자: $displayMembers',
                            style: TextStyle(
                              fontSize: 13,
                              color: task['progress'] == 100
                                  ? Colors.white
                                  : Color(0xff5A5A5A),
                            ),
                          ),
                          SizedBox(height: 2),
                          SizedBox(
                            width: 220,
                            child: Text(
                              '설명: ${task['description']}',
                              style: TextStyle(
                                fontSize: 13,
                                letterSpacing: -0.2,
                                color: task['progress'] == 100
                                    ? Colors.white
                                    : Color(0xff5A5A5A),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            task['progress'] == 100
                                ? '기간: ${task['startDate']} ~ ${task['endDate']}'
                                : '기간: ${task['startDate']} ~',
                            style: TextStyle(
                              fontSize: 13,
                              color: task['progress'] == 100
                                  ? Colors.white
                                  : Color(0xff5A5A5A),
                              letterSpacing: 0,
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: '${task['progress']}%\n',
                                style: TextStyle(
                                  fontSize: 38,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Leferi',
                                  color: task['progress'] == 100
                                      ? Color(0xffEEEEEE)
                                      : Color(0xffD6D6D6),
                                  letterSpacing: -1,
                                ),
                              ),
                              TextSpan(
                                text: task['progress'] == 100
                                    ? '완료된 업무입니다'
                                    : '${task['endDate']}까지',
                                style: TextStyle(
                                  color: task['progress'] == 100
                                      ? Color(0xffEEEEEE)
                                      : Color(0xffD6D6D6),
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 13,
                                  letterSpacing: -0.1,
                                ),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.end,
                          style: TextStyle(height: 1.25),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildTimelineView() {
    List<Map<String, dynamic>> timelineItems = [];

    for (var task in tasks) {
      timelineItems.add({
        'date': task['startDate'],
        'title': '${task['title']} 시작',
        'description': task['description'],
        'members': task['members'],
        'status': 'in-progress',
      });

      if (task['progress'] == 100) {
        timelineItems.add({
          'date': task['endDate'],
          'title': '${task['title']} 완료',
          'description': '완료',
          'members': task['members'],
          'status': 'completed',
        });
      } else {
        timelineItems.add({
          'date': task['endDate'],
          'title': '${task['title']} 완료 예정',
          'description': '완료 예정',
          'members': task['members'],
          'status': 'pending',
        });
      }
    }

// 날짜 내림차순 정렬
    timelineItems.sort((a, b) => b['date'].compareTo(a['date']));

    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 25,
          ),
          ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: timelineItems.length,
            itemBuilder: (context, index) {
              var item = timelineItems[index];
              var displayMembers = item['members'].length > 3
                  ? '${item['members'].take(3).join(', ')} 외 ${item['members'].length - 3}인'
                  : item['members'].join(', ');

              bool isPending = item['status'] == 'pending';
              bool hasDetails =
                  item['description'] != '완료' && item['description'] != '완료 예정';

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WorkDetailPage(
                        task: tasks.firstWhere(
                            (t) => t['title'] == item['title'].split(' ')[0]),
                        onUpdate: (updatedTask) {
                          setState(() {
                            int taskIndex = tasks.indexWhere(
                                (t) => t['title'] == updatedTask['title']);
                            tasks[taskIndex] = updatedTask;
                          });
                        },
                        // 샘플로 작업
                        teamMembers: ['오수진', '윤소윤', '김세아'],
                        currentUser: '김세아',
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: EdgeInsets.only(bottom: hasDetails ? 20 : 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 30,
                      ),
                      Container(
                        margin: EdgeInsets.only(top: hasDetails ? 4 : 0),
                        child: Column(
                          children: [
                            Text(
                              item['date'],
                              style: TextStyle(
                                color: isPending
                                    ? Color(0xffC1C1C1)
                                    : Color(0xff5A5A5A),
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10),
                      Column(
                        children: [
                          SizedBox(height: 7),
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color:
                                  isPending ? Colors.white : Color(0xff737373),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: isPending
                                    ? Color(0xffC1C1C1)
                                    : Color(0xff737373),
                                width: 2,
                              ),
                            ),
                          ),
                          if (index != timelineItems.length - 1)
                            SizedBox(
                              width: 2,
                              height: hasDetails ? 100 : 50,
                              child: CustomPaint(
                                painter: DashedLinePainter(
                                  color: isPending
                                      ? Color(0xffC1C1C1)
                                      : Color(0xff737373),
                                  isDashed: isPending,
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['title'],
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.bold,
                                letterSpacing: -0.2,
                                color: isPending
                                    ? Color(0xffC1C1C1)
                                    : Color(0xff5A5A5A),
                              ),
                            ),
                            if (hasDetails) ...[
                              SizedBox(height: 3),
                              Text(
                                '담당자: $displayMembers',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xff5A5A5A),
                                ),
                              ),
                              SizedBox(height: 2),
                              SizedBox(
                                width: 250,
                                child: Text(
                                  '설명: ${item['description']}',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Color(0xff5A5A5A),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }
}

class DashedLinePainter extends CustomPainter {
  final Color color;
  final bool isDashed;

  DashedLinePainter({required this.color, this.isDashed = false});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = color
      ..strokeWidth = 2;

    if (isDashed) {
      var max = size.height * 1.35;
      var dashWidth = 5;
      var dashSpace = 3;
      double startY = 0;

      while (startY < max) {
        canvas.drawLine(
            Offset(1, startY), Offset(1, startY + dashWidth), paint);
        startY += dashWidth + dashSpace;
      }
    } else {
      canvas.drawLine(Offset(1, 0), Offset(1, size.height * 1.35), paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
