import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:teaming/login/information_schedule.dart';
import 'package:teaming/login/information_widget.dart';

class MyInfoPage extends StatefulWidget {
  const MyInfoPage({super.key});

  @override
  State<MyInfoPage> createState() => _MyInfoPageState();
}

class _MyInfoPageState extends State<MyInfoPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phonePart1Controller = TextEditingController();
  final TextEditingController phonePart2Controller = TextEditingController();
  final TextEditingController phonePart3Controller = TextEditingController();
  final TextEditingController birthYearController = TextEditingController();
  final TextEditingController birthMonthController = TextEditingController();
  final TextEditingController birthDayController = TextEditingController();
  final TextEditingController snsNameController = TextEditingController();
  final TextEditingController snsIdController = TextEditingController();

  bool _areFieldsFilled(BuildContext context) {
    return nameController.text.isNotEmpty;
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
                      "이름은 필수 입력란입니다\n다시 한 번 확인해주세요",
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
                                    text: "내 정보\n",
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
                              '나에 대한 정보를 입력해주세요\n추후 설정에서 공개 여부를 선택할 수 있습니다',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: Color(0xFF797979),
                                letterSpacing: -0.3,
                              ),
                            ),
                            SizedBox(height: 50),
                            buildTextField('이름', '이름을 입력해주세요', nameController),
                            SizedBox(height: 20),
                            Text(
                              '전화번호',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Color(0xFF484848),
                              ),
                            ),
                            Row(
                              children: [
                                buildShortTextField(
                                  '000',
                                  phonePart1Controller,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(3),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Text('-'),
                                ),
                                buildShortTextField(
                                  '0000',
                                  phonePart2Controller,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(4),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Text('-'),
                                ),
                                buildShortTextField(
                                    '0000', phonePart3Controller,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(4),
                                  ],),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              '생년월일',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Color(0xFF484848),
                              ),
                            ),
                            Row(
                              children: [
                                buildShortTextField(
                                    'YYYY', birthYearController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(4),
                                  ],),
                                SizedBox(
                                  width: 20,
                                ),
                                buildShortTextField('MM', birthMonthController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(2),
                                  ],),
                                SizedBox(
                                  width: 20,
                                ),
                                buildShortTextField('DD', birthDayController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(2),
                                  ],),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            buildDivideTextField(
                                'SNS계정',
                                'SNS명',
                                '계정 아이디를 입력하세요',
                                snsNameController,
                                snsIdController),
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
                      GetSchedulePage(),
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
