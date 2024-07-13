import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Container(
                  //padding: EdgeInsets.symmetric(horizontal: 50),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image:
                          AssetImage('assets/welcome_background.png'), // 배경 이미지
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: "TEAMING에 가입하신 것을\n",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              TextSpan(
                                text: "환영합니다",
                                style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: -0.5,
                                ),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            color: Color(0xFF797979),
                            height: 1.2,
                          ),
                        ),
                        SizedBox(height: 30),
                        SizedBox(
                          width: 33,
                          child:
                              Divider(color: Color(0xFF858585), thickness: 1),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Text(
                          "기본적인 정보 입력과\n시간표 설정이 완료되었습니다",
                          style: TextStyle(
                            fontFamily: "Inter",
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            color: Color(0xff797979),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "앞으로 티밍과 함께 대학 팀플을\n쉽고 빠르게 관리해보세요!",
                          style: TextStyle(
                            fontFamily: "Inter",
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            color: Color(0xff797979),
                          ),
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      Positioned(
        left: 50,
        right: 50,
        bottom: 53,
        child: ElevatedButton(
          onPressed: () {
            // 메인 페이지 이동 로직 추가
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromRGBO(84, 84, 84, 1),
            minimumSize: Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: Text(
            '가입 완료',
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
