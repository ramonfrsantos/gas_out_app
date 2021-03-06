import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:gas_out_app/data/model/notification_response_model.dart';

class NotificationsRepository {
  Future<List<NotificationResponseModel>> getNotifications() async {
    var response = await http.get(Uri.parse(
        'https://gas-out-api.herokuapp.com/notification/find-all-recent'));

    var jsonData = json.decode(response.body);
  print(jsonData);

    List<NotificationResponseModel> list = [];

    jsonData.map((el) {
      list.add(
        NotificationResponseModel.fromMap(el),
      );
    }).toList();


    return list;
  }

  Future<void> deleteNotification(int id) async {
    var urlLocal = Uri.parse(
        "https://gas-out-api.herokuapp.com/notification/delete/" +
            id.toString());
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };

    final response =
    await http.delete(urlLocal, headers: headers);

    if (response.statusCode == 200) {
      print('Exclusão bem sucedida!');
    } else {
      print('Erro na requisição.');
    }
  }
}
