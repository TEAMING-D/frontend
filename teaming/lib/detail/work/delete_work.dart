import 'dart:ui';

import 'package:flutter/material.dart';

class DeleteWorkPage extends StatefulWidget {
  final List<Map<String, dynamic>> tasks;
  final String view;
  final Function(List<Map<String, dynamic>>) onDelete;

  DeleteWorkPage(
      {required this.tasks, required this.view, required this.onDelete});

  @override
  _DeleteWorkPageState createState() => _DeleteWorkPageState();
}

class _DeleteWorkPageState extends State<DeleteWorkPage> {
  List<bool> _selectedTasks = [];

  @override
  void initState() {
    super.initState();
    _selectedTasks = List<bool>.filled(widget.tasks.length, false);
    _selectedTasks = List<bool>.filled(widget.tasks.length * 2, false);
  }

  void _deleteSelectedTasks() {
    List<Map<String, dynamic>> updatedTasks = [];
    for (int i = 0; i < widget.tasks.length; i++) {
      if (!_selectedTasks[i]) {
        updatedTasks.add(widget.tasks[i]);
      }
    }

    setState(() {
      widget.onDelete(updatedTasks);
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Color(0xff585858)),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            '업무 삭제',
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w800,
              fontSize: 16,
              color: Color(0xFF404040),
            ),
          ),
          centerTitle: true,
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    Text(
                      '아래 업무 목록을 보고 삭제할 것들을 선택해주세요\n삭제 후 복구가 불가능하니 신중히 선택해주세요',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        color: Color(0xff404040),
                        letterSpacing: -0.4,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      '내가 참여 중인 업무만 삭제할 수 있습니다',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        color: Color(0xff404040),letterSpacing: -0.4,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              if (widget.view == '블록 형태로 보기')
                _buildBlockView()
              else
                _buildTimelineView(),
              SizedBox(height: 30),
            ],
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
                height: 103,
                width: double.infinity,
              ),
            ),
          )),
      Positioned(
        left: 50,
        right: 50,
        bottom: 53,
        child: ElevatedButton(
          onPressed:
              // selectedProjects.isEmpty ? null :
              _deleteSelectedTasks,
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
            '삭제하기',
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

  bool _isAllSelected = false;

  Widget _buildBlockView() {
    return Expanded(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                Checkbox(
                  value: _isAllSelected,
                  onChanged: (bool? value) {
                    setState(() {
                      _isAllSelected = value ?? false;
                      for (int i = 0; i < _selectedTasks.length; i++) {
                        _selectedTasks[i] = _isAllSelected;
                      }
                    });
                  },
                  activeColor: Colors.grey[700],
                ),
                Text(
                  '전체 선택하기',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff5A5A5A),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.only(bottom: 80),
              itemCount: widget.tasks.length,
              itemBuilder: (context, index) {
                var task = widget.tasks[index];
                var displayMembers = task['members'].length > 3
                    ? '${task['members'].take(3).join(', ')} 외 ${task['members'].length - 3}인'
                    : task['members'].join(', ');

                bool isCompleted = task['progress'] == 100;

                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    children: [
                      Checkbox(
                        value: _selectedTasks[index],
                        onChanged: (bool? value) {
                          setState(() {
                            _selectedTasks[index] = value ?? false;
                          });
                        },
                        activeColor: Colors.grey[700],
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isCompleted ? Color(0xff737373) : Colors.white,
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              task['title'],
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: isCompleted
                                    ? Colors.white
                                    : Color(0xff404040),
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '담당자: $displayMembers',
                              style: TextStyle(
                                fontSize: 14,
                                color: isCompleted
                                    ? Colors.white
                                    : Color(0xff808080),
                              ),
                            ),
                            SizedBox(height: 2),
                            SizedBox(
                              width: 250,
                              child: Text(
                                '설명: ${task['description']}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: isCompleted
                                      ? Colors.white
                                      : Color(0xff808080),
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              '기간: ${task['startDate']} ~ ${task['endDate']}',
                              style: TextStyle(
                                fontSize: 14,
                                color: isCompleted
                                    ? Colors.white
                                    : Color(0xff808080),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineView() {
    return Expanded(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '전체 선택하기',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff5A5A5A),
                  ),
                ),
                Checkbox(
                  value: _isAllSelected,
                  onChanged: (bool? value) {
                    setState(() {
                      _isAllSelected = value ?? false;
                      for (int i = 0; i < _selectedTasks.length; i++) {
                        _selectedTasks[i] = _isAllSelected;
                      }
                    });
                  },
                  activeColor: Colors.grey[700],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.only(bottom: 50),
              itemCount: widget.tasks.length,
              itemBuilder: (context, index) {
                var task = widget.tasks[index];
                var displayMembers = task['members'].length > 3
                    ? '${task['members'].take(3).join(', ')} 외 ${task['members'].length - 3}인'
                    : task['members'].join(', ');

                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [SizedBox(width: 15,),
                        SizedBox(
                          width: 70,
                          child: Text(
                            task['startDate'],
                            style: TextStyle(
                              color: Color(0xff808080),
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        SizedBox(width: 13),
                        Column(
                          children: [
                            SizedBox(height: 8,),
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: Color(0xff737373),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: Color(0xff737373),
                                  width: 2,
                                ),
                              ),
                            ),
                            if (index != widget.tasks.length - 1)
                              SizedBox(
                                width: 2,
                                height: 67,
                                child: CustomPaint(
                                  painter: DashedLinePainter(
                                    color: Color(0xff737373),
                                    isDashed: false,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        SizedBox(width: 13),
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      task['title'],
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff404040),
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      '담당자: $displayMembers',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Color(0xff808080),
                                      ),
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      '설명: ${task['description']}',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Color(0xff808080),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.zero,
                                height: 30,
                                width: 30,
                                child: Checkbox(
                                  value: _selectedTasks[index],
                                  onChanged: (bool? value) {
                                    setState(() {
                                      _selectedTasks[index] = value ?? false;
                                    });
                                  },
                                  activeColor: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ), SizedBox(width: 15,)
                      ],
                    ), SizedBox(height: 14,)
                  ],
                );
              },
            ),
          ),
          SizedBox(height: 50,)
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
