import 'dart:io';

import 'package:teaming/detail/Test/userSearchTest.dart';
import 'package:teaming/home/project.dart';
import 'package:flutter/material.dart';
import 'package:teaming/login/join.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:teaming/detail/Test/loginTest.dart';
import 'package:teaming/login/login.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
    HttpOverrides.global = MyHttpOverrides();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false, // 디버그 바 제거
      theme: ThemeData(
        primarySwatch: Colors.grey,
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Color.fromRGBO(84, 84, 84, 1), // 기본 커서 색상
          selectionHandleColor: Color.fromRGBO(84, 84, 84, 1),
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
        const Locale('en', 'US'),
      ],
      home: LoginPage(),
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

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}