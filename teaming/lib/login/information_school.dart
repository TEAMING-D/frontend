import 'package:flutter/material.dart';
import 'package:teaming/login/information_my_data.dart';
import 'package:teaming/login/information_widget.dart';

class SchoolInfoPage extends StatefulWidget {
  const SchoolInfoPage({super.key});

  @override
  State<SchoolInfoPage> createState() => _SchoolInfoPageState();
}

class _SchoolInfoPageState extends State<SchoolInfoPage> {
  final TextEditingController schoolNameController = TextEditingController();
  final TextEditingController schoolNumController = TextEditingController();
  final TextEditingController majorController = TextEditingController();

  bool _areFieldsFilled(BuildContext context) {
    return schoolNameController.text.isNotEmpty &&
        schoolNumController.text.isNotEmpty &&
        majorController.text.isNotEmpty;
  }

  void _showPopup(BuildContext context) {
    showGeneralDialog(
      barrierLabel: "Popup",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.3),
      transitionDuration: Duration(milliseconds: 300),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return Align(
          alignment: Alignment.center,
          child: Material(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            child: Container(
              width: 300,
              padding: EdgeInsets.all(15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 15),
                    child: Text(
                      "모든 입력란 기입이 필요합니다\n다시 한 번 확인해주세요",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: Color(0xFF585454),
                        height: 1.2,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromRGBO(84, 84, 84, 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            '확인',
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1,
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_rounded,
              color: Color(0xff585858),
            ),
          ),
          backgroundColor: Colors.transparent,
        ),
        extendBodyBehindAppBar: true,
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Stack(
              children: [
                SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 50),
                      width: MediaQuery.of(context).size.width,
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
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: "학교 정보\n",
                                    style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: "입력하기",
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontFamily: 'Leferi',
                                color: Color(0xFF7D7D7D),
                                letterSpacing: -1.6,
                                height: 1.2,
                              ),
                            ),
                            SizedBox(height: 30),
                            SizedBox(
                              width: 33,
                              child: Divider(
                                  color: Color(0xFF858585), thickness: 1),
                            ),
                            SizedBox(height: 20),
                            Text(
                              '학교와 관련된 정보를 입력해주세요\n학교명과 학번은 팀원 검색 시 활용됩니다',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: Color(0xFF797979),
                                letterSpacing: -0.3,
                              ),
                            ),
                            SizedBox(height: 50),
                            buildTextField(
                                '학교명', '학교명을 입력해주세요', schoolNameController),
                            SizedBox(height: 20),
                            buildTextField(
                                '학번', '학번을 입력해주세요', schoolNumController),
                            SizedBox(height: 20),
                            buildTextField(
                                '전공', '주전공을 입력해주세요', majorController),
                            SizedBox(height: 50),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
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
            if (_areFieldsFilled(context)) {
              // 다음 페이지로 이동하는 로직 추가
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      MyInfoPage(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return FadeTransition(
                      opacity: animation,
                      child: child,
                    );
                  },
                ),
              );
            } else {
              _showPopup(context);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromRGBO(84, 84, 84, 1),
            minimumSize: Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: Text(
            '계속하기',
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
