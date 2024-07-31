// services/api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../model/sign_up_dto.dart';

class ApiService {
  final String baseUrl = 'http://ec2-43-203-252-79.ap-northeast-2.compute.amazonaws.com:8080';
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  Future<SignUpResponse> signUp(SignUpRequest request) async {
    final url = Uri.parse('$baseUrl/signUp');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode(request.toJson());

    try {
      final response = await http.post(url, headers: headers, body: body);
      final decodedBody = utf8.decode(response.bodyBytes);

      if (response.statusCode == 200) {
        return SignUpResponse.fromJson(jsonDecode(decodedBody));
      } else {
        throw Exception(
          decodedBody.isNotEmpty
              ? ErrorResponse.fromJson(jsonDecode(decodedBody)).error.message
              : 'Empty response body',
        );
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('회원가입에 실패했습니다. 네트워크 연결을 확인해주세요.');
    }
  }
}

class SignUpResponse {
  final bool success;
  final int count;
  final Data data;

  SignUpResponse({
    required this.success,
    required this.count,
    required this.data,
  });

  factory SignUpResponse.fromJson(Map<String, dynamic> json) {
    return SignUpResponse(
      success: json['success'],
      count: json['count'],
      data: Data.fromJson(json['data']),
    );
  }
}

class Data {
  final int id;

  Data({required this.id});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(id: json['id']);
  }
}

class ErrorResponse {
  final ErrorDetail error;

  ErrorResponse({required this.error});

  factory ErrorResponse.fromJson(Map<String, dynamic> json) {
    return ErrorResponse(error: ErrorDetail.fromJson(json['error']));
  }
}

class ErrorDetail {
  final String code;
  final String message;

  ErrorDetail({required this.code, required this.message});

  factory ErrorDetail.fromJson(Map<String, dynamic> json) {
    return ErrorDetail(
      code: json['code'],
      message: json['message'],
    );
  }
}
