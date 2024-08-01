import 'package:flutter/material.dart';
import 'package:teaming/login/textfield_widget.dart';

class GoodbyePage extends StatefulWidget {
  const GoodbyePage({super.key});

  @override
  State<GoodbyePage> createState() => _GoodbyePageState();
}

class _GoodbyePageState extends State<GoodbyePage> {
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    // 컨트롤러 해제
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          scrolledUnderElevation: 0,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            '회원 탈퇴',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
          ),
          centerTitle: true,
        ),
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
                          AssetImage('assets/goodbye_background.png'), // 배경 이미지
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
                                text: "TEAMING의 계정을\n",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              TextSpan(
                                text: "정말 삭제하시겠어요?",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: -0.5,
                                ),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            color: Colors.white,
                            height: 1.2,
                          ),
                        ),
                        SizedBox(height: 30),
                        SizedBox(
                          width: 33,
                          child: Divider(color: Colors.white, thickness: 1),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Text(
                          "탈퇴를 진행하시는 경우\n계정과 관련된 모든 정보가 삭제되며\n이후 해당 계정으로는\n모든 서비스 접근이 불가합니다",
                          style: TextStyle(
                            fontFamily: "Inter",
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "계속하시려면 아래에 계정 비밀번호를\n다시 한 번 입력해 주세요",
                          style: TextStyle(
                            fontFamily: "Inter",
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        SizedBox(
          height: 30,
          child: TextField(obscureText: true,
            controller: passwordController,
            style: TextStyle(fontSize: 15, color: Colors.white),
            textAlign: TextAlign.center,cursorColor: Colors.white,
            decoration: InputDecoration(
              hintText: "계정 비밀번호를 입력해주세요",
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 5),
              hintStyle: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                  color: Color(0xFFCDCDCD)), alignLabelWithHint: true,
            ),
          ),
        ),
        SizedBox(height: 3,),
        SizedBox(width: 280, child: Divider(color: Colors.white, thickness: 1,)),
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
            // 계정 탈퇴 로직 추가
          },
          style: ElevatedButton.styleFrom(foregroundColor: Colors.grey,
            backgroundColor: Colors.white,
            minimumSize: Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: Text(
            '탈퇴하기',
            style: TextStyle(
              fontSize: 18,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w900,
              color: Color.fromRGBO(84, 84, 84, 1),
            ),
          ),
        ),
      ),
    ]);
  }
}
