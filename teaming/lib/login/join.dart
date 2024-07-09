import 'package:flutter/material.dart';
import 'package:teaming/login/information_collab.dart';
import 'package:teaming/login/login.dart';

class JoinPage extends StatelessWidget {
  const JoinPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  height: 70,
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
                        text: "회원가입으로 TEAMING만의\n",
                        style: TextStyle(
                          fontFamily: 'Leferi',
                          fontWeight: FontWeight.w400,
                        )),
                    TextSpan(
                        text: "서비스를 경험",
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
                  child: TextField(
                    obscureText: true,
                    style: TextStyle(
                        fontFamily: 'Inter', fontSize: 15, color: Colors.black),
                    decoration: InputDecoration(
                      hintText: '비밀번호 확인',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                      hintStyle: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Color.fromRGBO(156, 156, 156, 1)),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () {
                    // 회원가입 처리 로직 추가
        
                    // 일단 화면 전환 처리
                    Navigator.pushAndRemoveUntil(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            CollaborationPage(),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                      ),
                      (Route<dynamic> route) => false, // 이전의 모든 화면을 제거합니다.
                    );
                  },
                  style: ElevatedButton.styleFrom(
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
                      '간편 회원가입',
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
                        // 네이버 회원가입 로직 추가
                      },
                      icon: Image.asset('assets/icon/naver_icon.png',
                          width: 33, height: 33),
                    ),
                    IconButton(
                      onPressed: () {
                        // 카카오톡 회원가입 로직 추가
                      },
                      icon: Image.asset('assets/icon/kakao_icon.png',
                          width: 33, height: 33),
                    ),
                    IconButton(
                      onPressed: () {
                        // 구글 회원가입 로직 추가
                      },
                      icon: Image.asset('assets/icon/google_icon.png',
                          width: 33, height: 33),
                    ),
                  ],
                ),
                Center(
                  child: TextButton(
                    onPressed: () {
                      // 로그인 페이지로 이동
                      Navigator.pushAndRemoveUntil(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) =>
                              LoginPage(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
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
                            )),
                        TextSpan(
                            text: "로그인",
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
    );
  }
}
