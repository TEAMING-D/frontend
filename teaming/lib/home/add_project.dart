import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:teaming/widget/textfield_widget.dart';
import 'package:teaming/service/api_service.dart';
import 'package:teaming/widget/popup_widget.dart';

class AddProjectPage extends StatefulWidget {
  final Function(Map<String, dynamic>) onAddProject;

  const AddProjectPage({super.key, required this.onAddProject});

  @override
  _AddProjectPageState createState() => _AddProjectPageState();
}

class _AddProjectPageState extends State<AddProjectPage> {
  final ApiService apiService = ApiService();
  final projectNameController = TextEditingController();
  final projectTypeController = TextEditingController();
  final endYearController = TextEditingController();
  final endMonthController = TextEditingController();
  final endDayController = TextEditingController();
  final teamMembersController = TextEditingController();
  final List<Map<String, dynamic>> teamMembers = []; // 팀원 정보 리스트

  final int nowYear = int.parse(DateTime.now().toString().substring(0, 4));
  OverlayEntry? dropdownOverlayEntry;
  String selectedProjectType = '수업';
  final GlobalKey _textFieldKey = GlobalKey();

  void _addTeamMember(Map<String, dynamic> member) {
    // 중복 체크
    if (teamMembers.any(
        (existingMember) => existingMember['userId'] == member['userId'])) {
      showErrorPopup(context, '이미 추가된 팀원입니다.');
      return;
    }
    setState(() {
      teamMembers.add(member);
      teamMembersController.clear();
      removeDropdownOverlay();
    });
  }

  void _removeTeamMember(Map<String, dynamic> member) {
    setState(() {
      teamMembers.remove(member);
    });
  }

  Future<void> handleSearch(BuildContext context) async {
    if (teamMembersController.text.isNotEmpty) {
      try {
        final results = await apiService.searchUser(teamMembersController.text);
        if (results.isNotEmpty) {
          FocusScope.of(context).unfocus();
          WidgetsBinding.instance.addPostFrameCallback((_) {
            removeDropdownOverlay();
            showDropdownOverlay(results);
          });
        } else {
          showErrorPopup(context, '검색 결과가 없습니다.');
        }
      } catch (e) {
        showErrorPopup(context, '사용자 검색에 실패했습니다.');
      }
    }
  }

  void showDropdownOverlay(List<Map<String, dynamic>> results) {
    Future.delayed(Duration(milliseconds: 300), () {
      final renderBox =
          _textFieldKey.currentContext!.findRenderObject() as RenderBox;
      final size = renderBox.size;
      final offset = renderBox.localToGlobal(Offset.zero);

      dropdownOverlayEntry = OverlayEntry(
        builder: (context) => GestureDetector(
          onTap: () {
            removeDropdownOverlay();
          },
          child: Stack(
            children: [
              Positioned.fill(
                child: Container(
                  color: Colors.transparent, // 터치 이벤트 감지용
                ),
              ),
              Positioned(
                left: offset.dx,
                top: offset.dy + size.height + 5,
                width: size.width,
                child: Material(
                  elevation: 2.0,
                  child: Container(
                    color: Colors.white,
                    child: ListView(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      children: results.map((result) {
                        return ListTile(
                          title: Text(
                              '${result['username']} (${result['schoolName']}, ${result['schoolNum']})'),
                          onTap: () {
                            _addTeamMember(result);
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );

      Overlay.of(context).insert(dropdownOverlayEntry!);
    });
  }

  void removeDropdownOverlay() {
    dropdownOverlayEntry?.remove();
    dropdownOverlayEntry = null;
  }

  Future<void> _createProject() async {
    if (projectNameController.text.isNotEmpty &&
        selectedProjectType.isNotEmpty &&
        endYearController.text.isNotEmpty &&
        endMonthController.text.isNotEmpty &&
        endDayController.text.isNotEmpty) {
      final deadlineDate = DateTime(
        int.parse(endYearController.text),
        int.parse(endMonthController.text),
        int.parse(endDayController.text),
      );
      final today = DateTime.now();

      if (deadlineDate.isBefore(DateTime(today.year, today.month, today.day))) {
        endYearController.clear();
        endMonthController.clear();
        endDayController.clear();
        showErrorPopup(context, '오늘 이전의 날짜를 입력할 수 없습니다.');
        return;
      }

      /* showGeneralDialog(
        barrierLabel: "Popup",
        barrierDismissible: true,
        barrierColor: Colors.black.withOpacity(0.3),
        transitionDuration: Duration(milliseconds: 300),
        context: context,
        pageBuilder: (context, anim1, anim2) {
          return PopupChoiceWidget(
            normalMessage: "각 팀원에게는 알림이 가며 개별적으로\n승인받아야 팀원으로 정상 등록됩니다",
            onConfirm: () async {
              Navigator.of(context).pop();
              try {
                final newProject = {
                  'name': projectNameController.text,
                  'description': projectTypeController.text,
                  'type': selectedProjectType,
                  'deadline':
                      '${endYearController.text}-${endMonthController.text}-${endDayController.text}',
                  'members':
                      teamMembers.map((member) => member['userId']).toList(),
                };
                await apiService.createWorkspace(newProject);
                showSuccessPopup(context, '프로젝트가 성공적으로 생성되었습니다.',
                    onConfirm: () {
                  Navigator.pop(context);
                });
              } catch (e) {
                showErrorPopup(context, '프로젝트 생성에 실패했습니다.');
              }
            },
            boldMessage: "프로젝트를 생성하시겠습니까?",
          );
        },
        transitionBuilder: (context, anim1, anim2, child) {
          return FadeTransition(
            opacity: anim1,
            child: child,
          );
        },
      );
    }  */
      // 알림 API 미구현으로 일방적 유저 추가 및 화면 전환 진행
      String formatToTwoDigits(int number) {
        return number.toString().padLeft(2, '0');
      }

      try {
        final newProject = {
          'name': projectNameController.text,
          'description': projectTypeController.text,
          'type': selectedProjectType,
          'deadline':
              '${endYearController.text}-${formatToTwoDigits(int.parse(endMonthController.text))}-${formatToTwoDigits(int.parse(endDayController.text))}',
          'members': teamMembers.map((member) => member['userId']).toList(),
        };

        await apiService.createWorkspace(newProject);
        showSuccessPopup(context, '프로젝트가 성공적으로 생성되었습니다.', onConfirm: () {
          Navigator.pop(context);
        });
      } catch (e) {
        showErrorPopup(context, '프로젝트 생성에 실패했습니다.');
      }
    } else {
      // 필수 입력 필드가 비어있을 경우 경고 메시지 표시
      showGeneralDialog(
        barrierLabel: "Popup",
        barrierDismissible: true,
        barrierColor: Colors.black.withOpacity(0.3),
        transitionDuration: Duration(milliseconds: 300),
        context: context,
        pageBuilder: (context, anim1, anim2) {
          return PopupWidget(message: "모든 입력란 기입이 필요합니다\n다시 한 번 확인해주세요");
        },
        transitionBuilder: (context, anim1, anim2, child) {
          return FadeTransition(
            opacity: anim1,
            child: child,
          );
        },
      );
    }
  }

  void showSuccessPopup(BuildContext context, String message,
      {VoidCallback? onConfirm}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PopupWidget(
          message: message,
          onConfirm: onConfirm,
        );
      },
    );
  }

  void showErrorPopup(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PopupWidget(message: message);
      },
    );
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
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            '팀 프로젝트 생성',
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
                padding: const EdgeInsets.symmetric(horizontal: 70.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 130),
                    buildTextField('프로젝트명', '프로젝트 이름을 입력해주세요',
                        controllerName: projectNameController),
                    SizedBox(height: 16),
                    Text(
                      '프로젝트 유형',
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
                        SizedBox(
                          width: 80,
                          child: DropdownButtonFormField<String>(
                            isExpanded: true,
                            value: selectedProjectType,
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide:
                                    BorderSide(color: Color(0xffd2d2d2)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide:
                                    BorderSide(color: Color(0xFF9C9C9C)),
                              ),
                            ),
                            items: <String>['수업', '대회', '동아리', '기타']
                                .map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: StatefulBuilder(
                                  builder: (BuildContext context,
                                      StateSetter setState) {
                                    bool isSelected =
                                        selectedProjectType == value;
                                    return Container(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 10),
                                      color: isSelected
                                          ? Colors.grey[300]
                                          : Colors.transparent,
                                      child: Text(
                                        value,
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14,
                                          color: Color(0xff404040),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                selectedProjectType = newValue!;
                              });
                            },
                            selectedItemBuilder: (BuildContext context) {
                              return <String>['수업', '대회', '동아리', '기타']
                                  .map((String value) {
                                return Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    value,
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 13,
                                      color: Color(0xff404040),
                                    ),
                                  ),
                                );
                              }).toList();
                            },
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: Color(0xff404040),
                            ),
                            dropdownColor: Colors.white,
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          flex: 5,
                          child: Column(
                            children: [
                              SizedBox(
                                height: 30,
                                child: TextField(
                                  controller: projectTypeController,
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.symmetric(vertical: 5),
                                    hintText: '명칭을 입력해주세요',
                                    hintStyle: TextStyle(
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 15,
                                      color: Color(0xffa0a0a0),
                                    ),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              Divider(
                                color: Color(0xFF828282),
                                thickness: 1,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      '마감 기한',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: Color(0xFF484848),
                      ),
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
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        buildShortTextField(
                          'MM',
                          controllerName: endMonthController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(2),
                          ],
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        buildShortTextField(
                          'DD',
                          controllerName: endDayController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(2),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      '프로젝트 팀원',
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
                    Text('유저 본인은 기본적으로 해당 프로젝트에 추가됩니다', style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: Color.fromARGB(255, 141, 141, 141),
                      ),),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      key: _textFieldKey, // 추가된 부분
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.transparent,
                        border: Border.all(
                          color: Color(0xFF484848),
                          width: 1,
                        ),
                      ),
                      child: TextField(
                        controller: teamMembersController,
                        decoration: InputDecoration(
                          hintText: '이름으로 팀원 검색하기',
                          hintStyle: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Color(0xffa0a0a0),
                          ),
                          contentPadding: EdgeInsets.only(
                            left: 10,
                            bottom: 13,
                          ),
                          border: InputBorder.none,
                          suffixIcon: IconButton(
                            icon: Icon(
                              Icons.search,
                              color: Color(0xffa0a0a0),
                            ),
                            onPressed: () {
                              if (teamMembersController.text.isNotEmpty) {
                                handleSearch(context);
                              }
                            },
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints(),
                          ),
                        ),
                        onSubmitted: (value) {
                          if (value.isNotEmpty) {
                            handleSearch(context);
                          }
                        },
                        onTap: () {
                          removeDropdownOverlay();
                        },
                      ),
                    ),
                    Wrap(
                      children: teamMembers.toSet().map((member) {
                        final text =
                            '${member['username']} (${member['schoolName']}, ${member['schoolNum']})';
                        final textSpan = TextSpan(
                          text: text,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Color(0xFF484848),
                          ),
                        );
                        final textPainter = TextPainter(
                          text: textSpan,
                          maxLines: 2,
                          textDirection: TextDirection.ltr,
                        );
                        textPainter.layout(maxWidth: 230);

                        final numLines =
                            textPainter.computeLineMetrics().length;
                        final containerHeight = (numLines > 1) ? 50.0 : 40.0;

                        return Container(
                          margin: EdgeInsets.only(top: 10),
                          padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                          height: containerHeight,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Color(0xFFD1D1D1)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  text,
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    color: Color(0xFF484848),
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.close,
                                  color: Color(0xFF484848),
                                ),
                                padding: EdgeInsets.zero,
                                constraints: BoxConstraints(),
                                onPressed: () => _removeTeamMember(member),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 200),
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
          onPressed: _createProject,
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
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
    ]);
  }
}
