import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:teaming/home/goodbye.dart';
import 'package:teaming/home/user_time_table_modify.dart';
import 'package:teaming/widget/textfield_widget.dart';
import 'package:teaming/login/login.dart';
import 'package:teaming/widget/popup_widget.dart';
import 'package:teaming/service/api_service.dart';

class UserInfoModifyPage extends StatefulWidget {
  final List<Map<String, dynamic>> projects;
  final Function(List<Map<String, dynamic>>) onDeleteProjects;

  const UserInfoModifyPage(
      {super.key, required this.projects, required this.onDeleteProjects});

  @override
  State<UserInfoModifyPage> createState() => _UserInfoModifyPageState();
}

// 토글 관련 API 없어 CustomSwitch 주석 처리

class _UserInfoModifyPageState extends State<UserInfoModifyPage> {
  final ApiService apiService = ApiService();
  // 변경 불가능한 부분의 상태변수
  String email = '';
  String username = '';

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController notionController =
      TextEditingController(text: "");
  final TextEditingController githubController =
      TextEditingController(text: "");
  final TextEditingController backupEmailController =
      TextEditingController(text: "");
  final TextEditingController discordController =
      TextEditingController(text: "");
  final TextEditingController schoolNameController =
      TextEditingController(text: "");
  final TextEditingController studentIdController =
      TextEditingController(text: "");
  final TextEditingController majorController = TextEditingController(text: "");
  final TextEditingController phoneNumber1Controller =
      TextEditingController(text: "");
  final TextEditingController phoneNumber2Controller =
      TextEditingController(text: "");
  final TextEditingController phoneNumber3Controller =
      TextEditingController(text: "");
  final TextEditingController birthYearController =
      TextEditingController(text: "");
  final TextEditingController birthMonthController =
      TextEditingController(text: "");
  final TextEditingController birthDayController =
      TextEditingController(text: "");
  final TextEditingController snsTypeController =
      TextEditingController(text: "");
  final TextEditingController snsAccountController =
      TextEditingController(text: "");

  // 토글 스위치 상태 변수들
  bool isNotionVisible = false;
  bool isGithubVisible = false;
  bool isBackupEmailVisible = false;
  bool isDiscordVisible = false;
  bool isMajorVisible = false;
  bool isPhoneNumberVisible = false;
  bool isBirthDateVisible = false;
  bool isSNSAccountVisible = false;

  List<AdditionalField> additionalFields = [];

  @override
  void initState() {
    super.initState();
    _fetchUserInfo();
  }

  Future<void> _fetchUserInfo() async {
    try {
      final userInfo = await apiService.getUserInfo();
      setState(() {
        // 서버에서 가져온 데이터로 컨트롤러 업데이트
        // 변경 불가능
        email = userInfo['data']['email'] ?? '';
        username = userInfo['data']['username'] ?? '';

        // 변경 가능
        schoolNameController.text = userInfo['data']['schoolName'] ?? '';
        studentIdController.text = userInfo['data']['schoolNum'] ?? '';
        majorController.text = userInfo['data']['major'] ?? '';

        if (userInfo['data'].containsKey('phoneNumber')) {
          final phoneNumber = userInfo['data']['phoneNumber'] ?? '';
          final phoneParts = phoneNumber.split('-');
          if (phoneParts.length == 3) {
            phoneNumber1Controller.text = phoneParts[0];
            phoneNumber2Controller.text = phoneParts[1];
            phoneNumber3Controller.text = phoneParts[2];
          }
        }

        if (userInfo['data'].containsKey('birth')) {
          final birthDate = userInfo['data']['birth'] ?? '';
          final birthParts = birthDate.split('-');
          if (birthParts.length == 3) {
            birthYearController.text = birthParts[0];
            birthMonthController.text = birthParts[1];
            birthDayController.text = birthParts[2];
          }
        }

        if (userInfo['data'].containsKey('sns')) {
          final sns = userInfo['data']['sns']?.split(' ') ?? ['', ''];
          if (sns.length >= 2) {
            snsTypeController.text = sns[0];
            snsAccountController.text = sns[1];
          } else {
            snsTypeController.text = '';
            snsAccountController.text = '';
          }
        }

        if (userInfo['data'].containsKey('collabTools')) {
          final collabTools = userInfo['data']['collabTools'];
          if (collabTools != null && collabTools.isNotEmpty) {
            final cleanCollabTools =
                collabTools.replaceAll(RegExp(r',\s*}'), '}');
            final Map<String, dynamic> toolsMap = jsonDecode(cleanCollabTools);
            additionalFields.clear();
            toolsMap.forEach((toolName, email) {
              additionalFields.add(
                AdditionalField(
                  toolNameController: TextEditingController(text: toolName),
                  emailController: TextEditingController(text: email),
                ),
              );
            });
          } else {
            additionalFields.clear(); // collabTools가 없을 경우 초기화
          }
        }
      });
    } catch (e) {
      _showErrorPopup(context, '사용자 정보를 불러오는 데 실패했습니다.');
    }
  }

  Widget buildToggleTextField(
      String label,
      String hintText,
      TextEditingController controller,
      bool toggleValue,
      Function(bool) onChanged) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              /* CustomSwitch(
                value: toggleValue,
                onChanged: onChanged,
              ), */
            ],
          ),
          buildTextFieldOnly(hintText, controllerName: controller),
        ],
      ),
    );
  }

  void addFields() {
    if (additionalFields.length < 5) {
      setState(() {
        additionalFields.add(
          AdditionalField(
            toolNameController: TextEditingController(),
            emailController: TextEditingController(),
          ),
        );
      });
    }
  }

  Future<void> _logout(BuildContext context) async {
    // final ApiService apiService = ApiService();

    try {
      // await apiService.logout(); // 로그아웃 API 호출 부분 주석 처리(서버 미완)
      final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
      await secureStorage.delete(key: 'accessToken'); // 토큰 삭제
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      _showErrorPopup(context, '로그아웃에 실패했습니다.');
    }
  }

  void _showChoicePopup(
      BuildContext context, String normalMessage, VoidCallback onConfirm,
      {String? boldMessage}) {
    showGeneralDialog(
      barrierLabel: "Popup",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.3),
      transitionDuration: Duration(milliseconds: 300),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return PopupChoiceWidget(
          normalMessage: normalMessage,
          boldMessage: boldMessage,
          onConfirm: onConfirm,
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(opacity: anim1, child: child);
      },
    );
  }

  void _showErrorPopup(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PopupWidget(message: message);
      },
    );
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

  Widget buildAdditionalField(int index) {
    final field = additionalFields[index];
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 82,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 3),
                      child: SizedBox(
                        height: 30,
                        child: TextField(
                          controller: field.toolNameController,
                          style: TextStyle(fontSize: 15, color: Colors.black),
                          textAlign: TextAlign.start,
                          decoration: InputDecoration(
                            hintText: '도구명',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 5),
                            hintStyle: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                color: Color(0xFF828282)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 3),
            child: SizedBox(
              height: 30,
              child: TextField(
                controller: field.emailController,
                style: TextStyle(fontSize: 15, color: Colors.black),
                decoration: InputDecoration(
                  hintText: '계정 이메일을 입력해주세요',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 5),
                  hintStyle: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                      color: Color(0xFF828282)),
                ),
              ),
            ),
          ),
          Divider(color: Color(0xFF828282), thickness: 1),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            flexibleSpace: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ),
            scrolledUnderElevation: 0,
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              '계정 관리',
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w800,
                fontSize: 16,
              ),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                padding: EdgeInsets.only(right: 5),
                onPressed: () {
                  _showChoicePopup(
                    context,
                    "로그아웃을 진행하시겠습니까?",
                    () async {
                      await _logout(context);
                    },
                    boldMessage: '로그아웃',
                  );
                },
                icon: Icon(
                  Icons.output_rounded,
                  color: Colors.black,
                ),
                constraints: BoxConstraints(),
              ),
              IconButton(
                padding: EdgeInsets.only(right: 10),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GoodbyePage(),
                    ),
                  );
                },
                icon: Icon(
                  Icons.delete_forever_outlined,
                  color: Colors.black,
                ),
                constraints: BoxConstraints(),
              )
            ],
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Column(
                children: [
                  SizedBox(
                    height: kToolbarHeight +
                        MediaQuery.of(context).padding.top -
                        10,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(45, 10, 50, 20),
                    child: OutlinedButton(
                      onPressed: () {
                        // 내 시간표 수정하기 버튼 눌렀을 때 처리할 코드
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ScheduleEditPage()),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        side: BorderSide(color: Color(0xFFCBCBCB)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '내 시간표 수정하기',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: Color(0xFF484848),
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 14,
                            color: Color(0xFF484848),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '계정 이메일',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Color(0xFF484848),
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            email.isEmpty ? 'email@sample.com' : email,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                              color: Color(0xFFA9A9A9),
                            ),
                          ),
                          SizedBox(height: 3),
                          Divider(color: Color(0xFF9C9C9C), thickness: 0),
                        ],
                      )),
                  // 유저 정보 수정 API에 비밀번호 수정 미구현
                  /*  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 50, vertical: 5),
                    child: buildTextField("계정 비밀번호", "변경 비밀번호를 입력하세요",
                        controllerName: passwordController),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 50, vertical: 5),
                    child: buildTextField("계정 비밀번호 확인", "변경 비밀번호를 입력하세요",
                        controllerName: confirmPasswordController),
                  ), */
                  SizedBox(
                    height: 50,
                  ),
                  buildToggleTextField("Notion", "계정 이메일을 입력해주세요",
                      notionController, isNotionVisible, (value) {
                    setState(() {
                      isNotionVisible = value;
                    });
                  }),
                  SizedBox(
                    height: 10,
                  ),
                  buildToggleTextField("Github", "계정 이메일을 입력해주세요",
                      githubController, isGithubVisible, (value) {
                    setState(() {
                      isGithubVisible = value;
                    });
                  }),
                  SizedBox(
                    height: 10,
                  ),
                  buildToggleTextField("E-mail", "계정 이메일을 입력해주세요",
                      backupEmailController, isBackupEmailVisible, (value) {
                    setState(() {
                      isBackupEmailVisible = value;
                    });
                  }),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 48),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '기타 협업 툴',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Color(0xFF484848),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.add_circle_outline,
                              color: Color(0xFF7D7D7D)),
                          onPressed: addFields,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 48),
                    child: Column(
                      children: additionalFields
                          .asMap()
                          .entries
                          .map((entry) => buildAdditionalField(entry.key))
                          .toList(),
                    ),
                  ),
                  SizedBox(
                    height: 65,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 50,
                      vertical: 5,
                    ),
                    child: buildTextField("학교명", "학교명을 입력해주세요",
                        controllerName: schoolNameController),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 50,
                      vertical: 5,
                    ),
                    child: buildTextField("학번", "학번을 입력해주세요",
                        controllerName: studentIdController),
                  ),
                  buildToggleTextField(
                      "전공", "주전공을 입력해주세요", majorController, isMajorVisible,
                      (value) {
                    setState(() {
                      isMajorVisible = value;
                    });
                  }),
                  SizedBox(
                    height: 65,
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 5,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '이름',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Color(0xFF484848),
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            username.isEmpty ? '이름 예시' : username,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                              color: Color(0xFFA9A9A9),
                            ),
                          ),
                          SizedBox(height: 3),
                          Divider(color: Color(0xFF9C9C9C), thickness: 0),
                        ],
                      )),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 50,
                      vertical: 5,
                    ),
                    child: buildPhoneTextField(
                      "전화번호",
                      "010",
                      "0000",
                      "0000",
                      phoneNumber1Controller,
                      phoneNumber2Controller,
                      phoneNumber3Controller,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 50,
                      vertical: 5,
                    ),
                    child: buildDateTextField(
                      "생년월일",
                      "YYYY",
                      "MM",
                      "DD",
                      controller1: birthYearController,
                      controller2: birthMonthController,
                      controller3: birthDayController,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 50, vertical: 5),
                    child: buildDivideTextField(
                      'SNS 계정',
                      'SNS 종류',
                      '계정 아이디를 입력해주세요',
                      snsTypeController,
                      snsAccountController,
                    ),
                  ),
                  SizedBox(
                    height: 100,
                  ),
                ],
              ),
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
            onPressed: () async {
              try {
                final collabToolsMap = {
                  for (var field in additionalFields)
                    field.toolNameController.text: field.emailController.text
                };
                final phone =
                    '${phoneNumber1Controller.text}-${phoneNumber2Controller.text}-${phoneNumber3Controller.text}';
                final userInfo = {
                  'email': email,
                  'username': username,
                  'schoolName': schoolNameController.text,
                  'schoolNum': studentIdController.text,
                  'major': majorController.text,
                  'phone': phone,
                  'birth':
                      '${birthYearController.text}-${birthMonthController.text.padLeft(2, '0')}-${birthDayController.text.padLeft(2, '0')}',
                  'sns':
                      '${snsTypeController.text} ${snsAccountController.text}',
                  'collabTools': jsonEncode(collabToolsMap),
                };
                await apiService.updateUserInfo(userInfo);
                showSuccessPopup(context, '정보가 성공적으로 수정되었습니다.', onConfirm: () {
                  Navigator.pop(context);
                });
              } catch (e) {
                _showErrorPopup(context, '사용자 정보 수정에 실패했습니다.');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromRGBO(84, 84, 84, 1),
              foregroundColor: Colors.white,
              disabledBackgroundColor:
                  Color.fromARGB(255, 228, 228, 228).withOpacity(0.7),
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
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class AdditionalField {
  final TextEditingController toolNameController;
  final TextEditingController emailController;
  bool isFieldVisible;

  AdditionalField({
    required this.toolNameController,
    required this.emailController,
    this.isFieldVisible = false,
  });
}

class CustomSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const CustomSwitch({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onChanged(!value);
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        width: 40.0,
        height: 20.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: value ? Color(0xFF484848) : Color(0xFFCBCBCB),
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: Duration(milliseconds: 250),
              curve: Curves.easeIn,
              top: 2.0,
              left: value ? 20.0 : 2.0,
              right: value ? 2.0 : 20.0,
              child: Container(
                width: 16.0,
                height: 16.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
