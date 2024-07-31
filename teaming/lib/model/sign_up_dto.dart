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
  Map<String, String> collabTools;

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
      'collabTools': collabTools,
    };
  }
}
