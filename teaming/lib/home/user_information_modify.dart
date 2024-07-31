import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:teaming/home/goodbye.dart';
import 'package:teaming/home/user_time_table_modify.dart';
import 'package:teaming/login/information_widget.dart';

class UserInfoModifyPage extends StatefulWidget {
  final List<Map<String, dynamic>> projects;
  final Function(List<Map<String, dynamic>>) onDeleteProjects;

  const UserInfoModifyPage(
      {super.key, required this.projects, required this.onDeleteProjects});

  @override
  State<UserInfoModifyPage> createState() => _UserInfoModifyPageState();
}

class _UserInfoModifyPageState extends State<UserInfoModifyPage> {
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController notionController =
      TextEditingController(text: "notionMail@gmail.com");
  final TextEditingController githubController =
      TextEditingController(text: "gitMail@gmail.com");
  final TextEditingController backupEmailController =
      TextEditingController(text: "backup@gmail.com");
  final TextEditingController discordController =
      TextEditingController(text: "discordMail@gmail.com");
  final TextEditingController schoolNameController =
      TextEditingController(text: "숙명여자대학교");
  final TextEditingController studentIdController =
      TextEditingController(text: "2012345");
  final TextEditingController majorController =
      TextEditingController(text: "IT공학전공");
  final TextEditingController phoneNumber1Controller =
      TextEditingController(text: "010");
  final TextEditingController phoneNumber2Controller =
      TextEditingController(text: "1234");
  final TextEditingController phoneNumber3Controller =
      TextEditingController(text: "5678");
  final TextEditingController birthYearController =
      TextEditingController(text: "2000");
  final TextEditingController birthMonthController =
      TextEditingController(text: "01");
  final TextEditingController birthDayController =
      TextEditingController(text: "01");
  final TextEditingController snsAccountController =
      TextEditingController(text: "@nickname");

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
              CustomSwitch(
                value: toggleValue,
                onChanged: onChanged,
              ),
            ],
          ),
          buildTextFieldOnly(hintText, controllerName: controller),
        ],
      ),
    );
  }

  void addFields() {
    if (additionalFields.length < 4) {
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
                    Divider(color: Color(0xFF828282), thickness: 1),
                  ],
                ),
              ),
              CustomSwitch(
                value: field.isFieldVisible,
                onChanged: (value) {
                  setState(() {
                    field.isFieldVisible = value;
                  });
                },
              ),
            ],
          ),
          SizedBox(height: 5),
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
                  Icons.output_rounded,
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
                            'main@gmail.com',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                              color: Color(0xFFA9A9A9),
                            ),
                          ),
                          SizedBox(height: 3),
                          Divider(color: Color(0xFF9C9C9C), thickness: 1),
                        ],
                      )),
                  Padding(
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
                  ),
                  SizedBox(
                    height: 65,
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
                   ),SizedBox(
                    height: 10,
                  ),
                  buildToggleTextField("Discord", "계정 이메일을 입력해주세요",
                      discordController, isDiscordVisible, (value) {
                    setState(() {
                      isDiscordVisible = value;
                    });
                  }),
                 
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
                            '김세아',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                              color: Color(0xFFA9A9A9),
                            ),
                          ),
                          SizedBox(height: 3),
                          Divider(color: Color(0xFF9C9C9C), thickness: 1),
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
                  buildToggleTextField("SNS 계정", "계정 아이디를 입력해주세요",
                      snsAccountController, isSNSAccountVisible, (value) {
                    setState(() {
                      isSNSAccountVisible = value;
                    });
                  }),
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
            onPressed: () {
              // 저장 버튼 눌렀을 때 처리할 코드
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
