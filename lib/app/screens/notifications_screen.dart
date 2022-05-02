import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:gas_out_app/app/stores/notifications/notifications_store.dart';
import 'package:gas_out_app/data/repositories/notifications_repository.dart';
import 'package:gas_out_app/main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kf_drawer/kf_drawer.dart';
import '../components/notification_tiles_component.dart';

class Notifications extends KFDrawerContent {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  NotificationsStore _store = NotificationsStore();

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
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
                  Text(
                    'Notificações',
                    style: GoogleFonts.roboto(
                      fontSize: 22,
                      color: primaryColor,
                      fontWeight: FontWeight.w400,
                    ),
                  )
                ],
              ),
              Expanded(
                child: Scaffold(
                  body: _buildBaseBody(),
                ),
              ),

            ],
          ),
        ),
      );
    });
  }

  Widget _buildBaseBody() {
    if (_store.model == null) {
      return Center(
        child: const CircularProgressIndicator(),
      );
    } else {
      return ListView(
          physics: ClampingScrollPhysics(),
          padding: EdgeInsets.zero,
          children: _store.model!
              .map(
                (e) => NotificationTiles(
                    title: e.title, body: e.message, onLongPress: () {}),
              )
              .toList());
    }
  }

  // Widget _buildBaseBody(BuildContext context) {
  //   return FutureBuilder(
  //     future: _repository.getNotifications(),
  //     builder: (BuildContext context, AsyncSnapshot snapshot) {
  //       if (snapshot.hasData == false) {
  //         return Center(
  //           child: const CircularProgressIndicator(),
  //         );
  //       } else {
  //         return ListView(
  //           physics: ClampingScrollPhysics(),
  //           padding: EdgeInsets.zero,
  //           children: snapshot.data
  //               .map(
  //                 (e) => NotificationTiles(
  //                     title: e.title, body: e.message, onLongPress: () {}),
  //               )
  //               .toList(),
  //           // final notification = snapshot.data[index];
  //           // print(notification);

  //           //  NotificationTiles(
  //           //   title: notifications.title,
  //           //   body: notification.message,
  //           //   onLongPress: () async {
  //           //     // var urlLocal = Uri.parse(
  //           //     //     "https://gas-out-api.herokuapp.com/notification/delete" +
  //           //     //         notification.id.toString());
  //           //     // Map<String, String> headers = {
  //           //     //   'Content-Type': 'application/json; charset=UTF-8',
  //           //     // };

  //           //     // final response =
  //           //     //     await http.delete(urlLocal, headers: headers);

  //           //     // if (response.statusCode == 200) {
  //           //     //   print('Exclusão bem sucedida!');
  //           //     // } else {
  //           //     //   print('Erro na requisição.');
  //           //     // }
  //         );
  //       }
  //     },
  //   );
  // }
}
