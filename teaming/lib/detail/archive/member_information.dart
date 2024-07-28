import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:teaming/detail/navigation_bar.dart';

class MemberInfoPage extends StatefulWidget {
  const MemberInfoPage({super.key});

  @override
  _MemberInfoPageState createState() => _MemberInfoPageState();
}

class _MemberInfoPageState extends State<MemberInfoPage> {
  int selectedMemberIndex = 0;

  final List<Map<String, dynamic>> members = [
    {
      'name': '김세아',
      'school': '숙명여자대학교',
      'studentId': '2012345',
      'major': 'IT공학전공',
      'github': 'gitMail@gmail.com',
      'email': 'backup@gmail.com',
      'phone': '010-1234-5678',
      'birth': '2000-01-01',
      'sns': '인스타그램 @nickname',
    },
    {
      'name': '오수진',
      'school': '숙명여자대학교',
      'studentId': '2012346',
      'major': 'IT공학전공',
      'github': 'gitMail@gmail.com',
      'phone': '010-2345-6789',
      'birth': '2000-02-02',
      'sns': '인스타그램 @nickname',
    },
    {
      'name': '윤소윤',
      'school': '숙명여자대학교',
      'studentId': '2012347',
      'major': 'IT공학전공',
      'github': 'gitMail@gmail.com',
      'email': 'backup@gmail.com',
      'phone': '010-3456-7890',
      'birth': '2000-03-03',
      'notion': 'notion.so/username',
    },
  ];

  Widget _buildMemberTab() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: members.map((member) {
        int index = members.indexOf(member);
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedMemberIndex = index;
            });
          },
          child: Column(
            children: [
              Text(
                member['name'],
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: selectedMemberIndex == index
                      ? Color(0xFF484848)
                      : Color(0xFF9C9C9C),
                ),
              ),
              if (selectedMemberIndex == index)
                Container(
                  margin: EdgeInsets.only(top: 2),
                  height: 2,
                  width: 50,
                  color: Color(0xFF484848),
                ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildInfoRow(String memberName, String label, String value) {
    return GestureDetector(
      onTap: () {
        Clipboard.setData(ClipboardData(text: value));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$memberName의 $label이(가) 복사되었습니다.')),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: Color(0xFF484848),
            ),
          ),
          SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              fontSize: 15,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 5),
          Divider(color: Color(0xFF9C9C9C), thickness: 1),
          SizedBox(height: 15),
        ],
      ),
    );
  }

  Widget _buildPhoneRow(String memberName, String label, String value) {
    List<String> parts = value.split('-');
    return GestureDetector(
      onTap: () {
        Clipboard.setData(ClipboardData(text: parts.join('')));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$memberName의 $label이(가) 복사되었습니다.')),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: Color(0xFF484848),
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              _buildShortTextField(parts[0]),
              SizedBox(width: 10),
              Text('-'),
              SizedBox(width: 10),
              _buildShortTextField(parts[1]),
              SizedBox(width: 10),
              Text('-'),
              SizedBox(width: 10),
              _buildShortTextField(parts[2]),
            ],
          ),
          SizedBox(height: 15),
        ],
      ),
    );
  }

  Widget _buildBirthRow(String memberName, String label, String value) {
    List<String> parts = value.split('-');
    return GestureDetector(
      onTap: () {
        Clipboard.setData(ClipboardData(text: parts.join('.')));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$memberName의 $label이(가) 복사되었습니다.')),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: Color(0xFF484848),
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              _buildShortTextField(parts[0]),
              SizedBox(width: 10),
              _buildShortTextField(parts[1]),
              SizedBox(width: 10),
              _buildShortTextField(parts[2]),
            ],
          ),
          SizedBox(height: 15),
        ],
      ),
    );
  }

  Widget _buildSNSRow(String memberName, String label, String value) {
    List<String> parts = value.split(' ');
    return GestureDetector(
      onTap: () {
        Clipboard.setData(ClipboardData(text: value));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$memberName의 $label이(가) 복사되었습니다.')),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: Color(0xFF484848),
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Container(
                width: 110,
                child: Column(
                  children: [
                    Text(
                      parts[0],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                        color: Colors.black,
                      ),
                    ),
                    Divider(
                      color: Color(0xFF9C9C9C),
                      thickness: 1,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      parts[1],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                        color: Colors.black,
                      ),
                    ),
                    Divider(
                      color: Color(0xFF9C9C9C),
                      thickness: 1,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
        ],
      ),
    );
  }

  Widget _buildShortTextField(String value) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              fontSize: 15,
              color: Colors.black,
            ),
          ),
          Divider(
            color: Color(0xFF9C9C9C),
            thickness: 1,
          ),
        ],
      ),
    );
  }

  Widget _buildMemberInfo() {
    Map<String, dynamic> member = members[selectedMemberIndex];
    String memberName = member['name'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow(memberName, '학교명', member['school']),
          _buildInfoRow(memberName, '학번', member['studentId']),
          _buildInfoRow(memberName, '전공', member['major']),
          SizedBox(
            height: 40,
          ),
          if (member.containsKey('github'))
            _buildInfoRow(memberName, 'Github', member['github']),
          if (member.containsKey('email'))
            _buildInfoRow(memberName, 'E-mail', member['email']),
          if (member.containsKey('notion'))
            _buildInfoRow(memberName, 'Notion', member['notion']),
          SizedBox(
            height: 40,
          ),
          if (member.containsKey('phone'))
            _buildPhoneRow(memberName, '전화번호', member['phone']),
          if (member.containsKey('birth'))
            _buildBirthRow(memberName, '생년월일', member['birth']),
          if (member.containsKey('sns'))
            _buildSNSRow(memberName, 'SNS 계정', member['sns']),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
            child: Container(
              color: Colors.transparent,
            ),
          ),
        ),
        scrolledUnderElevation: 0,
        title: GestureDetector(
          onTap: () {},
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '팀원별 정보 조회',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                  color: Color(0xFF404040),
                ),
              ),
              Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF404040)),
            ],
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
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
        child: Column(
          children: [
            SizedBox(height: 80),
            Center(
              child: Text(
                '팀원들의 정보를 확인하고 터치해 복사할 수 있습니다\n공개 설정된 경우에만 확인 가능합니다',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: Color(0xFF838383),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 30),
            _buildMemberTab(),
            SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center, // 가운데 정렬
                        children: [
                          _buildMemberInfo(),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ), bottomNavigationBar: DetailNavigationBar(
        currentIndex: 1,
        currentPage: MemberInfoPage,
      ),
    );
  }
}
