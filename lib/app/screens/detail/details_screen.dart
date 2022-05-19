import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gas_out_app/data/repositories/notification/notification_repository.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import '../../../data/model/notiification/notification_firebase_model.dart';
import '../../../main.dart';
import '../../constants/gasout_constants.dart';

class DetailsScreen extends StatefulWidget {
  final imgPath;
  final double averageValue;
  final double maxValue;
  final int totalHours;
  final String? email;
  final String? roomName;

  DetailsScreen(
      {Key? key,
      this.imgPath,
      required this.averageValue,
      required this.maxValue,
      required this.totalHours,
      required this.email,
      required this.roomName
      })
      : super(key: key);

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  bool sprinklersValue = false;
  bool alarmValue = false;
  bool notificationValue = false;

  NotificationModel? _notification;
  final NotificationRepository notificationRepository =
      NotificationRepository();

  @override
  void initState() {
    setValues();
    _generateNotification();
    super.initState();
  }

  setValues() {
    widget.averageValue > 0 ? alarmValue = true : alarmValue = false;
    widget.averageValue > 0
        ? notificationValue = true
        : notificationValue = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          new Container(
            height: MediaQuery.of(context).size.height-300,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(widget.imgPath), fit: BoxFit.cover)
            ),
          ),
          new Padding(
            padding: EdgeInsets.only(top: 40),
            child: new Row(
              children: <Widget>[
                new IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    size: 30,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                ),
                SizedBox(width: 15)
              ],
            ),
          ),
          new Align(
            alignment: Alignment.bottomCenter,
            child: Container(
                width: MediaQuery.of(context).size.width,
                height: 340,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: new Column(
                    children: <Widget>[
                      SizedBox(height: 28),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          listItemStats(
                            imgpath: 'assets/images/notification.png',
                            name: "Notificações",
                            value: notificationValue,
                            onChanged: (value) {
                              setState(() {
                                notificationValue = value;
                              });
                            },
                          ),
                          listItemStats(
                            imgpath: 'assets/images/creative.png',
                            name: "Alarme",
                            value: alarmValue,
                            onChanged: (value) {
                              setState(() {
                                alarmValue = value;
                              });
                            },
                          ),
                          listItemStats(
                            imgpath: 'assets/images/sprinkler.png',
                            name: "Sprinklers",
                            value: sprinklersValue,
                            onChanged: (value) {
                              if (widget.averageValue >= 50) {
                                sprinklersValue == false
                                    ? _showAlertDialog(context, () {
                                        setState(() {
                                          sprinklersValue = value;
                                        });
                                      })
                                    : setState(() {
                                        sprinklersValue = value;
                                      });
                              } else {
                                value = false;
                              }
                            },
                          ),
                        ],
                      ),
                      Padding(
                          padding: EdgeInsets.only(top: 10, left: 20, right: 20),
                          child: Divider(
                            color: Colors.black26,
                          )),
                      SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Row(
                          children: <Widget>[
                            Text(
                              "Valor Máximo Atingido",
                              style: new TextStyle(color: Colors.black87,fontSize: 18),
                            ),
                            Spacer(),
                            Text(
                              widget.maxValue.toString() + "%",
                              style: new TextStyle(color: Colors.black87,fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Row(
                          children: <Widget>[
                            Text(
                              "Total de Horas Monitoradas",
                              style: new TextStyle(color: Colors.black87,fontSize: 18),
                            ),
                            Spacer(),
                            Text(
                              widget.totalHours.toString(),
                              style: new TextStyle(color: Colors.black87,fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Row(
                          children: <Widget>[
                            Text(
                              "Valor Médio Diário",
                              style: new TextStyle(color: Colors.black87,fontSize: 18),
                            ),
                            Spacer(),
                            Text(
                              widget.averageValue.toString() + "%",
                              style: new TextStyle(color: Colors.black87,fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
          )
        ],
      ),
    );
  }

  Widget listItemStats({
    required String imgpath,
    required String name,
    required bool value,
    Function(bool value)? onChanged,
  }) {
    return Container(
      width: 105,
      height: 135,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: value == true
              ? ConstantColors.primaryColor
              : ConstantColors.thirdColor),
      child: Column(
        children: <Widget>[
          SizedBox(height: 10),
          Image(
              image: AssetImage(imgpath),
              width: 45,
              height: 45,
              color: value == true ? Colors.white : Colors.white),
          SizedBox(height: 10),
          Text(name,
              style: TextStyle(
                  fontSize: 14,
                  color: value == true ? Colors.white : Colors.white)),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
          )
        ],
      ),
    );
  }

  _showAlertDialog(BuildContext context, Function funcao) {
    Widget cancelaButton = TextButton(
      child: Text("Cancelar", style: GoogleFonts.muli(fontSize: 16)),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continuaButton = TextButton(
      child: Text("Continuar", style: GoogleFonts.muli(fontSize: 16)),
      onPressed: () {
        Navigator.of(context).pop();
        funcao();
      },
    );
    //configura o AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Atenção!", style: GoogleFonts.muli(fontSize: 24)),
      content: Text("Deseja realmente acionar os sprinklers? Isso possivelmente causará alagamento do local.",
          style: GoogleFonts.muli(fontSize: 20)),
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

  Future<void> _generateNotification() async {
    String title = "";
    String body = "";

    if (widget.averageValue == 0) {
      title = "Apenas atualização de status...";
      body = "Tudo em paz! Sem vazamento de gás no momento.";
    } else if (widget.averageValue > 0 && widget.averageValue <= 24) {
      title = "Atenção! Verifique as opções de monitoramento."; // Colocar emoji de sirene
      body = "Detectamos nível BAIXO de vazamento em seu local!";
    } else if (widget.averageValue > 24 && widget.averageValue < 52) {
      title = "Atenção! Verifique as opções de monitoramento."; // Colocar emoji de sirene
      body = "Detectamos nível MÉDIO de vazamento em seu local!";
    } else if (widget.averageValue >= 52) {
      title = "Detectamos nível ALTO de vazamento em seu local!";
      body =
          "Entre agora em opções de monitoramento do seu cômodo para acionamento dos SPRINKLES ou acione o SUPORTE TÉCNICO.";
    }

    final NotificationModel? notification = await notificationRepository
        .createNotificationFirebase(title, body, widget.email, token);

    setState(() {
      _notification = notification;
    });
  }
}
