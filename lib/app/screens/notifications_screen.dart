import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:gas_out_app/app/stores/notifications/notifications_store.dart';
import 'package:gas_out_app/main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kf_drawer/kf_drawer.dart';
import '../components/notification_tiles_component.dart';
import 'package:http/http.dart' as http;

class Notifications extends KFDrawerContent {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  NotificationsStore _store = NotificationsStore();
  late GlobalKey<RefreshIndicatorState> refreshKey;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    refreshKey = GlobalKey<RefreshIndicatorState>();
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
                  body: RefreshIndicator(
                    key: refreshKey,
                    child: _buildBaseBody(),
                    onRefresh: () async {
                      await refreshList();
                    },
                  ),
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
                (notification) => Dismissible(
                  key: Key(notification.message),
                  child: Card(
                    child: NotificationTiles(
                        title: notification.title, body: notification.message),
                  ),
                  onDismissed: (direction) {
                    var notificationChosen = notification;
                    showAlertDialog(context, deleteNotification(notificationChosen.id));
                  },
                  background: deleteBgItem(),
                  secondaryBackground: deleteBgItem(),
                ),
              )
              .toList());
    }
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

  Future<Null> refreshList() async {
    await Future.delayed(Duration(seconds: 1));
    _buildBaseBody();
    return null;
  }

  Widget deleteBgItem(){
    return Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.only(right: 20),
      color: Colors.red,
      child: Icon(
        Icons.delete, color: Colors.white,
      ),
    );
  }

  showAlertDialog(BuildContext context, Future<void> function) {
    Widget cancelaButton = TextButton(
      child: Text("Cancelar", style: GoogleFonts.roboto()),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continuaButton = TextButton(
      child: Text("Continuar", style: GoogleFonts.roboto()),
      onPressed: () {
        function;
        Navigator.of(context).pop();
      },
    );
    //configura o AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Atenção!", style: GoogleFonts.roboto(
          fontSize: 24
      )),
      content: Text("Deseja realmente excluir a notificação?", style: GoogleFonts.roboto()),
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
