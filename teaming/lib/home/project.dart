import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:teaming/detail/time_table/time_table.dart';
import 'package:teaming/home/add_project.dart';
import 'package:teaming/home/delete_project.dart';
import 'package:teaming/home/notice.dart';
import 'package:teaming/home/user_information_modify.dart';
import 'package:teaming/service/api_service.dart';

class TeamProjectPage extends StatefulWidget {
  const TeamProjectPage({super.key});

  @override
  State<TeamProjectPage> createState() => _TeamProjectPageState();
}

class _TeamProjectPageState extends State<TeamProjectPage> {
  final ApiService apiService = ApiService();
  List<Map<String, dynamic>> projects = [];
  List<Map<String, String>> notifications = [];
  bool hasNotification = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchWorkspaces();
  }

  Future<void> _fetchWorkspaces() async {
    try {
      final workspaces = await apiService.getWorkspaces();
      setState(() {
        projects = workspaces;
        isLoading = false;
      });
    } catch (e) {
      // 에러 처리
      print('워크스페이스를 불러오는 데 실패했습니다: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _handleAccept(int index) {
    setState(() {
      notifications.removeAt(index);
    });
    Navigator.of(context).pop();
  }

  void _handleReject(int index) {
    setState(() {
      notifications.removeAt(index);
    });
    Navigator.of(context).pop();
  }

  void _addProject(Map<String, dynamic> newProject) {
    setState(() {
      projects.insert(0, newProject);
    });
  }

  void _updateProject(int index, Map<String, dynamic> updatedProject) {
    setState(() {
      projects[index] = updatedProject;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        leading: Builder(
          builder: (context) {
            return Padding(
              padding: const EdgeInsets.only(left: 10),
              child: IconButton(
                icon: hasNotification
                    ? Image.asset(
                        'assets/icon/alert_true_icon.png',
                        width: 28,
                        height: 28,
                      )
                    : Image.asset(
                        'assets/icon/alert_false_icon.png',
                        width: 28,
                        height: 28,
                      ),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
            );
          },
        ),
        actions: [
          if (projects.isNotEmpty)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.0),
              child: SizedBox(
                width: 33,
                height: 33,
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: Image.asset(
                    'assets/icon/minus_icon.png',
                    width: 33,
                    height: 33,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DeleteProjectPage(
                          projects: projects,
                          onDeleteProjects: (selectedProjects) {
                            setState(() {
                              projects.removeWhere((project) =>
                                  selectedProjects.contains(project));
                            });
                          },
                        ),
                      ),
                    ).then((value) {
                      _fetchWorkspaces();
                    });
                  },
                ),
              ),
            ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.0),
            child: SizedBox(
              width: 33,
              height: 33,
              child: CupertinoButton(
                padding: EdgeInsets.zero,
                child: Image.asset(
                  'assets/icon/plus_icon.png',
                  width: 33,
                  height: 33,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddProjectPage(
                        onAddProject: _addProject,
                      ),
                    ),
                  ).then((value) {
                    _fetchWorkspaces();
                  });
                },
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.0),
            child: SizedBox(
              width: 28,
              height: 28,
              child: CupertinoButton(
                padding: EdgeInsets.zero,
                child: Image.asset(
                  'assets/icon/user_icon.png',
                  width: 28,
                  height: 28,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserInfoModifyPage(
                        projects: projects,
                        onDeleteProjects: (selectedProjects) {
                          setState(() {
                            projects.removeWhere((project) =>
                                selectedProjects.contains(project));
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          SizedBox(
            width: 15,
          ),
        ],
        backgroundColor: Color.fromRGBO(255, 255, 255, 0.8),
      ),
      extendBodyBehindAppBar: true,
      drawer: NotificationDrawer(
        notifications: notifications,
        onAccept: _handleAccept,
        onReject: _handleReject,
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Container(
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
                child: isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.black),
                        ), // 로딩 인디케이터
                      )
                    : projects.isEmpty
                        ? Center(child: _buildEmptyView())
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SizedBox(
                                height: 115,
                              ),
                              Text(
                                '프로젝트별 진행도는 ‘완료된 업무 / 전체 업무’를 기준으로 표시됩니다',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xffA2A2A2),
                                  fontSize: 11,
                                ),
                                textAlign: TextAlign.end,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              _buildProjectListView(context),
                              SizedBox(
                                height: 30,
                              ),
                            ],
                          ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/icon/box_not_exist_icon.png'),
          SizedBox(
            height: 20,
          ),
          Text(
            '등록되어 있는 팀 프로젝트가 없습니다\n우측 상단의 + 아이콘을 눌러 등록해보세요',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectListView(BuildContext context) {
    return Column(
      children: projects.map((project) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TeamSchedulePage(),
              ),
            );
          },
          child: Container(
            width: MediaQuery.of(context).size.width - 20,
            margin: EdgeInsets.symmetric(vertical: 10),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color:
                  project['progress'] == 100 ? Color(0xff737373) : Colors.white,
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
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      project['name'],
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.2,
                        color: project['progress'] == 100
                            ? Colors.white
                            : Color(0xff5A5A5A),
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      project['members'] != null &&
                              project['members'].isNotEmpty
                          ? '팀원: ${project['members'].map((member) => member is Map<String, dynamic> ? member['username'] ?? 'null' : 'null').join(', ')}'
                          : '팀원: null',
                      style: TextStyle(
                        fontSize: 13,
                        color: project['progress'] == 100
                            ? Colors.white
                            : Color(0xff5A5A5A),
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      '${project['type']}: ${project['description']}',
                      style: TextStyle(
                        fontSize: 13,
                        color: project['progress'] == 100
                            ? Colors.white
                            : Color(0xff5A5A5A),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      project['progress'] == 100
                          ? '기간: ${project['startDate'] ?? DateTime.now().toString().split(' ')[0]} ~ ${project['endDate']}'
                          : '기간: ${project['startDate'] ?? DateTime.now().toString().split(' ')[0]} ~',
                      style: TextStyle(
                        fontSize: 13,
                        color: project['progress'] == 100
                            ? Colors.white
                            : Color(0xff5A5A5A),
                        letterSpacing: 0,
                      ),
                    ),
                  ],
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '${project['progress'] ?? 0}%\n',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Leferi',
                            color: project['progress'] == 100
                                ? Color(0xffEEEEEE)
                                : Color(0xffD6D6D6),
                            letterSpacing: -1,
                          ),
                        ),
                        TextSpan(
                          text: project['progress'] == 100
                              ? '완료된 프로젝트입니다'
                              : '${project['deadline']}까지',
                          style: TextStyle(
                            color: project['progress'] == 100
                                ? Color(0xffEEEEEE)
                                : Color(0xffD6D6D6),
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            fontSize: 13,
                            letterSpacing: -0.1,
                          ),
                        )
                      ],
                    ),
                    textAlign: TextAlign.end,
                    style: TextStyle(height: 1.25),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
