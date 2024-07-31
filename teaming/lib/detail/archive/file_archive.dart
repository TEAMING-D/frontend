import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:teaming/detail/archive/file_item.dart';
import 'package:teaming/detail/archive/add_file.dart';
import 'package:teaming/detail/archive/delete_file.dart';
import 'package:teaming/detail/archive/member_information.dart';
import 'package:teaming/detail/navigation_bar.dart';

class FileArchivePage extends StatelessWidget {
  final List<FileItem> files;

  FileArchivePage({required this.files});

  Future<void> _downloadFile(String fileName) async {
    // 파일 다운로드 로직 구현
    print('Downloading $fileName');
  }

   void _showDropdownMenu(BuildContext context) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        (MediaQuery.of(context).size.width / 3.5),
        position.dy + kToolbarHeight + 20,
        (MediaQuery.of(context).size.width / 3.5),
        0,
      ),
      items: [
        PopupMenuItem(
          child: Container(
              alignment: Alignment.center,
              child: Text(
                '팀원별 정보 조회',
                textAlign: TextAlign.center,
              )),
          onTap: () {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => MemberInfoPage(),
                transitionDuration: Duration(milliseconds: 500),
                transitionsBuilder: (_, a, __, c) =>
                    FadeTransition(opacity: a, child: c),
              ),
            );
          },
        ),
      ],
      color: Colors.white,
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
            onTap: () => _showDropdownMenu(context),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '자료 아카이브',
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
          actions: [
            IconButton(
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(),
              icon: Image.asset(
                'assets/icon/minus_icon.png',
                height: 30,
                width: 30,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DeleteFilePage(files: files)),
                );
              },
            ),
            IconButton(padding: EdgeInsets.only(right: 10),
              constraints: BoxConstraints(),
              icon: Image.asset(
                'assets/icon/plus_icon.png',
                height: 30,
                width: 30,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddFilePage()),
                );
              },
            ),
          ],
        ),
        extendBodyBehindAppBar: true,
        extendBody: true,
        body:  Container(
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
          child: files.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/icon/no_file_icon.png'),
                      SizedBox(height: 20),
                      Text(
                        '등록되어 있는 자료가 없습니다\n우측 상단의 + 아이콘을 눌러 등록해보세요',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          fontSize: 13,
                          color: Color(0xFF404040),
                        ),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    SizedBox(height: 85),
                    Text(
                      '30일까지 보관된 후 파일이 만료됩니다\n터치해 파일을 다운로드할 수 있습니다',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: Color(0xFF404040),
                      ),
                    ),
                    SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.only(top: 25),
                        itemCount: files.length + 1,
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: SizedBox(
                                    width: 300,
                                    height: 30,
                                    child: TextField(
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12,
                                        color: Colors.black,
                                      ),
                                      textAlign: TextAlign.start,
                                      decoration: InputDecoration(
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(5),
                                          borderSide: BorderSide(color: Color(0xFF616161)),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(5),
                                          borderSide: BorderSide(color: Color(0xFF616161)),
                                        ),
                                        hintText: '자료명으로 검색하기',
                                        hintStyle: TextStyle(
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                          color: Color(0xFF585454),
                                        ),
                                        suffixIcon: Icon(Icons.search, color: Color(0xFF585454)),
                                        contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                                        isDense: true,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 5),
                              ],
                            );
                          }
                          final file = files[index - 1];
                          bool isExpired = file.uploadDate.isBefore(
                              DateTime.now().subtract(Duration(days: 30)));
                          return GestureDetector(
                            onTap: () {
                              _downloadFile(file.name);
                            },
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  width: 300,
                                  margin: EdgeInsets.symmetric(vertical: 5),
                                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Color(0xFFCCCCCC)),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        '${file.uploader}  ${DateFormat('yyyy.MM.dd').format(file.uploadDate)}  ${file.name}',
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                          letterSpacing: -0.2,
                                          color: Color(0xFF585454),
                                          decoration: isExpired ? TextDecoration.lineThrough : null,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  isExpired ? '(만료)' : file.size,
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 11,
                                    color: isExpired ? Color(0xFF585454) : Color(0xFFBBBBBB),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
        ),
        bottomNavigationBar: DetailNavigationBar(
          currentIndex: 3,
          currentPage: FileArchivePage,
        ));
  }
}