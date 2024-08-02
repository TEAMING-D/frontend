import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teaming/home/project.dart';
import 'package:teaming/login/join.dart';
import 'package:teaming/login/login.dart';
import 'package:teaming/widget/popup_widget.dart';
import 'package:teaming/service/api_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
    await SharedPreferences.getInstance();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppLifecycleReactor(
      child: MaterialApp(
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
        home: AuthChecker(),
      ),
    );
  }
}

class AuthChecker extends StatefulWidget {
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  @override
  _AuthCheckerState createState() => _AuthCheckerState();
}

class _AuthCheckerState extends State<AuthChecker> {
  final ApiService apiService = ApiService();
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    String? token = await widget.secureStorage.read(key: 'accessToken');
    String? tokenDateStr = await widget.secureStorage.read(key: 'tokenDate');

    if (token != null && tokenDateStr != null) {
      DateTime tokenDate = DateTime.parse(tokenDateStr);
      DateTime currentDate = DateTime.now();
      Duration difference = currentDate.difference(tokenDate);

      if (difference.inDays <= 10) {
        // 프로젝트 데이터 전달 및 hasNotification 필드 제거
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => TeamProjectPage()),
        );
      } else {
        await _showTokenExpiredDialog();
      }
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }

  Future<void> _showTokenExpiredDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PopupWidget(
          message: '10일이 지나 토큰이 만료되었습니다\n다시 로그인해 주세요',
          onConfirm: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class AppLifecycleReactor extends StatefulWidget {
  final Widget child;

  AppLifecycleReactor({required this.child});

  @override
  _AppLifecycleReactorState createState() => _AppLifecycleReactorState();
}

class _AppLifecycleReactorState extends State<AppLifecycleReactor>
    with WidgetsBindingObserver {
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      // 앱이 백그라운드로 전환되거나 종료될 때 토큰 삭제하여 로그아웃 처리
      secureStorage.delete(key: 'accessToken');
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
