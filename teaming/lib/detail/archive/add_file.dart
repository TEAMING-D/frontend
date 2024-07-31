import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class AddFilePage extends StatefulWidget {
  @override
  _AddFilePageState createState() => _AddFilePageState();
}

class _AddFilePageState extends State<AddFilePage> {
  List<PlatformFile> _selectedFiles = [];
  String? _selectedTask = '없음';

  void _selectFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result != null) {
      setState(() {
        _selectedFiles.addAll(result.files);
      });
    }
  }

  Widget _buildRadioButton(String value) {
    return RadioListTile<String>(
      contentPadding: EdgeInsets.zero,
      activeColor: Colors.grey[800],
      title: Text(
        value,
        style: TextStyle(
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
          fontSize: 15,
          color: Color(0xFF404040),
        ),
      ),
      value: value,
      groupValue: _selectedTask,
      onChanged: (newValue) {
        setState(() {
          _selectedTask = newValue;
        });
      },
      dense: true,
      visualDensity: VisualDensity(horizontal: 0, vertical: -4),
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
        title: Text(
          '자료 추가하기',
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 100),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                '관련된 업무 선택하기',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  fontSize: 17,
                  color: Color(0xFF404040),
                ),
              ),
            ),SizedBox(height: 15,),
            _buildRadioButton('없음'),
            _buildRadioButton('주제 설정'),
            _buildRadioButton('자료조사'),
            _buildRadioButton('PPT 제작'),
            SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                '파일 가져오기',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  fontSize: 17,
                  color: Color(0xFF404040),
                ),
              ),
            ),SizedBox(height: 15,),
            ElevatedButton(
              onPressed: _selectFiles,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[600],
              ),
              child: Text(
                '파일 선택하기',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.only(top: 10),
                itemCount: _selectedFiles.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      _selectedFiles[index].name,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        fontSize: 13,
                        color: Color(0xFF404040),
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.close_rounded),
                      onPressed: () {
                        setState(() {
                          _selectedFiles.removeAt(index);
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 53,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton(
                onPressed: () {
                  // 파일 추가 버튼 눌렀을 때의 로직 처리
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Color.fromRGBO(84, 84, 84, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  '추가하기',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: 53),
          ],
        ),
      ),
    );
  }
}
