import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../model/sign_up_dto.dart';
import '../model/login_dto.dart';

class ApiService {
  final String baseUrl =
      'http://ec2-54-180-157-117.ap-northeast-2.compute.amazonaws.com:8080';
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  // 로그인 API
  Future<LoginResponse> login(String email, String password) async {
    final url = Uri.parse(
        'http://ec2-54-180-157-117.ap-northeast-2.compute.amazonaws.com:8080/login');
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

    final response = await http.post(url,
        headers: headers, body: utf8.encode(jsonEncode(body)));
    print('Response status: ${response.statusCode}');
    print('Response headers: ${response.headers}');
    final decodedBody = utf8.decode(response.bodyBytes);
    print('Decoded response body: $decodedBody');

    if (response.statusCode == 200) {
      if (response.headers.containsKey('authorization')) {
        print("토큰 있음");
        await secureStorage.write(
            key: 'accessToken', value: response.headers['authorization']);

        // 토큰 저장 확인
        String? token = await secureStorage.read(key: 'accessToken');
        print('Saved token: $token');
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

  // 토큰 저장하기
  Future<String?> getToken() async {
    return await secureStorage.read(key: 'accessToken');
  }

  // 회원가입 API
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

  // 회원가입 시 학교 검색 API
  Future<List<String>> searchSchools(String query) async {
    final response = await http.get(
      Uri.parse('$baseUrl/schools'),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      List<String> schoolNames =
          data.map((school) => school['name'] as String).toList();
      return schoolNames;
    } else {
      throw Exception('Failed to load schools');
    }
  }

  // 로그아웃 API(서버 미완성)
  Future<void> logout() async {
    String? token = await secureStorage.read(key: 'accessToken');
    if (token != null) {
      final url = Uri.parse('$baseUrl/api/user/logout');
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': token,
      };

      final response = await http.post(url, headers: headers);
      if (response.statusCode == 200) {
        await secureStorage.delete(key: 'accessToken');
        print('Logged out and token deleted.');
      } else {
        throw Exception('Failed to log out');
      }
    } else {
      print('No token found to log out');
    }
  }

  // 토큰 검증 절차(서버 API 없음)
  Future<bool> validateToken(String token) async {
    final url = Uri.parse('$baseUrl/validateToken');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': token,
    };

    final response = await http.get(url, headers: headers);
    return response.statusCode == 200;
  }

  // 내 정보 받아오기 API
  Future<Map<String, dynamic>> getUserInfo() async {
    final String? token = await secureStorage.read(key: 'accessToken');
    if (token == null) {
      throw Exception('토큰이 없습니다');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/users'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': token,
      },
    );
    print(token);
    if (response.statusCode == 200) {
      return json.decode(utf8.decode(response.bodyBytes));
    } else {
      // 상태 코드와 오류 메시지를 출력
      print('Failed to load user info: ${response.statusCode}');
      print('Error response: ${utf8.decode(response.bodyBytes)}');
      throw Exception('Failed to load user info: ${response.statusCode}');
    }
  }

  // 탈퇴 API
  Future<void> deleteAccount() async {
    final String? token = await secureStorage.read(key: 'accessToken');
    if (token == null) {
      throw Exception('토큰이 없습니다');
    }
    final response = await http.delete(
      Uri.parse('$baseUrl/users'),
      headers: {
        'Authorization': token,
      },
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete account');
    }
  }

  // 워크스페이스 생성 API
  Future<void> createWorkspace(Map<String, dynamic> workspaceData) async {
    final String? token = await secureStorage.read(key: 'accessToken');
    if (token == null) {
      throw Exception('토큰이 없습니다');
    }
    final response = await http.post(
      Uri.parse('$baseUrl/api/workspaces'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': token,
      },
      body: jsonEncode(workspaceData),
    );

    if (response.statusCode != 200) {
       print('Failed to load user info: ${response.statusCode}');
      print('Error response: ${utf8.decode(response.bodyBytes)}');
      throw Exception('Failed to create workspace');
    }
  }

  // username(유저명)으로 유저 찾기 API
  Future<List<Map<String, dynamic>>> searchUser(String username) async {
   final String? token = await secureStorage.read(key: 'accessToken');
    if (token == null) {
      throw Exception('토큰이 없습니다');
    }
    final response = await http.get(
      Uri.parse('$baseUrl/users/username/$username'),
      headers: {
        'Authorization': token,
      },
    );

  if (response.statusCode == 200) {
      final utf8Body = utf8.decode(response.bodyBytes);
      final data = jsonDecode(utf8Body)['data'];
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Failed to search user');
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
