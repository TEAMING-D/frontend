import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
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
              Center(
                child: Image.asset(
                  'assets/login_logo.png',
                ),
              ),
              SizedBox(height: 94),
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
                child: TextField(
                  style: TextStyle(
                      fontFamily: 'Inter', fontSize: 15, color: Colors.black),
                  decoration: InputDecoration(
                    hintText: '이메일',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    hintStyle: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Color.fromRGBO(156, 156, 156, 1)),
                  ),
                ),
              ),
              SizedBox(height: 20),
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
                child: TextField(
                  obscureText: true,
                  style: TextStyle(
                      fontFamily: 'Inter', fontSize: 15, color: Colors.black),
                  decoration: InputDecoration(
                    hintText: '비밀번호',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    hintStyle: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Color.fromRGBO(156, 156, 156, 1)),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // 로그인 처리 로직 추가
                },
                style: ElevatedButton.styleFrom(
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
                    value: true,
                    activeColor: Color.fromRGBO(84, 84, 84, 1),
                    checkColor: Colors.white,
                    onChanged: (value) {
                      // 변수 추가해서 로그인 시 서버 처리 구현
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
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
              SizedBox(height: 80),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 28,
                    child: Divider(
                      color: Color.fromRGBO(84, 84, 84, 1),
                      thickness: 1,
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    '간편 로그인',
                    style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.normal,
                        fontSize: 12,
                        color: Color.fromRGBO(72, 72, 72, 1)),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  SizedBox(
                    width: 28,
                    child: Divider(
                      color: Color.fromRGBO(84, 84, 84, 1),
                      thickness: 1,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      // 네이버 로그인 로직 추가
                    },
                    icon: Image.asset('assets/icon/naver_icon.png',
                        width: 33, height: 33),
                  ),
                  IconButton(
                    onPressed: () {
                      // 카카오톡 로그인 로직 추가
                    },
                    icon: Image.asset('assets/icon/kakao_icon.png',
                        width: 33, height: 33),
                  ),
                  IconButton(
                    onPressed: () {
                      // 구글 로그인 로직 추가
                    },
                    icon: Image.asset('assets/icon/google_icon.png',
                        width: 33, height: 33),
                  ),
                ],
              ),
              Center(
                child: TextButton(
                  onPressed: () {
                    // 회원가입 페이지로 이동
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
    );
  }
}
