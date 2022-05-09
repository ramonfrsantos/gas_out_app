import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../app/config/app_config.dart';
import '../../model/login/retorno_api_login_model.dart';
import '../../model/user/user_model.dart';

class LoginRepository {
  final Dio client = Dio();

  Future<RetornoApiLoginModel> login(String login, String senha) async {
    final String url = '${AppConfig.getInstance()!.apiBaseUrl}auth/login';

    var jsonBodyLogin = json.encode({
      "login": login,
      "password": senha,
      "tokenFirebase": "",
    });

    try {
      var response = await client.post(url, data: jsonBodyLogin);

      print(response.data);

      if (response.data['error'] != null) {
        return RetornoApiLoginModel(
          success: false,
          message: response.data['message'],
        );
      }

      return RetornoApiLoginModel(
        success: true,
        message: '',
        user: UserModel.fromMap(
          response.data['data'],
        ),
      );
    } catch (e) {
      print(e.toString());
      return RetornoApiLoginModel(
        success: false,
        message: e.toString(),
      );
    }
  }
}