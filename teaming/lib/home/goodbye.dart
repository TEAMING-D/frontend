import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:teaming/login/login.dart';
import 'package:teaming/popup_widget.dart';
import 'package:teaming/service/api_service.dart';
import 'package:teaming/textfield_widget.dart';

class GoodbyePage extends StatefulWidget {
  const GoodbyePage({super.key});

  @override
  State<GoodbyePage> createState() => _GoodbyePageState();
}

class _GoodbyePageState extends State<GoodbyePage> {
  final ApiService apiService = ApiService();
  
  Future<void> _deleteAccount() async {
    try {
      await apiService.deleteAccount();
      const FlutterSecureStorage secureStorage = FlutterSecureStorage();
      await secureStorage.delete(key: 'accessToken'); // 토큰 삭제
      _showSuccessPopup('탈퇴에 성공했습니다.');
    } catch (e) {
      _showErrorPopup('탈퇴 처리에 실패했습니다.');
    }
  }

  void _showErrorPopup(String message) {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // 바깥 영역 터치해도 닫히지 않음
      builder: (BuildContext context) {
        return PopupWidget(
          message: message,
          onConfirm: () {
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  void _showSuccessPopup(String message) {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // 바깥 영역 터치해도 닫히지 않음
      builder: (BuildContext context) {
        return PopupWidget(
          message: message,
          onConfirm: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
              (Route<dynamic> route) => false,
            );
          },
        );
      },
    );
  }

  void _showChoicePopup(BuildContext context, String message) {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // 바깥 영역 터치해도 닫히지 않음
      builder: (BuildContext context) {
        return PopupChoiceWidget(
          normalMessage: '정말 탈퇴하시겠습니까?',
          boldMessage: message,
          onConfirm: () {
            Navigator.of(context).pop();
            _deleteAccount();
          },
        );
      },
    );
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
                          height: 30,
                        ),
                        Text(
                          "계속하시려면 아래의 \n 탈퇴하기 버튼을 눌러주세요",
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
            _showChoicePopup(context, '계정 및 전체 데이터 삭제');
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.grey,
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
