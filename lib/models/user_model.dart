class UserModel {
  final String id;
  final String fullName;
  final String academicId;
  final String universityEmail;
  final String password;

  UserModel({
    required this.id,
    required this.fullName,
    required this.academicId,
    required this.universityEmail,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullName': fullName,
      'academicId': academicId,
      'universityEmail': universityEmail,
      'password': password,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      fullName: map['fullName'] ?? '',
      academicId: map['academicId'] ?? '',
      universityEmail: map['universityEmail'] ?? '',
      password: map['password'] ?? '',
    );
  }
}