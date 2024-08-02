import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:teaming/detail/archive/file_item.dart';
import 'package:teaming/detail/work/detail_work_assign_file.dart';
import 'package:teaming/detail/work/modify_work.dart';

class WorkDetailPage extends StatefulWidget {
  final Map<String, dynamic> task;
  final Function(Map<String, dynamic>) onUpdate;
  final List<String> teamMembers;
  final String currentUser;

  WorkDetailPage(
      {required this.task,
      required this.onUpdate,
      required this.teamMembers,
      required this.currentUser});

  @override
  _WorkDetailPageState createState() => _WorkDetailPageState();
}

class _WorkDetailPageState extends State<WorkDetailPage> {
  late Map<String, dynamic> task;
  late bool isTaskOwner;
  List<FileItem> selectedFiles = [];

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

  List<FileItem> sampleFiles = [
    FileItem(
      name: '최종 보고서.pptx',
      uploader: '김세아',
      uploadDate: DateTime(2024, 7, 28),
      size: '98MB',
    ),
    FileItem(
      name: '보고서 초안_수정.pptx',
      uploader: '김세아',
      uploadDate: DateTime(2024, 7, 2),
      size: '34MB',
    ),
    FileItem(
      name: '논문 파일 모음.zip',
      uploader: '윤소윤',
      uploadDate: DateTime(2024, 7, 1),
      size: '1GB',
    ),
    FileItem(
      name: '주제 조사 내용.pdf',
      uploader: '오수진',
      uploadDate: DateTime(2024, 6, 23),
      size: '5MB',
    ),
    FileItem(
      name: '수업 중 발표에 대한 안내문.pdf',
      uploader: '오수진',
      uploadDate: DateTime(2024, 6, 15),
      size: '1MB',
    ),
  ];

  @override
void initState() {
  super.initState();
  task = Map<String, dynamic>.from(widget.task);
 isTaskOwner = task['members'] != null && task['members'].contains(widget.currentUser);
}

  void _updateProgress(int progress) {
    setState(() {
      task['progress'] = progress;
    });
  }

  void _completeTask() {
    setState(() {
      task['progress'] = 100;
    });
    widget.onUpdate(task);
    Navigator.pop(context, task);
  }

  void _navigateToEditTask() async {
    final updatedTask = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ModifyWorkPage(
          task: task,
          onUpdate: (updatedTask) {
            setState(() {
              task = updatedTask;
            });
          },
          teamMembers: widget.teamMembers,
        ),
      ),
    );

    if (updatedTask != null) {
      setState(() {
        task = updatedTask;
      });
      widget.onUpdate(task);
    }
  }

  void _navigateToAssignFiles() async {
    final selectedFilesFromPage = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AssignWorkFilePage(files: sampleFiles),
      ),
    );

    if (selectedFilesFromPage != null) {
      setState(() {
        selectedFiles = selectedFilesFromPage;
      });
    }
  }

  Future<void> _downloadFile(String fileName) async {
    // 파일 다운로드 로직 구현
    print('Downloading $fileName');
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Color(0xff585858),
            ),
            onPressed: () {
              widget.onUpdate(task);
              Navigator.pop(context, task);
            },
          ),
          title: Text(
            '업무 상세',
            style: TextStyle(
              color: Color(0xff585858),
              fontFamily: 'Inter',
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
          ),
          centerTitle: true,
          actions: [
            if (isTaskOwner)
              Padding(
                padding: const EdgeInsets.only(right: 3),
                child: CupertinoButton(
                  onPressed: _navigateToEditTask,
                  child: Image.asset(
                    'assets/icon/pen_modify_icon.png',
                    height: 25,
                    width: 25,
                  ),
                ),
              ),
          ],
        ),
        body: Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white,
                Color.fromRGBO(240, 240, 240, 1),
              ],
            ),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 80),
                Text(
  task['title'] ?? 'No Title',
  style: TextStyle(
    fontFamily: 'Inter',
    fontSize: 31,
    fontWeight: FontWeight.bold,
    color: Color(0xff5A5A5A),
    letterSpacing: -1,
  ),
),
                SizedBox(height: 6),
                Text.rich(
                  TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                            text: '담당자 : ',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
  text: '${task['members']?.join(', ') ?? 'No Members'}',
),
                      ],
                      style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 15,
                          letterSpacing: -0.4,
                          color: Color(0xff5A5A5A))),
                ),
                Text.rich(
                  TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                            text: '설명 : ',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(text: '${task['description']}'),
                      ],
                      style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 15,
                          letterSpacing: -0.4,
                          color: Color(0xff5A5A5A))),
                ),
                SizedBox(height: 10),
                Text.rich(
                  TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                            text: '생성일 : ',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(text: '${task['startDate']}'),
                      ],
                      style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 15,
                          letterSpacing: -0.4,
                          color: Color(0xff5A5A5A))),
                ),
                Text.rich(
                  TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                            text: '마감일 : ',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(text: '${task['endDate']}'),
                      ],
                      style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 15,
                          letterSpacing: -0.4,
                          color: Color(0xff5A5A5A))),
                ),
                SizedBox(height: 60),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isTaskOwner ? '진행도 표시' : '업무 진행도',
                      style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff5A5A5A),
                          letterSpacing: -0.7),
                    ),
                    Text(
                      isTaskOwner
                          ? '업무 관리 탭에서 보여지는 진행도입니다'
                          : '담당자가 설정한 현재 업무의 진행도입니다',
                      style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff7C7C7C),
                          letterSpacing: -0.3),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '${task['progress']}%',
                      style: TextStyle(
                        fontSize: isTaskOwner ? 40 : 48,
                        fontFamily: 'Leferi',
                        fontWeight: FontWeight.bold,
                        color: Color(0xff5A5A5A),
                        letterSpacing: -1.4,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    if (isTaskOwner)
                      SliderTheme(
                        data: SliderThemeData(
                          overlayShape: SliderComponentShape.noOverlay,
                          trackHeight: 5,
                          thumbShape:
                              RoundSliderThumbShape(enabledThumbRadius: 7),
                          activeTrackColor: Color(0xff484848),
                          inactiveTrackColor: Color(0xffD2D2D2),
                          thumbColor: Color(0xff484848),
                        ),
                        child: Slider(
                          value: task['progress'].toDouble(),
                          min: 0,
                          max: 100,
                          divisions: 100,
                          onChanged: (value) {
                            _updateProgress(value.toInt());
                          },
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 60),
                SizedBox(
                  height: 30,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '업무 자료',
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff5A5A5A),
                            letterSpacing: -0.7),
                      ),
                      if (isTaskOwner)
                        IconButton(
                          onPressed: _navigateToAssignFiles,
                          icon: Image.asset(
                            'assets/icon/plus_icon.png',
                            height: 30,
                            width: 30,
                          ),
                          constraints: BoxConstraints(),
                          padding: EdgeInsets.zero,
                        )
                    ],
                  ),
                ),
                Text(
                  '해당 업무와 관련된 자료입니다',
                  style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff7C7C7C),
                      letterSpacing: -0.3),
                ),
                SizedBox(height: 13),
                if (selectedFiles.isEmpty)
                  Text(
                    '업무와 관련된 자료가 없습니다',
                    style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff484848),
                        letterSpacing: -0.3),
                  )
                else
                  Column(
                    children: selectedFiles.map((file) {
                      bool isExpired = file.uploadDate.isBefore(
                          DateTime.now().subtract(Duration(days: 30)));
                      return GestureDetector(
                        onTap: () => _downloadFile(file.name),
                        child: Row(
                          children: [
                            Container(
                              height: 30,
                              width: 300,
                              margin: EdgeInsets.symmetric(vertical: 5),
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                border: Border.all(color: Color(0xFFCCCCCC)),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    '${file.uploader}  ${DateFormat('yyyy.MM.dd').format(file.uploadDate)}  ${file.name}',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      letterSpacing: -0.2,
                                      color: Color(0xFF585454),
                                      decoration: isExpired
                                          ? TextDecoration.lineThrough
                                          : null,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    isExpired ? '' : file.size,
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 11,
                                      color: isExpired
                                          ? Color(0xFF585454)
                                          : Color(0xFFBBBBBB),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                SizedBox(
                  height: 100,
                )
              ],
            ),
          ),
        ),
      ),
      if (isTaskOwner)
        Positioned(
          left: 50,
          right: 50,
          bottom: 53,
          child: ElevatedButton(
            onPressed: _completeTask,
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Color.fromRGBO(84, 84, 84, 1),
              minimumSize: Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Text(
              '완료 처리하기',
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'Inter',
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
    ]);
  }
}
