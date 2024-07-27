import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:teaming/login/information_widget.dart';

class ModifyProjectPage extends StatefulWidget {
  const ModifyProjectPage({super.key});

  @override
  _ModifyProjectPageState createState() => _ModifyProjectPageState();
}

class _ModifyProjectPageState extends State<ModifyProjectPage> {
  late TextEditingController projectNameController;
  late TextEditingController projectTypeController;
  late TextEditingController endYearController;
  late TextEditingController endMonthController;
  late TextEditingController endDayController;
  late TextEditingController teamMembersController = TextEditingController();

  late List<Map<String, String>> teamMembers;

  final int nowYear = int.parse(DateTime.now().toString().substring(0, 4));
  OverlayEntry? dropdownOverlayEntry;
  String selectedProjectType = '수업';
  final GlobalKey _textFieldKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    // 샘플 데이터를 초기화합니다.
    final project = {
  'name': '프로젝트명A',
  'members': [
    {'name': '김세아', 'status': ''},
    {'name': '오수진', 'status': ''},
    {'name': '윤소윤', 'status': ''}
  ],
  'class': '수업명A',
  'progress': 80,
  'startDate': '2024.03.04',
  'endDate': '2024.08.15',
};
    projectNameController =
        TextEditingController(text: project['name'] as String);
    projectTypeController =
        TextEditingController(text: project['class'] as String);
    selectedProjectType = '수업';
    endYearController = TextEditingController(
        text: (project['endDate'] as String).split('.')[0]);
    endMonthController = TextEditingController(
        text: (project['endDate'] as String).split('.')[1]);
    endDayController = TextEditingController(
        text: (project['endDate'] as String).split('.')[2]);
    teamMembers = List<Map<String, String>>.from(
  (project['members'] as List<dynamic>).map((member) => Map<String, String>.from(member)).toList()
);
  }

  void _addTeamMember(String member) {
    setState(() {
      teamMembers.add({'name': member, 'status': ''});
      teamMembersController.clear();
      removeDropdownOverlay();
    });
  }

  void _removeTeamMember(String member) {
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
                      "삭제 시 해당 팀원에게 알림이 가며,\n승인받아야만 정상 삭제됩니다",
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
                            style: ElevatedButton.styleFrom(foregroundColor: Colors.white,
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
                              setState(() {
                                teamMembers = teamMembers.map((m) {
                                  if (m['name'] == member) {
                                    return {
                                      'name': m['name']!,
                                      'status': '→ 탈퇴 요청 중'
                                    };
                                  }
                                  return m;
                                }).toList();
                              });
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

  void _modifyProject() {
    if (projectNameController.text.isNotEmpty &&
        selectedProjectType.isNotEmpty &&
        endYearController.text.isNotEmpty &&
        endMonthController.text.isNotEmpty &&
        endDayController.text.isNotEmpty) {
      final modifiedProject = {
        'name': projectNameController.text,
        'class': selectedProjectType,
        'endDate':
            '${endYearController.text}.${endMonthController.text}.${endDayController.text}',
        'members': teamMembers,
      };
      Navigator.pop(context, modifiedProject);
    } else {
      // 필수 입력 필드가 비어있을 경우 경고 메시지 표시
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
    // 키보드 사라지는 시간때문에 지연
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
            '팀 프로젝트 수정',
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '프로젝트명',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Color(0xFF484848),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                          child: TextField(
                            controller: projectNameController,
                            style: TextStyle(fontSize: 15, color: Colors.black),
                            decoration: InputDecoration(
                              hintText: '프로젝트 이름을 입력해주세요',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(vertical: 5),
                              hintStyle: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                fontSize: 15,
                                color: Color(0xFFA9A9A9),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 3),
                        Divider(color: Color(0xFF9C9C9C), thickness: 1),
                      ],
                    ),
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
                    buildDateTextField(
                        '마감 기한',
                        'YYYY',
                        'MM',
                        'DD',
                        controller1: endYearController,
                        controller2: endMonthController,
                        controller3: endDayController),
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
              '${member['name']} ${member['status']}',
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: Color(0xFF484848),
              ),
            ),
          ),
          if (member['status'] != '→ 탈퇴 요청 중')
            IconButton(
              icon: Icon(
                Icons.close,
                color: Color(0xFF484848),
              ),
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(),
            onPressed: () => _removeTeamMember(member['name']!),
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
          onPressed: _modifyProject,
          style: ElevatedButton.styleFrom(foregroundColor: Colors.white,
            backgroundColor: Color.fromRGBO(84, 84, 84, 1),
            minimumSize: Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: Text(
            '수정하기',
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

  Widget buildTextField(
      String labelText, String hintText, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: Color(0xFF484848),
          ),
        ),
        SizedBox(height: 2),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: Color(0xffa0a0a0),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(color: Color(0xffd2d2d2)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(color: Color(0xFF9C9C9C)),
            ),
          ),
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: Color(0xff404040),
          ),
        ),
      ],
    );
  }

  Widget buildShortTextField(String hintText, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text,
      List<TextInputFormatter>? inputFormatters}) {
    return SizedBox(
      width: 50,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
            fontSize: 15,
            color: Color(0xffa0a0a0),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 5),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
