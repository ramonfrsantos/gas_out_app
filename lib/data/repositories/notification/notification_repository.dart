import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:gas_out_app/data/model/notiification/notification_response_model.dart';

import '../../../app/config/app_config.dart';
import '../../../app/constants/gasout_constants.dart';
import '../../model/notiification/notification_firebase_model.dart';

class NotificationRepository {
  final Dio client = Dio();

  String baseUrl = AppConfig.getInstance()!.apiBaseUrl;

  Future<List<NotificationResponseModel>> getNotifications() async {
    final String url = '${baseUrl}notification/find-all-recent';
    print(url);
    try {
      var response = await client.get(
        url,
        options: Options(
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer ${ConstantToken.tokenRequests}'
          },
        ),
      );
      var jsonData = json.decode(response.data);
      print(jsonData);

      List<NotificationResponseModel> list = [];

      jsonData.map((el) {
        list.add(
          NotificationResponseModel.fromMap(el),
        );
      }).toList();

      return list;
    } catch (e) {
      print(e.toString());
      throw ('Erro na conexão');
    }
  }

  Future<void> deleteNotification(int id) async {
    final String url = '${baseUrl}notification/delete/${id.toString()}';
    print(url);

    try {
      await client.delete(
        url,
        options: Options(
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer ${ConstantToken.tokenRequests}'
          },
        ),
      );
    } catch (e) {
      print(e.toString());
      throw ('Erro na conexão');
    }
  }

  void createNotificationApp(String title, String body, String email) async {
    final String url = '${baseUrl}notification/create';
    print(url);

    final bodyJSON =
        jsonEncode({"message": body, "title": title, "email": email});

    try {
      var response = await client.post(
        url,
        data: bodyJSON,
        options: Options(
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer ${ConstantToken.tokenRequests}'
          },
        ),
      );
      var jsonData = json.decode(response.data);
      print(jsonData);
    } catch (e) {
      print(e.toString());
      throw ('Erro na conexão');
    }
  }

  Future<NotificationModel?> createNotificationFirebase(
      String title, String body, String email, String token) async {
    print(token);

    final String url = 'https://fcm.googleapis.com/fcm/send';
    print(url);

    final bodyJSON = jsonEncode(
      {
        "registration_ids": [token],
        "notification": {"title": title, "body": body}
      },
    );

    print(bodyJSON);
    try {
      var response = await client.post(
        url,
        data: bodyJSON,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization':
                'key=AAAASZ_kz40:APA91bHd7M5FzqhG1GoDKZilvUBHeaoB-YeHDbxtM8WyXrgtkZ8oFrt1us4wNcawELFZc1WFQusfpFWwyDRgUpWOtFEBSFnSBjBVrmnGqwA0Ojgbj5BoFUUeHfAfh8vgs5ieqm1mggHD'
          },
        ),
      );

      // var jsonData = json.decode(response.data);

      // print(jsonData.toString());

      createNotificationApp(title, body, email);

      return NotificationModel.fromJson(response.data);
    } catch (e) {
      print(e.toString());
      throw ('Erro na conexão');
    }
  }
}
