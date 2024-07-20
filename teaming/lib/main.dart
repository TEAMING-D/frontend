import 'package:teaming/home/project.dart';
import 'package:flutter/material.dart';
import 'package:teaming/login/join.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false, // 디버그 바 제거
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Color.fromRGBO(84, 84, 84, 1), // 기본 커서 색상
        ),
      ),
      home: JoinPage(),
      onGenerateRoute: (settings) {
        if (settings.name == '/teamProjects') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) {
              return TeamProjectPage(
                projects: args['projects'],
                hasNotification: args['hasNotification'],
              );
            },
          );
        }
        assert(false, 'Need to implement ${settings.name}');
        return null;
      },
    ),
  );
}
