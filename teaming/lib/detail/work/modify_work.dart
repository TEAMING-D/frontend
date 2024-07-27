import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:teaming/detail/work/team_work.dart';
import 'package:teaming/login/information_widget.dart';

// 현재 수정 기능 오류로 작동 안 하니까 서버랑 연결할 때 파일에 있는 기존 수정 기능 빼고 team_work.dart에서 initState할때 API 불러오기 방식으로 수정
class ModifyWorkPage extends StatefulWidget {
  final Map<String, dynamic> task;
  final Function(Map<String, dynamic>) onUpdate;
  final List<String> teamMembers;

  ModifyWorkPage(
      {required this.task, required this.onUpdate, required this.teamMembers});

  @override
  _ModifyWorkPageState createState() => _ModifyWorkPageState();
}

class _ModifyWorkPageState extends State<ModifyWorkPage> {
  late Map<String, dynamic> task;
  
  final taskNameController = TextEditingController();
  final taskDescriptionController = TextEditingController();
  final endYearController = TextEditingController();
  final endMonthController = TextEditingController();
  final endDayController = TextEditingController();
  List<String> selectedMembers = [];

  @override
  void initState() {
    super.initState();
      task = Map<String, dynamic>.from(widget.task);
    taskNameController.text = widget.task['title'];
    taskDescriptionController.text = widget.task['description'];
    selectedMembers = List<String>.from(widget.task['members']);
    var endDate = widget.task['endDate'].split('.');
    endYearController.text = endDate[0];
    endMonthController.text = endDate[1];
    endDayController.text = endDate[2];
    taskDescriptionController.addListener(() {
      setState(() {});
    });
  }

  void _updateTask() {
  final updatedTask = {
    'title': taskNameController.text,
    'description': taskDescriptionController.text,
    'endDate': '${endYearController.text}.${endMonthController.text}.${endDayController.text}',
    'members': selectedMembers,
    'progress': widget.task['progress'],
    'startDate': widget.task['startDate'],
  };
 widget.onUpdate(task); // 이 코드가 작업을 업데이트하도록 보장
  Navigator.pop(context, task); // 업데이트된 작업을 반환

  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      builder: (context) => TeamWorkPage(updatedTask: updatedTask),
    ),
    (Route<dynamic> route) => false,
  );
}

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Color(0xff585858),),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              '업무 수정',
              style: TextStyle(
                color: Color(0xff585858),
                fontFamily: 'Inter',
                fontWeight: FontWeight.w800,
                fontSize: 16,
              ),
            ),
            centerTitle: true,
          ),
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
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 80),
                      buildTextField(
                        '업무명',
                        '업무 이름을 입력해주세요',
                        controllerName: taskNameController,
                        inputFormatters: [LengthLimitingTextInputFormatter(10)],
                      ),
                      SizedBox(height: 20),
                      Text(
                        '업무 설명',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Color(0xFF484848),
                        ),
                      ),
                      SizedBox(height: 12),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: Color(0xFF484848),
                            width: 1,
                          ),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Stack(
                          children: [
                            TextField(
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: Colors.black,
                              ),
                              controller: taskDescriptionController,
                              textInputAction: TextInputAction.done,
                              onSubmitted: (value) {
                                FocusScope.of(context).unfocus();
                              },
                              maxLength: 35,
                              maxLines: null,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 13, horizontal: 8),
                                hintText: '업무 설명을 입력해주세요',
                                hintStyle: TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: Color(0xffa0a0a0),
                                ),
                                border: InputBorder.none,
                                counterText: '',
                              ),
                            ),
                            Positioned(
                              bottom: 5,
                              right: 0,
                              child: Text(
                                '${35 - taskDescriptionController.text.length}',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 13,
                                  color: Color(0xffa0a0a0),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 25),
                      Text(
                        '마감 기한',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Color(0xFF484848),
                        ),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Row(
                        children: [
                          buildShortTextField(
                            'YYYY',
                            controllerName: endYearController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(4),
                            ],
                            onSubmitted: (value) {
                              int currentYear = DateTime.now().year;
                              if (value.isEmpty ||
                                  int.parse(value) < currentYear ||
                                  int.parse(value) > currentYear + 20) {
                                endYearController.text = currentYear.toString();
                              }
                            },
                          ),
                          SizedBox(width: 20),
                          buildShortTextField(
                            'MM',
                            controllerName: endMonthController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(2),
                            ],
                            onSubmitted: (value) {
                              int currentMonth = DateTime.now().month;
                              if (value.isEmpty ||
                                  int.parse(value) < 1 ||
                                  int.parse(value) > 12) {
                                endMonthController.text =
                                    currentMonth.toString().padLeft(2, '0');
                              }
                            },
                          ),
                          SizedBox(width: 20),
                          buildShortTextField(
                            'DD',
                            controllerName: endDayController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(2),
                            ],
                            onSubmitted: (value) {
                              int currentDay = DateTime.now().day;
                              if (value.isEmpty ||
                                  int.parse(value) < 1 ||
                                  int.parse(value) > 31) {
                                endDayController.text =
                                    currentDay.toString().padLeft(2, '0');
                              }
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 25),
                      Text(
                        '업무 담당자 지정',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Color(0xFF484848),
                        ),
                      ),
                      SizedBox(height: 10),
                      Column(
                        children: widget.teamMembers.map<Widget>((member) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2.0),
                            child: CheckboxListTile(
                              title: Text(
                                member,
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 15,
                                  color: Color(0xFF484848),
                                ),
                              ),
                              value: selectedMembers.contains(member),
                              onChanged: (bool? value) {
                                setState(() {
                                  if (value == true) {
                                    selectedMembers.add(member);
                                  } else {
                                    selectedMembers.remove(member);
                                  }
                                });
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                              activeColor: Colors.grey[800],
                              contentPadding:
                                  EdgeInsets.only(left: 0, right: 0),
                              dense: true,
                              visualDensity: VisualDensity(vertical: -4),
                            ),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          left: 50,
          right: 50,
          bottom: 53,
          child: ElevatedButton(
            onPressed: _updateTask,
            style: ElevatedButton.styleFrom(foregroundColor: Colors.white,
              backgroundColor: Color.fromRGBO(84, 84, 84, 1),
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
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
