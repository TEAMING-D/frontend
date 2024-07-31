import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../model/sign_up_dto.dart';
import '../model/login_dto.dart';

class ApiService {
  final String baseUrl =
      'http://ec2-54-180-157-117.ap-northeast-2.compute.amazonaws.com:8080';
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

 Future<LoginResponse> login(String email, String password) async {
    final url = Uri.parse('http://ec2-54-180-157-117.ap-northeast-2.compute.amazonaws.com:8080/login');
    final headers = {
      'Content-Type': 'application/json',
    };
    final Map<String, dynamic> body = {
      'email': email,
      'password': password,
    };

    print("Request URL: $url");
    print("Request headers: $headers");
    print("Request body: $body");

    final response = await http.post(url, headers: headers, body: utf8.encode(jsonEncode(body)));
    print('Response status: ${response.statusCode}');
    print('Response headers: ${response.headers}');
    final decodedBody = utf8.decode(response.bodyBytes);
    print('Decoded response body: $decodedBody');

    if (response.statusCode == 200) {
      if (response.headers.containsKey('authorization')) {
        print("토큰 있음");
        await secureStorage.write(
            key: 'accessToken', value: response.headers['authorization']);
        return LoginResponse(token: response.headers['authorization']!);
      } else {
        throw Exception('Authorization header not found');
      }
    } else {
      print('Error response body: $decodedBody');
      throw Exception(
        decodedBody.isNotEmpty
            ? LoginErrorResponse.fromJson(jsonDecode(decodedBody)).message
            : 'Empty response body',
      );
    }
  }

  Future<String?> getToken() async {
    return await secureStorage.read(key: 'accessToken');
  }

  Future<SignUpResponse> signUp(SignUpRequest request) async {
    final url = Uri.parse('$baseUrl/signUp');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode(request.toJson());

    print("Request URL: $url");
    print("Request headers: $headers");
    print("Request body: $body");

    try {
      final response = await http.post(url, headers: headers, body: body);
      final decodedBody = utf8.decode(response.bodyBytes);

      print('Response status: ${response.statusCode}');
      print('Response headers: ${response.headers}');
      print('Decoded response body: $decodedBody');

      if (response.statusCode == 200) {
        final Map<String, dynamic>? responseJson =
            jsonDecode(decodedBody) as Map<String, dynamic>?;
        if (responseJson != null) {
          return SignUpResponse.fromJson(responseJson);
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        final Map<String, dynamic>? errorResponse =
            jsonDecode(decodedBody) as Map<String, dynamic>?;
        if (errorResponse != null && errorResponse.containsKey('error')) {
          throw Exception(ErrorResponse.fromJson(errorResponse).error.message);
        } else {
          throw Exception(errorResponse != null
              ? errorResponse['message']
              : 'Empty or unexpected error response format');
        }
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('회원가입에 실패했습니다. 네트워크 연결을 확인해주세요.');
    }
  }


}

class User {
  final int id;
  final String email;
  final String username;
  final String info;
  final int schoolId;
  final String major;

  User({
    required this.id,
    required this.email,
    required this.username,
    required this.info,
    required this.schoolId,
    required this.major,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      username: json['username'],
      info: json['info'],
      schoolId: json['schoolId'],
      major: json['major'],
    );
  }
}
