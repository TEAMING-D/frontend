class LoginRequest {
  final String email;
  final String password;

  LoginRequest({required this.email, required this.password});

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}

class LoginResponse {
  final String token;

  LoginResponse({required this.token});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(token: json['token']);
  }
}

class LoginErrorResponse {
  final String error;
  final String message;

  LoginErrorResponse({required this.error, required this.message});

  factory LoginErrorResponse.fromJson(Map<String, dynamic> json) {
    return LoginErrorResponse(
      error: json['error'],
      message: json['message'],
    );
  }
}
