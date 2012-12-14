class RegisterRequest {
  final String fullName;
  final String academicId;
  final String universityEmail;
  final String password;

  RegisterRequest({
    required this.fullName,
    required this.academicId,
    required this.universityEmail,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'academicId': academicId,
      'universityEmail': universityEmail,
      'password': password,
    };
  }
}