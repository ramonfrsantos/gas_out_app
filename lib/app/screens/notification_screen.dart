import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:gas_out_app/app/constants/gasout_constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kf_drawer/kf_drawer.dart';
import '../components/notification_tiles_component.dart';
import '../stores/notification/notification_store.dart';

class Notifications extends KFDrawerContent {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  NotificationStore _store = NotificationStore();
  String email = "ramonfrsantos@outlook.com";

  @override
  void initState() {
    super.initState();
  }

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
                      color: ConstantColors.primaryColor,
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
    if (_store.notificationList == null) {
      return Center(
        child: const CircularProgressIndicator(),
      );
    } else {
      return RefreshIndicator(
        child: ListView(
                padding: EdgeInsets.zero,
                children: _store.notificationList!
                    .map(
                      (notification) => Dismissible(
                    direction: DismissDirection.startToEnd,
                    key: UniqueKey(),
                    child: Card(
                      child: NotificationTiles(
                          title: notification.title, body: notification.message, date: notification.date),
                    ),
                    onDismissed: (direction) {
                      var notificationChosen = notification;
                      _showAlertDialog(context, notificationChosen.id, email);
                    },
                    background: _deleteBgItem()
                  )
                ).toList()),
        onRefresh: _refresh,
      );
    }
  }

  Future<void> _refresh() async {
    await _store.getUserNotifications(email);

    setState(() {
      _store.notificationList;
    });

    return Future.delayed(Duration(
        seconds: 1
    ));
  }

  Widget _deleteBgItem() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(left: 20),
      color: Colors.red,
      child: Icon(
        Icons.delete,
        color: Colors.white,
      ),
    );
  }

  _showAlertDialog(BuildContext context, int id, String email) {
    Widget cancelaButton = TextButton(
      child: Text("NÃO", style: GoogleFonts.roboto(
          fontSize: 16,
      )),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continuaButton = TextButton(
      child: Text("SIM", style: GoogleFonts.roboto(
          fontSize: 16,
      )),
      onPressed: () async {
        await _store.deleteNotification(id, email);
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Atenção!", style: GoogleFonts.roboto(
          fontSize: 24
      )),
      content: Text("Você deseja realmente excluir essa notificação?", style: GoogleFonts.roboto(
          fontSize: 18
      )),
      actions: [
        cancelaButton,
        continuaButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
