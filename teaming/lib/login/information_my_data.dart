import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:teaming/login/information_schedule.dart';
import 'package:teaming/login/textfield_widget.dart';
import 'package:teaming/popup_widget.dart';
import '../model/sign_up_dto.dart';

class MyInfoPage extends StatefulWidget {
  final SignUpRequest signUpRequest;

  const MyInfoPage({super.key, required this.signUpRequest});

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

  void _showPopup(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PopupWidget(message: message);
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
            return GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Stack(
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
                              buildTextField('이름', '이름을 입력해주세요',
                                  controllerName: nameController),
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
                                    controllerName: phonePart1Controller,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(3),
                                    ],
                                    onEditingComplete: () {
                                      if (!RegExp(r'^(010|011|016|017|019)$')
                                          .hasMatch(
                                              phonePart1Controller.text)) {
                                        _showPopup(context,
                                            '전화번호 앞자리는 010, 011, 016, 017, 019 중 하나여야 합니다.');
                                        phonePart1Controller.clear();
                                      } else {
                                        FocusScope.of(context).nextFocus();
                                      }
                                    },
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Text('-'),
                                  ),
                                  buildShortTextField('0000',
                                      controllerName: phonePart2Controller,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(4),
                                      ], onEditingComplete: () {
                                    FocusScope.of(context).nextFocus();
                                  }),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Text('-'),
                                  ),
                                  buildShortTextField(
                                    '0000',
                                    controllerName: phonePart3Controller,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(4),
                                    ], onEditingComplete: () {
                                    FocusScope.of(context).unfocus();
                                  }
                                  ),
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
                                    'YYYY',
                                    controllerName: birthYearController,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(4),
                                    ],
                                    onEditingComplete: () {
                                      int year = int.tryParse(
                                              birthYearController.text) ??
                                          0;
                                      if (year < 1900 ||
                                          year > DateTime.now().year) {
                                        _showPopup(
                                            context, '생년월일의 년도를 제대로 설정해 주세요.');
                                        birthYearController.clear();
                                      } else {
                                        FocusScope.of(context).nextFocus();
                                      }
                                    },
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  buildShortTextField(
                                    'MM',
                                    controllerName: birthMonthController,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(2),
                                    ],
                                    onEditingComplete: () {
                                      int month = int.tryParse(
                                              birthMonthController.text) ??
                                          0;
                                      if (month < 1 || month > 12) {
                                        _showPopup(
                                            context, '생년월일의 월을 제대로 설정해 주세요.');
                                        birthMonthController.clear();
                                      } else {
                                        if (birthMonthController.text.length ==
                                            1) {
                                          birthMonthController.text =
                                              birthMonthController.text
                                                  .padLeft(2, '0');
                                        }
                                        FocusScope.of(context).nextFocus();
                                      }
                                    },
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  buildShortTextField(
                                    'DD',
                                    controllerName: birthDayController,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(2),
                                    ],
                                    onEditingComplete: () {
                                      int day = int.tryParse(
                                              birthDayController.text) ??
                                          0;
                                      if (day < 1 || day > 31) {
                                        _showPopup(
                                            context, '생년월일의 일을 제대로 설정해 주세요.');
                                        birthDayController.clear();
                                      } else {
                                        if (birthDayController.text.length ==
                                            1) {
                                          birthDayController.text =
                                              birthDayController.text
                                                  .padLeft(2, '0');
                                        }
                                        FocusScope.of(context).unfocus();
                                      }
                                    },
                                  ),
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
            if (_areFieldsFilled(context)) {
              widget.signUpRequest.username = nameController.text;
              widget.signUpRequest.phone =
                  '${phonePart1Controller.text}-${phonePart2Controller.text}-${phonePart3Controller.text}';
              widget.signUpRequest.birth =
                  '${birthYearController.text}-${birthMonthController.text}-${birthDayController.text}';
              widget.signUpRequest.sns =
                  '${snsNameController.text} @${snsIdController.text}';

              if (phonePart1Controller.text.isEmpty ||
                  phonePart2Controller.text.isEmpty ||
                  phonePart3Controller.text.isEmpty) {
                widget.signUpRequest.phone = '';
              }
              if (birthYearController.text.isEmpty ||
                  birthMonthController.text.isEmpty ||
                  birthDayController.text.isEmpty) {
                widget.signUpRequest.birth = '';
              }
              if (snsNameController.text.isEmpty ||
                  snsIdController.text.isEmpty) {
                widget.signUpRequest.sns = '';
              }

              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      GetSchedulePage(signUpRequest: widget.signUpRequest),
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
              _showPopup(context, '이름은 필수 입력란입니다\n다시 한 번 확인해주세요');
            }
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
