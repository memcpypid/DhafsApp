class UserModel {
  final String birthDate;
  final String email;
  final String phoneNumber;
  final String role;
  final String username;

  UserModel({
    required this.birthDate,
    required this.email,
    required this.phoneNumber,
    required this.role,
    required this.username,
  });

  // Factory method untuk membuat objek dari JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      birthDate: json['birthDate'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      role: json['role'],
      username: json['username'],
    );
  }

  // Method untuk mengonversi objek ke JSON
  Map<String, dynamic> toJson() {
    return {
      'birthDate': birthDate,
      'email': email,
      'phoneNumber': phoneNumber,
      'role': role,
      'username': username,
    };
  }
}
