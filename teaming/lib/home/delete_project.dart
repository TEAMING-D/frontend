import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:teaming/widget/popup_widget.dart';
import 'package:teaming/service/api_service.dart';

class DeleteProjectPage extends StatefulWidget {
  final List<Map<String, dynamic>> projects;
  final Function(List<Map<String, dynamic>>) onDeleteProjects;

  const DeleteProjectPage(
      {super.key, required this.projects, required this.onDeleteProjects});

  @override
  _DeleteProjectPageState createState() => _DeleteProjectPageState();
}

class _DeleteProjectPageState extends State<DeleteProjectPage> {
  List<Map<String, dynamic>> selectedProjects = [];
  final ApiService apiService = ApiService();

  void _toggleProjectSelection(Map<String, dynamic> project) {
    setState(() {
      if (selectedProjects.contains(project)) {
        selectedProjects.remove(project);
      } else {
        selectedProjects.add(project);
      }
    });
  }

  Future<void> _deleteProjects() async {
    try {
      for (var project in selectedProjects) {
        await apiService.deleteWorkspace(project['id']);
      }
      widget.onDeleteProjects(selectedProjects);
      Navigator.pop(context);
      Navigator.pop(context);
    } catch (e) {
      print('프로젝트 삭제에 실패했습니다: $e');
      _showErrorDialog('프로젝트 삭제에 실패했습니다.');
    }
  }

  void _showErrorDialog(String message) {
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PopupWidget(
          message: message
        );
      },
    );
  }

  void _showDeleteConfirmationDialog() {
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
                    child: Text(
                      "삭제된 내용은 복구가 불가능합니다\n정말 삭제하시겠습니까?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
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
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.grey,
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
                              _deleteProjects();
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            scrolledUnderElevation: 0,
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              '팀 프로젝트 삭제',
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
            child: Column(
              children: [
                SizedBox(
                  height: kToolbarHeight + MediaQuery.of(context).padding.top -10,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        '아래 프로젝트 목록을 보고\n삭제하고 싶은 것들을 선택해주세요',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Color(0xFF585454),
                          height: 1.3,
                          wordSpacing: -0.2,
                        ),
                      ),SizedBox(height: 8,),Text(
                        '삭제 후 복구가 불가능하니 신중히 선택해주세요',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Color(0xFF585454),wordSpacing: -0.2,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Checkbox(
                        value:
                            selectedProjects.length == widget.projects.length,
                        onChanged: (value) {
                          setState(() {
                            if (value == true) {
                              selectedProjects = List.from(widget.projects);
                            } else {
                              selectedProjects.clear();
                            }
                          });
                        },
                        activeColor: Colors.grey[700],
                      ),
                      Text('전체 선택하기'),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView(
                          padding: EdgeInsets.fromLTRB(16, 10, 32, 120),
                          children: widget.projects.map((project) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 15.0),
                              child: Row(
                                children: [
                                  Checkbox(
                                    value: selectedProjects.contains(project),
                                    onChanged: (value) {
                                      _toggleProjectSelection(project);
                                    },
                                    activeColor: Colors.grey[700],
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: project['progress'] == 100
                                            ? Color(0xff737373)
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.15),
                                            spreadRadius: 4,
                                            blurRadius: 6,
                                            offset: Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(5),
                                        child: ListTile(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          tileColor:
                                              selectedProjects.contains(project)
                                                  ? Colors.grey[300]
                                                  : project['progress'] == 100
                                                      ? Color(0xff737373)
                                                      : Colors.white,
                                          title: Text(
                                            project['name'],
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.bold,
                                              color: project['progress'] == 100
                                                  ? Colors.white
                                                  : Color(0xff5A5A5A),
                                            ),
                                          ),
                                          subtitle: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(height: 8),
                                              Text(
                                                '팀원: ${project['members'].length <= 4 ? project['members'].join(', ') : '${project['members'].getRange(0, 3).join(', ')} 외 ${project['members'].length - 4}인'}',
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color:
                                                      project['progress'] == 100
                                                          ? Colors.white
                                                          : Color(0xff5A5A5A),
                                                ),
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                '수업: ${project['class']}',
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color:
                                                      project['progress'] == 100
                                                          ? Colors.white
                                                          : Color(0xff5A5A5A),
                                                ),
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                '기간: ${project['startDate']} ~ ${project['endDate']}',
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color:
                                                      project['progress'] == 100
                                                          ? Colors.white
                                                          : Color(0xff5A5A5A),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
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
                selectedProjects.isEmpty ? null : _showDeleteConfirmationDialog,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromRGBO(84, 84, 84, 1),
              foregroundColor: Colors.white,
              disabledBackgroundColor: Color.fromARGB(255, 228, 228, 228).withOpacity(0.7),
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
      ],
    );
  }
}
