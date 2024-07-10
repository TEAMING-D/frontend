import 'package:flutter/material.dart';

class CollaborationPage extends StatefulWidget {
  const CollaborationPage({super.key});

  @override
  State<CollaborationPage> createState() => _CollaborationPageState();
}

class _CollaborationPageState extends State<CollaborationPage> {
  List<Widget> additionalFields = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 30),
                width: MediaQuery.of(context).size.width,
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
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 150),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: "협업용 계정\n",
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: "정보 입력하기",
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
                          child:
                              Divider(color: Color(0xFF858585), thickness: 1),
                        ),
                        SizedBox(height: 33),
                        Text(
                          '가입되어 있는 계정을 입력해주세요\n추후 설정에서 공개 여부를 선택할 수 있습니다',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Color(0xFF797979),
                            letterSpacing: -0.3,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '이 페이지의 입력란은 필수가 아닙니다',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Color(0xFF797979),
                            letterSpacing: -0.3,
                          ),
                        ),
                        SizedBox(height: 50),
                        Text(
                          'Notion',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Color(0xFF484848),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                          child: TextField(
                            style: TextStyle(fontSize: 15, color: Colors.black),
                            decoration: InputDecoration(
                              hintText: '계정 이메일을 입력해주세요',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(vertical: 5),
                              hintStyle: TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 15,
                                  color: Color(0xFFA9A9A9)),
                            ),
                          ),
                        ),
                        SizedBox(height: 3),
                        Divider(color: Color(0xFF9C9C9C), thickness: 1),
                        SizedBox(height: 20),
                        Text(
                          'Github',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Color(0xFF484848),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                          child: TextField(
                            style: TextStyle(fontSize: 15, color: Colors.black),
                            decoration: InputDecoration(
                              hintText: '계정 이메일을 입력해주세요',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(vertical: 5),
                              hintStyle: TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 15,
                                  color: Color(0xFFA9A9A9)),
                            ),
                          ),
                        ),
                        SizedBox(height: 3),
                        Divider(color: Color(0xFF9C9C9C), thickness: 1),
                        SizedBox(height: 20),
                        Text(
                          'E-mail',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Color(0xFF484848),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                          child: TextField(
                            style: TextStyle(fontSize: 15, color: Colors.black),
                            decoration: InputDecoration(
                              hintText: '추가로 사용할 이메일을 입력해주세요',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(vertical: 5),
                              hintStyle: TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 15,
                                  color: Color(0xFFA9A9A9)),
                            ),
                          ),
                        ),
                        SizedBox(height: 3),
                        Divider(color: Color(0xFF9C9C9C), thickness: 1),
                        SizedBox(height: 40),
                        Row(
                          children: [
                            Text(
                              '기타 협업 툴',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Color(0xFF484848),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.add_circle_outline,
                                  color: Color(0xFF7D7D7D)),
                              onPressed: addFields,
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: 82,
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 30,
                                        child: TextField(
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.black),
                                          textAlign: TextAlign.center,
                                          decoration: InputDecoration(
                                            hintText: '도구명',
                                            border: InputBorder.none,
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 5),
                                            hintStyle: TextStyle(
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w400,
                                                fontSize: 15,
                                                color: Color(0xFFA9A9A9)),
                                          ),
                                        ),
                                      ),
                                      Divider(
                                          color: Color(0xFF9C9C9C),
                                          thickness: 1),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 20),
                                Expanded(
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 30,
                                        child: TextField(
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.black),
                                          decoration: InputDecoration(
                                            hintText: '계정 이메일을 입력해주세요',
                                            border: InputBorder.none,
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 5),
                                            hintStyle: TextStyle(
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w400,
                                                fontSize: 15,
                                                color: Color(0xFFA9A9A9)),
                                          ),
                                        ),
                                      ),
                                      Divider(
                                          color: Color(0xFF9C9C9C),
                                          thickness: 1),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: additionalFields,
                            ),
                          ],
                        ),
                        SizedBox(height: 50),
                        ElevatedButton(
                          onPressed: () {
                            // 다음 정보 입력란 페이지로 전환
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
                        SizedBox(
                          height: 50,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void addFields() {
    int addFieldsLength = additionalFields.length;
    int colorMultiple = 169 - (addFieldsLength + 1) * 20;
    Color colorForNewFields = Color.fromARGB(255, colorMultiple, colorMultiple, colorMultiple);

    if (addFieldsLength < 4) {
      setState(() {
        additionalFields.add(
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              children: [
                SizedBox(
                  width: 82,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 30,
                        child: TextField(
                          style: TextStyle(fontSize: 15, color: Colors.black),
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            hintText: '도구명',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 5),
                            hintStyle: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                fontSize: 15,
                                color: colorForNewFields),
                          ),
                        ),
                      ),
                      Divider(color: colorForNewFields, thickness: 1),
                    ],
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 30,
                        child: TextField(
                          style: TextStyle(fontSize: 15, color: Colors.black),
                          decoration: InputDecoration(
                            hintText: '계정 이메일을 입력해주세요',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 5),
                            hintStyle: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                fontSize: 15,
                                color: colorForNewFields),
                          ),
                        ),
                      ),
                      Divider(color: colorForNewFields, thickness: 1),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      });
    }
  }
}
