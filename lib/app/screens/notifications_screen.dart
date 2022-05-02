import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gas_out_app/main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kf_drawer/kf_drawer.dart';
import 'package:http/http.dart' as http;

import '../../data/model/notification_response_model.dart';
import '../components/notification_tiles_component.dart';

class Notifications extends KFDrawerContent {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  child: Material(
                    shadowColor: Colors.transparent,
                    color: Colors.transparent,
                    child: IconButton(
                      icon: Icon(
                        Icons.menu,
                        color: Colors.black,
                      ),
                      onPressed: widget.onMenuPressed,
                    ),
                  ),
                ),
                SizedBox(
                  width: 95,
                ),
                Text('Notificações',
                    style: GoogleFonts.roboto(
                        fontSize: 22,
                        color: primaryColor,
                        fontWeight: FontWeight.w400))
              ],
            ),
            Expanded(
              child: Scaffold(
                body: _buildBaseBody(context)

                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<List<NotificationResponseModel>> _getNotifications() async {
    var response = await http.get(Uri.parse('https://gas-out-api.herokuapp.com/notification/find-all-recent'));

    var jsonData = json.decode(response.body);

    print(jsonData);

    List<NotificationResponseModel> notifications = [];

    // ???
    for(var json in jsonData){
      NotificationResponseModel notification = NotificationResponseModel(message: json['message'], title: json['title'], id: json['id'], date: json['date']);

      print(notification);

      notifications.add(notification);
    }

    // print(notifications.length);
    return notifications;
  }

  Widget _buildBaseBody(BuildContext context) {
    return FutureBuilder(
      future: _getNotifications(),
      builder: (BuildContext context, AsyncSnapshot snapshot){
        if(snapshot.data == null){
          return Center(
            child: const CircularProgressIndicator(),
          );
        } else {
          return ListView.separated(
              physics: ClampingScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                final notification = snapshot.data[index];
                print(notification);

                return NotificationTiles(
                    title: notification.title,
                    body: notification.message,
                    onLongPress: () async {
                      var urlLocal = Uri.parse(
                          "https://gas-out-api.herokuapp.com/notification/delete" +
                              notification.id.toString());
                      Map<String, String> headers = {
                        'Content-Type': 'application/json; charset=UTF-8',
                      };

                      final response = await http.delete(
                          urlLocal, headers: headers);

                      if (response.statusCode == 200) {
                        print('Exclusão bem sucedida!');
                      } else {
                        print('Erro na requisição.');
                      }
                    });
              },
              separatorBuilder: (context, int index) {
                return Divider();
              });
        }
      },
    );
  }
}
