import 'package:teaming/home/project.dart';
import 'package:flutter/material.dart';
import 'package:teaming/login/join.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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
      locale: Locale('ko', 'KR'),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('ko', 'KR'),
        const Locale('en', 'US'), // 다른 언어 추가 가능
      ],
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
