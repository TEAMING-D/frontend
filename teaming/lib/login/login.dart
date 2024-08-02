import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:teaming/login/join.dart';
import 'package:teaming/popup_widget.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../model/login_dto.dart';
import '../service/api_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final ApiService apiService = ApiService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  bool isChecked = false;
  bool _isPasswordVisible = false;

  Future<void> _login() async {
    String? emailError = _validateEmail(emailController.text);
    String? passwordError = _validatePassword(passwordController.text);

    if (emailError != null) {
      _showPopup(emailError);
      return;
    }

    if (passwordError != null) {
      _showPopup(passwordError);
      return;
    }

    final email = emailController.text;
    final password = passwordController.text;

    print("Login Email: $email");
    print("Login Password: $password");

    try {
      final response = await apiService.login(email, password);

      // 로그인 상태 유지 체크박스가 체크된 경우 토큰 저장
      if (isChecked) {
        await secureStorage.write(key: 'accessToken', value: response.token);
        await secureStorage.write(
            key: 'tokenDate', value: DateTime.now().toIso8601String());
      }

      // 로그인 성공 처리
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/teamProjects',
        (Route<dynamic> route) => false,
        arguments: {
          'projects': [
            {
              'name': '프로젝트명A',
              'members': ['김세아', '오수진', '윤소윤'],
              'class': '수업명A',
              'progress': 80,
              'startDate': '2024.03.04',
              'endDate': '2024.08.15',
            },
            {
              'name': '프로젝트명B',
              'members': [
                '김세아',
                '오수진',
                '윤소윤',
                '황익명',
                '박익명',
                '김익명',
                '이익명',
                '장익명'
              ],
              'class': '수업명B',
              'progress': 45,
              'startDate': '2024.01.13',
              'endDate': '2024.07.20',
            },
            {
              'name': '프로젝트명C',
              'members': ['김세아', '박익명', '최익명'],
              'class': '대회명A',
              'progress': 100,
              'startDate': '2023.12.13',
              'endDate': '2024.05.23',
            },
            {
              'name': '프로젝트명D',
              'members': ['김세아', '이익명'],
              'class': '수업명C ',
              'progress': 20,
              'startDate': '2023.08.15',
              'endDate': '2024.02.21',
            },
            {
              'name': '프로젝트명E',
              'members': ['김세아', '이익명', '박익명'],
              'class': '대회명B',
              'progress': 95,
              'startDate': '2023.08.15',
              'endDate': '2023.12.21',
            },
            {
              'name': '프로젝트명F',
              'members': ['김세아', '박익명'],
              'class': '봉사명A',
              'progress': 20,
              'startDate': '2023.06.25',
              'endDate': '2023.08.10',
            },
          ],
          'hasNotification': true,
        },
      );
    } catch (e) {
      _showPopup(('$e' == "type 'Null' is not a subtype of type 'String'") ? '아이디 또는 비밀번호를\n다시 한 번 확인해 주세요' : '로그인 실패\n' '$e');
    }
  }

  void _showPopup(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PopupWidget(message: message);
      },
    );
  }

  String? _validateEmail(String? value) {
    final emailRegExp = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (value == null || value.isEmpty) {
      return '이메일을 입력해주세요.';
    } else if (!emailRegExp.hasMatch(value)) {
      return '유효한 이메일을 입력해주세요.';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    final passwordRegExp = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');
    if (value == null || value.isEmpty) {
      return '비밀번호를 입력해주세요.';
    } else if (!passwordRegExp.hasMatch(value)) {
      return '비밀번호는 최소 8자, 하나 이상의 문자 및 숫자를 포함해야 합니다.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 30),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.center,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  Color.fromRGBO(138, 138, 138, 100),
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 100,
                  ),
                  Center(
                    child: Image.asset(
                      'assets/login_logo.png',
                    ),
                  ),
                  SizedBox(height: 90),
                  Text.rich(
                    TextSpan(children: [
                      TextSpan(
                          text: "로그인을 통해 더 쉽게\n",
                          style: TextStyle(
                            fontFamily: 'Leferi',
                            fontWeight: FontWeight.w400,
                          )),
                      TextSpan(
                          text: "팀 프로젝트를 관리",
                          style: TextStyle(
                            fontFamily: 'Leferi',
                            fontWeight: FontWeight.bold,
                          )),
                      TextSpan(
                          text: "해보세요",
                          style: TextStyle(
                            fontFamily: 'Leferi',
                            fontWeight: FontWeight.w400,
                          ))
                    ]),
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 18,
                      color: Color.fromRGBO(156, 156, 156, 1),
                      letterSpacing: -0.8,
                    ),
                  ),
                  SizedBox(height: 30),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: TextFormField(
                      autofocus: true,
                      controller: emailController,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'[0-9a-zA-Z@.]')),
                      ],
                      style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 15,
                          color: Colors.black),
                      decoration: InputDecoration(
                        hintText: '이메일',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 20),
                        hintStyle: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Color.fromRGBO(156, 156, 156, 1)),
                      ),
                      validator: _validateEmail,
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                  ),
                  SizedBox(height: 15),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: TextFormField(
                      controller: passwordController,
                      obscureText: !_isPasswordVisible,
                      style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 15,
                          color: Colors.black),
                      decoration: InputDecoration(
                        hintText: '비밀번호',
                        border: InputBorder.none,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 11),
                        hintStyle: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Color.fromRGBO(156, 156, 156, 1)),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Color.fromRGBO(156, 156, 156, 1),
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                          constraints: BoxConstraints(),
                          padding: EdgeInsets.zero,
                        ),
                      ),
                      validator: _validatePassword,
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                  ),
                  SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: emailController.text.isNotEmpty &&
                            passwordController.text.isNotEmpty
                        ? () {
                            _login();
                          }
                        : () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return PopupWidget(
                                    message: '이메일과 비밀번호를\n다시 한 번 확인해주세요');
                              },
                            );
                          },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Color.fromRGBO(84, 84, 84, 1),
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      '로그인',
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Checkbox(
                        value: isChecked,
                        activeColor: isChecked
                            ? Color.fromRGBO(84, 84, 84, 1)
                            : Colors.grey,
                        checkColor: Colors.white,
                        onChanged: (value) {
                          setState(() {
                            isChecked = value!;
                          });
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      Text(
                        '로그인 상태 유지하기',
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                            color: Color.fromRGBO(72, 72, 72, 1)),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 100,
                  ),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        // 회원가입 페이지로 이동
                        Navigator.pushAndRemoveUntil(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    JoinPage(),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              return FadeTransition(
                                opacity: animation,
                                child: child,
                              );
                            },
                          ),
                          (Route<dynamic> route) => false, // 이전의 모든 화면을 제거합니다.
                        );
                      },
                      child: Text.rich(
                        TextSpan(children: [
                          TextSpan(
                              text: "회원이 아니신가요? ",
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                              )),
                          TextSpan(
                              text: "회원가입",
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.bold,
                              )),
                        ]),
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 15,
                          color: Color.fromRGBO(72, 72, 72, 1),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
