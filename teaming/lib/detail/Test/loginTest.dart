import 'package:flutter/material.dart';
import 'package:teaming/service/api_service.dart';

class LoginTestPage extends StatefulWidget {
  const LoginTestPage({Key? key}) : super(key: key);

  @override
  _LoginTestPageState createState() => _LoginTestPageState();
}

class _LoginTestPageState extends State<LoginTestPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ApiService apiService = ApiService();

  void _login() async {
    final email = emailController.text;
    final password = passwordController.text;

    try {
      final response = await apiService.login(email, password);
      print('Login successful, token: ${response.token}');
      // 로그인 성공 후의 동작 추가
    } catch (e) {
      print('Login failed: $e');
      // 로그인 실패 처리
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: _login,
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
