import 'dart:convert';

class RetornoApiLoginModel {
  final bool success;
  final String message;
  final dynamic user;

  RetornoApiLoginModel({
    required this.success,
    required this.message,
    this.user,
  });

  Map<String, dynamic> toMap() {
    return {
      'success': success,
      'message': message,
      'user': user,
    };
  }

  factory RetornoApiLoginModel.fromMap(Map<String, dynamic> map) {
    return RetornoApiLoginModel(
      success: map['success'],
      message: map['message'],
      user: map['user'] ?? null,
    );
  }

  String toJson() => json.encode(toMap());

  factory RetornoApiLoginModel.fromJson(String source) =>
      RetornoApiLoginModel.fromMap(json.decode(source));
}