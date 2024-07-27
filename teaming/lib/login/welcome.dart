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
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/teamProjects',
              (Route<dynamic> route) => false, // 모든 이전 화면 제거
              arguments: {
                // 샘플 데이터이므로 API 연결 시 제거
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
                ],'hasNotification': true,
              },
            );
          },
          style: ElevatedButton.styleFrom(foregroundColor: Colors.white,
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
