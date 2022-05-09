import 'package:shared_preferences/shared_preferences.dart';

import '../../model/user/user_model.dart';

class UserRepository {
  Future<UserModel> getUser() async {
    final prefs = await SharedPreferences.getInstance();

    return UserModel(
      userId: prefs.getInt('id') ?? 0,
      login: prefs.getString('email') ?? '',
      token: prefs.getString('token') ?? '',
      refreshToken: prefs.getString('refresh_token') ?? '',
      userName: prefs.getString('name') ?? '',
    );
  }

  Future<void> saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt('id', user.userId);
    await prefs.setString('token', user.token);
    await prefs.setString('refresh_token', user.refreshToken);
    await prefs.setString('name', user.userName);
    await prefs.setString('email', user.login);
  }

  Future<bool> logout() async {
    final prefs = await SharedPreferences.getInstance();

    return await prefs.clear();
  }
}
