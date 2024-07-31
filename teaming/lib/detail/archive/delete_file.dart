import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:teaming/detail/archive/file_item.dart';

class DeleteFilePage extends StatefulWidget {
  final List<FileItem> files;

  DeleteFilePage({required this.files});

  @override
  _DeleteFilePageState createState() => _DeleteFilePageState();
}

class _DeleteFilePageState extends State<DeleteFilePage> {
  List<bool> _selectedFiles = [];

  @override
  void initState() {
    super.initState();
    _selectedFiles = List<bool>.filled(widget.files.length, false);
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
        title: Text(
          '자료 삭제하기',
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w800,
            fontSize: 16,
            color: Color(0xFF404040),
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
      body: Stack(
        children: [
          Container(
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
                SizedBox(height: 85),
                Text(
                  '내가 업로드한 자료만 삭제할 수 있습니다',
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
                    padding: EdgeInsets.only(top: 10),
                    itemCount: widget.files.length,
                    itemBuilder: (context, index) {
                      final file = widget.files[index];
                      bool isExpired = file.uploadDate.isBefore(
                          DateTime.now().subtract(Duration(days: 30)));
                      return Row(
                        children: [
                          Checkbox(activeColor: Colors.grey[800],
                            value: _selectedFiles[index],
                            onChanged: (bool? value) {
                              setState(() {
                                _selectedFiles[index] = value!;
                              });
                            },
                          ),
                          Container(
                            height: 30,
                            width: 300,
                            padding: EdgeInsets.symmetric(horizontal: 10),
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
                                    decoration: isExpired
                                        ? TextDecoration.lineThrough
                                        : null,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  isExpired ? '' : file.size,
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 11,
                                    color: isExpired
                                        ? Color(0xFF585454)
                                        : Color(0xFFBBBBBB),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                SizedBox(height: 100),
              ],
            ),
          ),
          Positioned(
            left: 53,
            right: 53,
            bottom: 53,
            child: ElevatedButton(
              onPressed: () {
                // 삭제 버튼 눌렀을 때의 로직 처리
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
                '삭제하기',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
