import 'package:flutter/material.dart';
import 'package:kf_drawer/kf_drawer.dart';

import '../../data/model/notification_model.dart';

class Notifications extends KFDrawerContent {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  NotificationModel? _notification;

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
  }

  Widget _buildBaseBody() {
    return Container(
      padding: EdgeInsets.all(32),
      child: Column(
        children: [
          Text(
            "Teste de notificação",
          ),
          SizedBox(
            height: 32,
          ),
          _notification == null
              ? Text("A notificação NÃO foi enviada.")
              : Text(_notification.toString())
        ],
      ),
    );
  }
}