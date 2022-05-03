import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:gas_out_app/app/stores/notifications/notifications_store.dart';
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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
                      color: primaryColor,
                      fontWeight: FontWeight.w400,
                    ),
                  )
                ],
              ),
              Expanded(
                child: Scaffold(
                  key: _scaffoldKey,
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
      return ListView(
              physics: ClampingScrollPhysics(),
              padding: EdgeInsets.zero,
              children: _store.notificationList!
                  .map(
                    (notification) => Dismissible(
                  direction: DismissDirection.startToEnd,
                  key: Key(notification.message),
                  child: Card(
                    child: NotificationTiles(
                        title: notification.title, body: notification.message, date: notification.date),
                  ),
                  onDismissed: (direction) {
                    var notificationChosen = notification;
                    _showAlertDialog(context, notificationChosen.id);
                  },
                  background: _deleteBgItem()
                )
              ).toList());
    }
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

  _showAlertDialog(BuildContext context, int id) {
    Widget cancelaButton = TextButton(
      child: Text("Não", style: GoogleFonts.roboto()),
      onPressed: () {
        Navigator.of(context).pop();
        _buildBaseBody();
      },
    );
    Widget continuaButton = TextButton(
      child: Text("Sim", style: GoogleFonts.roboto()),
      onPressed: () {
        _store.deleteNotification(id);
        Navigator.of(context).pop();
        _buildBaseBody();
      },
    );
    //configura o AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Atenção!", style: GoogleFonts.roboto(fontSize: 24)),
      content: Text("Deseja realmente excluir a notificação?",
          style: GoogleFonts.roboto()),
      actions: [
        cancelaButton,
        continuaButton,
      ],
    );
    //exibe o diálogo
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
