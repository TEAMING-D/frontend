// sign_up_dto.dart

class SignUpRequest {
  String username;
  String phone;
  String password;
  String schoolName;
  int schoolId;
  String email;
  String major;
  String gitId;
  String notionMail;
  String plusMail;
  String birth;
  String sns;
  String collabTools; // JSON 문자열로 변경

  SignUpRequest({
    required this.username,
    required this.phone,
    required this.password,
    required this.schoolName,
    required this.schoolId,
    required this.email,
    required this.major,
    required this.gitId,
    required this.notionMail,
    required this.plusMail,
    required this.birth,
    required this.sns,
    required this.collabTools,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'phone': phone,
      'password': password,
      'schoolName': schoolName,
      'schoolId': schoolId,
      'email': email,
      'major': major,
      'gitId': gitId,
      'notionMail': notionMail,
      'plusMail': plusMail,
      'birth': birth,
      'sns': sns,
      'collabTools': collabTools, // JSON 문자열로 변경
    };
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

