import 'dart:convert';

class UserModel {
  final int userId;
  final String login;
  final String token;
  final String refreshToken;
  final String userName;

  UserModel({
    required this.userId,
    required this.login,
    required this.token,
    required this.refreshToken,
    required this.userName,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'login': login,
      'token': token,
      'refreshToken': refreshToken,
      'userName': userName,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userId: map['userId']?.toInt(),
      login: map['login'],
      token: map['token'],
      refreshToken: map['refreshToken'],
      userName: map['userName'],
    );
  }

  String toJson() => json.encode(toMap());
}
