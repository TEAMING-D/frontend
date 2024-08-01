import 'package:flutter/material.dart';
import 'package:teaming/login/information_collab.dart';
import 'package:teaming/login/login.dart';
import 'package:teaming/popup_widget.dart';
import 'package:teaming/service/api_service.dart'; 
import 'package:teaming/model/sign_up_dto.dart';

class JoinPage extends StatefulWidget {
  const JoinPage({super.key});

  @override
  State<JoinPage> createState() => _JoinPageState();
}

class _JoinPageState extends State<JoinPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final ApiService apiService = ApiService();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  final SignUpRequest signUpRequest = SignUpRequest(
    username: '',
    phone: '',
    password: '',
    schoolName: '',
    schoolId: 0,
    email: '',
    major: '',
    gitId: '',
    notionMail: '',
    plusMail: '',
    birth: '',
    sns: '',
    collabTools: '{}', // JSON 문자열로 초기화
  );

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
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 100),
                    Center(
                      child: Image.asset(
                        'assets/login_logo.png',
                      ),
                    ),
                    SizedBox(height: 90),
                    Text.rich(
                      TextSpan(children: [
                        TextSpan(
                          text: "회원가입으로 TEAMING만의\n",
                          style: TextStyle(
                            fontFamily: 'Leferi',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        TextSpan(
                          text: "서비스를 경험",
                          style: TextStyle(
                            fontFamily: 'Leferi',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: "해보세요",
                          style: TextStyle(
                            fontFamily: 'Leferi',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
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
                        controller: emailController,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 15,
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          hintText: '이메일',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 20),
                          hintStyle: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Color.fromRGBO(156, 156, 156, 1),
                          ),
                        ),
                        validator: _validateEmail,
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
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          hintText: '비밀번호',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 11,
                          ),
                          hintStyle: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Color.fromRGBO(156, 156, 156, 1),
                          ),
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
                        controller: confirmPasswordController,
                        obscureText: !_isConfirmPasswordVisible,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 15,
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          hintText: '비밀번호 확인',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 11,
                          ),
                          hintStyle: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Color.fromRGBO(156, 156, 156, 1),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isConfirmPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Color.fromRGBO(156, 156, 156, 1),
                            ),
                            onPressed: () {
                              setState(() {
                                _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                              });
                            },
                            constraints: BoxConstraints(),
                            padding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    ElevatedButton(
                      onPressed: () {
                        if (_validateEmail(emailController.text) != null) {
                          _showPopup(_validateEmail(emailController.text)!);
                          return;
                        }

                        if (_validatePassword(passwordController.text) != null) {
                          _showPopup(_validatePassword(passwordController.text)!);
                          return;
                        }

                        if (passwordController.text != confirmPasswordController.text) {
                          _showPopup('비밀번호가 일치하지 않습니다.');
                          return;
                        }

                        signUpRequest.email = emailController.text;
                        signUpRequest.password = passwordController.text;

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CollabInfoPage(signUpRequest: signUpRequest),
                          ),
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
                        '회원가입',
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 100),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          // 로그인 페이지로 이동
                          Navigator.pushAndRemoveUntil(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation, secondaryAnimation) => LoginPage(),
                              transitionsBuilder: (context, animation, secondaryAnimation, child) {
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
                              text: "이미 회원이신가요? ",
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            TextSpan(
                              text: "로그인",
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
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
      ),
    );
  }
}
