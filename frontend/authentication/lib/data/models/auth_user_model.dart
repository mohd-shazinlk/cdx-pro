import '../../domain/entities/auth_user.dart';

class AuthUserModel extends AuthUser {
  AuthUserModel({required super.id, required super.name, required super.email});

  factory AuthUserModel.fromJson(Map<String, dynamic> json) {
    return AuthUserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
    );
  }
}
