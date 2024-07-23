import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:teaming/login/information_widget.dart';

class AddWorkPage extends StatefulWidget {
  final Function(Map<String, dynamic>) onAddProject;
  final List<String> teamMembers;

  const AddWorkPage(
      {super.key, required this.onAddProject, required this.teamMembers});

  @override
  _AddWorkPageState createState() => _AddWorkPageState();
}

class _AddWorkPageState extends State<AddWorkPage> {
  final taskNameController = TextEditingController();
  final taskDescriptionController = TextEditingController();
  final endYearController = TextEditingController();
  final endMonthController = TextEditingController();
  final endDayController = TextEditingController();
  List<String> selectedMembers = [];

  @override
  void initState() {
    super.initState();
    taskDescriptionController.addListener(() {
      setState(() {});
    });
  }

  void _createTask() {
    if (taskNameController.text.isNotEmpty &&
        taskDescriptionController.text.isNotEmpty &&
        endYearController.text.isNotEmpty &&
        endMonthController.text.isNotEmpty &&
        endDayController.text.isNotEmpty) {
      final newTask = {
        'title': taskNameController.text,
        'description': taskDescriptionController.text,
        'endDate':
            '${endYearController.text}.${endMonthController.text}.${endDayController.text}',
        'members': selectedMembers,
      };
      widget.onAddProject(newTask);
      Navigator.pop(context);
    } else {
      // 필수 입력 필드가 비어있을 경우 경고 메시지를 표시합니다.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("모든 입력란을 채워주세요."),
        ),
      );
    }
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
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              '업무 생성',
              style: TextStyle(
                color: Colors.black,
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
                              textInputAction:
                                  TextInputAction.done,
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
                        children: widget.teamMembers.map((member) {
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
            onPressed: _createTask,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromRGBO(84, 84, 84, 1),
              minimumSize: Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Text(
              '생성하기',
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
