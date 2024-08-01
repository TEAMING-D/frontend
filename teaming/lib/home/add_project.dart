import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:teaming/textfield_widget.dart';

class AddProjectPage extends StatefulWidget {
  final Function(Map<String, dynamic>) onAddProject;

  const AddProjectPage({super.key, required this.onAddProject});

  @override
  _AddProjectPageState createState() => _AddProjectPageState();
}

class _AddProjectPageState extends State<AddProjectPage> {
  final projectNameController = TextEditingController();
  final projectTypeController = TextEditingController();
  final endYearController = TextEditingController();
  final endMonthController = TextEditingController();
  final endDayController = TextEditingController();
  final teamMembersController = TextEditingController();
  final List<String> teamMembers = [];

  final int nowYear = int.parse(DateTime.now().toString().substring(0, 4));
  OverlayEntry? dropdownOverlayEntry;
  String selectedProjectType = '수업';
  final GlobalKey _textFieldKey = GlobalKey();

  void _addTeamMember(String member) {
    setState(() {
      teamMembers.add(member);
      teamMembersController.clear();
      removeDropdownOverlay();
    });
  }

  void _removeTeamMember(String member) {
    setState(() {
      teamMembers.remove(member);
    });
  }

  void _createProject() {
    if (projectNameController.text.isNotEmpty &&
        selectedProjectType.isNotEmpty &&
        endYearController.text.isNotEmpty &&
        endMonthController.text.isNotEmpty &&
        endDayController.text.isNotEmpty) {
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
                width: 300,
                padding: EdgeInsets.all(11),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 18),
                      child: Column(
                        children: [
                          Text(
                            "프로젝트를 생성하시겠습니까?",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              color: Color(0xFF585454),
                              height: 1.2,
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            "각 팀원에게는 알림이 가며 개별적으로\n승인받아야 팀원으로 정상 등록됩니다",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: Color(0xFF585454),
                              height: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: Row(
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
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                if (int.parse(endYearController.text) <
                                    nowYear) {
                                  endYearController.text =
                                      DateTime.now().toString().substring(0, 4);
                                } else if (int.parse(endYearController.text) >
                                    2999) {
                                  endYearController.text =
                                      DateTime.now().toString().substring(0, 4);
                                }

                                if (endYearController.text.length < 4) {
                                  endYearController.text =
                                      DateTime.now().toString().substring(0, 4);
                                }

                                switch (int.parse(endMonthController.text)) {
                                  case (0 || > 12):
                                    endMonthController.text = DateTime.now()
                                        .toString()
                                        .substring(5, 7);
                                    break;
                                  case < 10:
                                    endMonthController.text =
                                        '0${endMonthController.text}';
                                    break;
                                }

                                switch (int.parse(endDayController.text)) {
                                  case (0 || > 31):
                                    endDayController.text = DateTime.now()
                                        .toString()
                                        .substring(8, 10);
                                    break;
                                  case < 10:
                                    endDayController.text =
                                        '0${endDayController.text}';
                                    break;
                                }

                                final newProject = {
                                  'name': projectNameController.text,
                                  'class': selectedProjectType,
                                  'endDate':
                                      '${endYearController.text}.${endMonthController.text}.${endDayController.text}',
                                  'members': teamMembers,
                                  'progress': 0,
                                  'startDate': DateTime.now()
                                      .toString()
                                      .substring(0, 10)
                                      .replaceAll('-', '.'),
                                };
                                widget.onAddProject(newProject);
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(foregroundColor: Colors.white,
                                backgroundColor: Color.fromRGBO(84, 84, 84, 1),
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
    } else {
      // 필수 입력 필드가 비어있을 경우 경고 메시지를 표시합니다.
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
                width: 300,
                padding: EdgeInsets.all(15),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 15),
                      child: Text(
                        "모든 입력란 기입이 필요합니다\n다시 한 번 확인해주세요",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: Color(0xFF585454),
                          height: 1.2,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(foregroundColor: Colors.white,
                              backgroundColor: Color.fromRGBO(84, 84, 84, 1),
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
  }

  void showDropdownOverlay() {
    // 키보드 사라지는 시간때문에 지연 걸어둠
    Future.delayed(Duration(milliseconds: 700), () {
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
                  color: Colors.transparent, //터치 이벤트 감지용
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
                      children: List.generate(5, (index) {
                        final member = '${teamMembersController.text}_$index';
                        return ListTile(
                          title: Text(member),
                          onTap: () {
                            _addTeamMember(member);
                          },
                        );
                      }),
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

  void handleSearch(BuildContext context) {
    if (teamMembersController.text.isNotEmpty) {
      FocusScope.of(context).unfocus();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        removeDropdownOverlay();
        showDropdownOverlay();
      });
    }
  }

  void removeDropdownOverlay() {
    dropdownOverlayEntry?.remove();
    dropdownOverlayEntry = null;
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
                    buildTextField(
                        '프로젝트명', '프로젝트 이름을 입력해주세요', controllerName: projectNameController),
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
                           controllerName:endYearController,
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
                           controllerName:endMonthController,
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
                           controllerName:endDayController,
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
                      children: teamMembers.map((member) {
                        return Container(
                          margin: EdgeInsets.only(top: 10),
                          padding: EdgeInsets.only(left: 15),
                          height: 35,
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
                                  member,
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    color: Color(0xFF484848),
                                  ),
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
          style: ElevatedButton.styleFrom(foregroundColor: Colors.white,
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
