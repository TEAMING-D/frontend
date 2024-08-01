import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:teaming/textfield_widget.dart';
import 'package:teaming/popup_widget.dart';

class AddMeetingPage extends StatefulWidget {
  const AddMeetingPage({super.key});

  @override
  _AddMeetingPageState createState() => _AddMeetingPageState();
}

class _AddMeetingPageState extends State<AddMeetingPage> {
  final TextEditingController titleController = TextEditingController();
  DateTime? startDate;
  DateTime? endDate;
  DateTime? _tempStartDate;
  DateTime? _tempEndDate;
  List<String> members = ['김세아', '오수진', '윤소윤'];
  List<String> selectedMembers = [];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
       onTap: () {
      FocusScope.of(context).unfocus();
    },
      child: Stack(children: [
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
              '회의 생성',
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
            child: Center(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height,
                  ),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildTextField('회의명', '회의명을 입력해주세요',
                              controllerName: titleController,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(20),
                              ]),
                          SizedBox(
                            height: 15,
                          ),
                          _buildDatePicker('회의 시작', '회의 날짜를 선택해주세요', (date) {
                            setState(() {
                              startDate = date;
                            });
                          }, selectedDate: startDate),
                          SizedBox(
                            height: 5,
                          ),
                          _buildDatePicker('회의 종료', '회의 날짜를 선택해주세요', (date) {
                            setState(() {
                              endDate = date;
                            });
                          }, selectedDate: endDate),
                          SizedBox(
                            height: 15,
                          ),
                          _buildMemberSelector(),
                          SizedBox(
                            height: 30,
                          )
                        ],
                      ),
                    ),
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
            onPressed: () {
              if (titleController.text.isEmpty) {
                _showPopup('회의명이 입력되지 않았습니다\n다시 한 번 확인해주세요');
              } else if (selectedMembers.length < 2) {
                _showPopup('팀원이 2명 이상 선택되어야 합니다\n다시 한 번 확인해주세요');
              } else if (startDate == null || endDate == null) {
                _showPopup('시작일 및 종료일이 선택되어야 합니다\n다시 한 번 확인해주세요');
              } else {
                Navigator.pop(context, {
                  'title': titleController.text,
                  'startDate': startDate,
                  'endDate': endDate,
                  'members': selectedMembers,
                });
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF535353),
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Text(
              '생성하기',
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ]),
    );
  }

  void _showPopup(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PopupWidget(message: message);
      },
    );
  }

  Widget _buildDatePicker(
      String label, String hint, Function(DateTime) onDateSelected,
      {DateTime? selectedDate}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: Color(0xFF484848),
          ),
        ),
        GestureDetector(
          onTap: () {
            DateTime initialDateTime = _getInitialDateTime(label, selectedDate);
            DateTime? minimumDate = _getMinimumDate(label);
            DateTime? maximumDate = _getMaximumDate(label);

            // Adjust initialDateTime to be within min and max bounds
            if (minimumDate != null && initialDateTime.isBefore(minimumDate)) {
              initialDateTime = minimumDate;
            }
            if (maximumDate != null && initialDateTime.isAfter(maximumDate)) {
              initialDateTime = maximumDate;
            }

            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              builder: (BuildContext builder) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(25.0)),
                  ),
                  height: MediaQuery.of(context).copyWith().size.height / 3,
                  child: Column(
                    children: [
                      Expanded(
                        child: CupertinoTheme(
                          data: CupertinoThemeData(
                            textTheme: CupertinoTextThemeData(
                              dateTimePickerTextStyle: TextStyle(
                                color: Color(0xFF404040), // 글자 색상 설정
                                fontSize: 16,
                              ),
                            ),
                          ),
                          child: CupertinoDatePicker(
                            initialDateTime: initialDateTime,
                            minimumDate: minimumDate,
                            maximumDate: maximumDate,
                            onDateTimeChanged: (DateTime newDate) {
                              setState(() {
                                if (label == '회의 시작') {
                                  _tempStartDate = newDate;
                                } else {
                                  _tempEndDate = newDate;
                                }
                              });
                            },
                            use24hFormat: true,
                            minuteInterval: 1,
                            mode: CupertinoDatePickerMode.dateAndTime,
                          ),
                        ),
                      ),
                      CupertinoButton(
                        child: Text(
                          '확인',
                          style: TextStyle(
                            color: Color(0xFF404040),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            if (label == '회의 시작') {
                              onDateSelected(_tempStartDate ?? initialDateTime);
                              _tempStartDate = null;
                            } else {
                              onDateSelected(_tempEndDate ?? initialDateTime);
                              _tempEndDate = null;
                            }   FocusScope.of(context).requestFocus(FocusNode());
                          });
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text(
              selectedDate != null
                  ? "${selectedDate.toLocal()}".split(' ')[0] +
                      ' ' +
                      selectedDate
                          .toLocal()
                          .toString()
                          .split(' ')[1]
                          .substring(0, 5)
                  : hint,
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                fontSize: 15,
                color:
                    startDate != null ? Color(0xFF484848) : Color(0xFFA9A9A9),
              ),
            ),
          ),
        ),
        Divider(height: 1, color: Color(0xFF9C9C9C)),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }

  DateTime _getMinimumDate(String label) {
    if (label == '회의 종료' && startDate != null) {
      return startDate!;
    }
    return DateTime(1900); // 최소값 설정, 필요한 경우 조정 가능
  }

  DateTime _getMaximumDate(String label) {
    if (label == '회의 시작' && endDate != null) {
      return endDate!;
    }
    return DateTime(2100); // 최대값 설정, 필요한 경우 조정 가능
  }

  DateTime _getInitialDateTime(String label, DateTime? selectedDate) {
    if (label == '회의 시작' && endDate != null) {
      if (selectedDate != null && selectedDate.isAfter(endDate!)) {
        return endDate!;
      }
    } else if (label == '회의 종료' && startDate != null) {
      if (selectedDate != null && selectedDate.isBefore(startDate!)) {
        return startDate!;
      }
    }
    return selectedDate ?? DateTime.now();
  }

  Widget _buildMemberSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '참여 팀원 지정',
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: Color(0xFF484848),
          ),
        ),
        SizedBox(height: 10),
        Column(
          children: members.map((member) {
            return CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              title: Text(
                member,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                  color: Colors.black,
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
              activeColor: Color(0xFF535353),
            );
          }).toList(),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
