import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:teaming/detail/navigation_bar.dart';

class ParticipationAnalysisPage extends StatefulWidget {
  final List<Map<String, dynamic>> tasks;
  final List<String> teamMembers;

  ParticipationAnalysisPage({required this.tasks, required this.teamMembers});

  @override
  _ParticipationAnalysisPageState createState() =>
      _ParticipationAnalysisPageState();
}

class _ParticipationAnalysisPageState extends State<ParticipationAnalysisPage> {
  Map<String, double> memberScores = {};
  Map<String, int> taskWeights = {};
  Map<String, Map<String, int>> memberWeights = {};
  String selectedMember = '';
  bool showBalloon = false;
  Offset touchPosition = Offset.zero;

ScrollController _scrollController = ScrollController();

@override
void initState() {
  super.initState();
  _initializeWeights();
  _calculateScores();
  _scrollController.addListener(() {
    if (showBalloon) {
      setState(() {
        showBalloon = false;
      });
    }
  });
}

@override
void dispose() {
  _scrollController.dispose();
  super.dispose();
}

  void _initializeWeights() {
    for (var task in widget.tasks) {
      taskWeights[task['title']] = 1;
      for (var member in task['members']) {
        if (!memberWeights.containsKey(task['title'])) {
          memberWeights[task['title']] = {};
        }
        memberWeights[task['title']]![member] = 1;
      }
    }
  }

  void _calculateScores() {
    memberScores.clear();
    for (var task in widget.tasks) {
      int taskWeight = taskWeights[task['title']]!;
      int totalMemberWeight = task['members']
          .map((member) => memberWeights[task['title']]![member]!)
          .reduce((a, b) => a + b);

      int duration = DateTime.parse(task['endDate'].replaceAll('.', '-'))
          .difference(DateTime.parse(task['startDate'].replaceAll('.', '-')))
          .inDays;
      double scorePerDay = taskWeight / totalMemberWeight;

      for (var member in task['members']) {
        int memberWeight = memberWeights[task['title']]![member]!;
        double memberScore = duration * scorePerDay * memberWeight;
        if (task['progress'] != 100) {
          memberScore *= task['progress'] / 100;
        }

        if (!memberScores.containsKey(member)) {
          memberScores[member] = 0;
        }
        memberScores[member] = memberScores[member]! + memberScore;
      }
    }
    setState(() {});
  }

  void _updateTaskWeight(String taskTitle, int weight) {
    if (weight < 1) weight = 1;
    if (weight > 9) weight = 9;
    setState(() {
      taskWeights[taskTitle] = weight;
      _calculateScores();
    });
  }

  void _updateMemberWeight(String taskTitle, String member, int weight) {
    if (weight < 1) weight = 1;
    if (weight > 9) weight = 9;
    setState(() {
      memberWeights[taskTitle]![member] = weight;
      _calculateScores();
    });
  }

    List<String> _getMemberTasks(String member) {
    List<String> tasks = [];
    for (var task in widget.tasks) {
      if (task['members'].contains(member)) {
        tasks.add(task['title']);
      }
    }
    return tasks;
  }


  @override
  Widget build(BuildContext context) {
    double totalScore = memberScores.isNotEmpty
        ? memberScores.values.reduce((a, b) => a + b)
        : 1.0;

    List<PieChartSectionData> sections = memberScores.entries.map((entry) {
      int index = memberScores.keys.toList().indexOf(entry.key);
      int colorIndex;
      if (memberScores.length <= 4) {
        colorIndex = 800 - index * 200;
      } else {
        colorIndex = 800 - index * 100;
      }
      Color backgroundColor = Colors.grey[colorIndex]!;
      Color textColor = colorIndex <= 500 ? Colors.black : Colors.white;

      return PieChartSectionData(
        value: entry.value,
        title:
            '${entry.key}\n${(entry.value / totalScore * 100).toStringAsFixed(1)}%',
        color: backgroundColor,
        radius: 150,
        titleStyle: TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              color: Colors.transparent,
            ),
          ),
        ),
        title: Text(
          '팀원 참여도 분석',
          style: TextStyle(
            color: Color(0xff404040),
            fontFamily: 'Inter',
            fontWeight: FontWeight.w800,
            fontSize: 16,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Color(0xff404040),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      extendBodyBehindAppBar: true,
      body: GestureDetector(
  onTap: () => setState(() => showBalloon = false),
  onTapDown: (TapDownDetails details) {
    setState(() {
      touchPosition = details.globalPosition;
    });
  },
  child: Stack( // Stack으로 변경
    children: [
      Container(
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
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              SizedBox(height: 70),
              Center(
                child: Text(
                  '업무 수행 기간과 담당자 인원을 고려해 평가합니다\n그래프를 터치하여 어떤 업무를 수행했는지 확인할 수 있습니다.',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    color: Color(0xff404040),
                    letterSpacing: -0.4,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 40),
                  SizedBox(
                    height: 300,
                    child: PieChart(
                      PieChartData(
                        sections: sections,
                        centerSpaceRadius: 0,
                        sectionsSpace: 0,
                        pieTouchData: PieTouchData(
  touchCallback: (FlTouchEvent event, pieTouchResponse) {
    setState(() {
      if (event is FlTapUpEvent) {
        final desiredSection = pieTouchResponse?.touchedSection;
        if (desiredSection != null && desiredSection.touchedSectionIndex != -1 && desiredSection.touchedSectionIndex < memberScores.length) {
          selectedMember = memberScores.keys.toList()[desiredSection.touchedSectionIndex];
          showBalloon = true;
          touchPosition = event.localPosition;
        }
      } else {
        showBalloon = false;
      }
    });
  },
),
                      ),
                    ),
                  ),
                  SizedBox(height: 50),
                  Text(
                    '가중치 설정',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Color(0xff5A5A5A),
                      letterSpacing: -0.4,
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    '업무 및 담당 팀원의 가중치 설정이 가능합니다.\n1~9 사이에서 가중치 비율을 설정해주세요.',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      color: Color(0xff838383),
                      letterSpacing: -0.4,
                    ),
                  ),
                  SizedBox(height: 10),
                  ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: widget.tasks.length,
                    itemBuilder: (context, index) {
                      String taskTitle = widget.tasks[index]['title'];
                      String taskDescription = widget.tasks[index]['description'];
                      List<String> members = widget.tasks[index]['members'];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 6),
                                  child: Icon(Icons.circle,
                                      size: 10, color: Color(0xff5A5A5A)),
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(taskTitle,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            fontFamily: 'Leferi',
                                            color: Color(0xff5A5A5A),
                                            letterSpacing: -0.3,
                                          )),
                                      SizedBox(height: 4),
                                      SizedBox(
                                        width: 210,
                                        child: Text(taskDescription,
                                            style: TextStyle(
                                              color: Color(0xff5A5A5A),
                                              fontSize: 13,
                                              letterSpacing: -0.3,
                                            )),
                                      ),
                                      SizedBox(height: 10),
                                      for (var member in members)
                                        members.length > 1
                                            ? SizedBox(
                                                height: 30,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Text('$member  · · ·  ',
                                                        style: TextStyle(
                                                          color: Color(0xff5A5A5A),
                                                          fontSize: 13,
                                                          letterSpacing: -0.3,
                                                          fontWeight: FontWeight.bold,
                                                        )),
                                                    DropdownButton<int>(
                                                      value: memberWeights[taskTitle]?[member] ?? 1,
                                                      items: List.generate(
                                                        9,
                                                        (i) => DropdownMenuItem<int>(
                                                          value: i + 1,
                                                          child: Text((i + 1).toString()),
                                                        ),
                                                      ),
                                                      onChanged: (value) {
                                                        if (value != null) {
                                                          _updateMemberWeight(taskTitle, member, value);
                                                        }
                                                      },
                                                      underline: SizedBox(),
                                                      icon: Icon(
                                                        Icons.keyboard_arrow_down_outlined,
                                                        color: Color(0xff5A5A5A),
                                                      ),
                                                      dropdownColor: Colors.white,
                                                      style: TextStyle(
                                                        color: Color(0xff5A5A5A),
                                                        fontSize: 13,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                      menuMaxHeight: 250,
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : Text('$member  · · ·  1',
                                                style: TextStyle(
                                                  color: Color(0xff5A5A5A),
                                                  fontSize: 13,
                                                  letterSpacing: -0.3,
                                                  fontWeight: FontWeight.bold,
                                                )),
                                    ],
                                  ),
                                ),
                                Column(
                                  children: [
                                    SizedBox(height: 10),
                                    SizedBox(
                                      height: 30,
                                      width: 83,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Color(0xff5F5F5F),
                                              borderRadius: BorderRadius.circular(30),
                                            ),
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  width: 25,
                                                  height: 25,
                                                  child: IconButton(
                                                    icon: Icon(Icons.remove, color: Colors.white, size: 13),
                                                    onPressed: () {
                                                      int currentWeight = taskWeights[taskTitle] ?? 1;
                                                      if (currentWeight > 1) {
                                                        _updateTaskWeight(taskTitle, currentWeight - 1);
                                                      }
                                                    },
                                                    padding: EdgeInsets.all(0),
                                                    constraints: BoxConstraints(),
                                                  ),
                                                ),
                                                Container(
                                                  width: 33,
                                                  height: 33,
                                                  alignment: Alignment.center,
                                                  padding: EdgeInsets.symmetric(horizontal: 12),
                                                  decoration: BoxDecoration(
                                                    color: Color(0xffD9D9D9),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Text(
                                                    taskWeights[taskTitle].toString(),
                                                    style: TextStyle(
                                                      color: Color(0xff5A5A5A),
                                                      fontSize: 14,
                                                      letterSpacing: -0.3,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 25,
                                                  height: 25,
                                                  child: IconButton(
                                                    icon: Icon(Icons.add, color: Colors.white, size: 13),
                                                    onPressed: () {
                                                      int currentWeight = taskWeights[taskTitle] ?? 1;
                                                      if (currentWeight < 9) {
                                                        _updateTaskWeight(taskTitle, currentWeight + 1);
                                                      }
                                                    },
                                                    padding: EdgeInsets.all(0),
                                                    constraints: BoxConstraints(),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
        if (showBalloon)
          Positioned(
            // 터치 위치 오프셋 조정
            left: touchPosition.dx + 30,
            top: touchPosition.dy + 80,
            child: GestureDetector(
              onTap: () => setState(() => showBalloon = false),
              child: Center(
                child: Card(color: Colors.white,
                elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _getMemberTasks(selectedMember)
                          .map((task) => Text( task,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          color: Color(0xff585454),
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                        ),
                      ))
                          .toList(),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    ),
  ), bottomNavigationBar: DetailNavigationBar(
        currentIndex: 1,
        currentPage: ParticipationAnalysisPage,
      ),
);

  }
}

class ParticipationData {
  final String member;
  final double score;

  ParticipationData({required this.member, required this.score});
}
