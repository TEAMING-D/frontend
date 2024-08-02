import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:teaming/home/project.dart';
import 'package:teaming/login/join.dart';
import 'package:teaming/login/login.dart';
import 'package:teaming/popup_widget.dart';
import 'package:teaming/service/api_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
        home: AuthChecker(), // AuthChecker를 시작 페이지로 설정
        onGenerateRoute: (settings) {
          if (settings.name == '/teamProjects') {
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (context) {
                return TeamProjectPage(
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
    // secureStorage.read(key: 'accessToken') 호출 시 secureStorage 인스턴스가 사용되도록 수정
    String? token = await widget.secureStorage.read(key: 'accessToken');
    String? tokenDateStr = await widget.secureStorage.read(key: 'tokenDate');

    if (token != null && tokenDateStr != null) {
      DateTime tokenDate = DateTime.parse(tokenDateStr);
      DateTime currentDate = DateTime.now();
      Duration difference = currentDate.difference(tokenDate);

      if (difference.inDays <= 10) {
        Navigator.pushReplacementNamed(context, '/teamProjects', arguments: {
          'projects': [
            {
              'name': '프로젝트명A',
              'members': ['김세아', '오수진', '윤소윤'],
              'class': '수업명A',
              'progress': 80,
              'startDate': '2024.03.04',
              'endDate': '2024.08.15',
            },
            {
              'name': '프로젝트명B',
              'members': [
                '김세아',
                '오수진',
                '윤소윤',
                '황익명',
                '박익명',
                '김익명',
                '이익명',
                '장익명'
              ],
              'class': '수업명B',
              'progress': 45,
              'startDate': '2024.01.13',
              'endDate': '2024.07.20',
            },
            {
              'name': '프로젝트명C',
              'members': ['김세아', '박익명', '최익명'],
              'class': '대회명A',
              'progress': 100,
              'startDate': '2023.12.13',
              'endDate': '2024.05.23',
            },
            {
              'name': '프로젝트명D',
              'members': ['김세아', '이익명'],
              'class': '수업명C ',
              'progress': 20,
              'startDate': '2023.08.15',
              'endDate': '2024.02.21',
            },
            {
              'name': '프로젝트명E',
              'members': ['김세아', '이익명', '박익명'],
              'class': '대회명B',
              'progress': 95,
              'startDate': '2023.08.15',
              'endDate': '2023.12.21',
            },
            {
              'name': '프로젝트명F',
              'members': ['김세아', '박익명'],
              'class': '봉사명A',
              'progress': 20,
              'startDate': '2023.06.25',
              'endDate': '2023.08.10',
            },
          ],
          'hasNotification': true,
        });
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
