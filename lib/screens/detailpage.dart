import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gas_out_app/helpers/global.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';

import '../main.dart';
import '../model/notification_model.dart';

 class DetailPage extends StatefulWidget {
  final imgPath;
  final double averageValue;
  final double maxValue;
  int totalHours;

  DetailPage(
      {Key? key,
      this.imgPath,
      required this.averageValue,
      required this.maxValue,
      required this.totalHours})
      : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool sprinklersValue = false;
  bool alarmValue = false;
  bool notificationValue = false;

  NotificationModel? _notification;

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
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(widget.imgPath), fit: BoxFit.cover)),
          ),
          new Padding(
            padding: EdgeInsets.only(top: 15),
            child: new Row(
              children: <Widget>[
                new IconButton(
                  icon: Icon(
                    Icons.arrow_back,
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
                height: 360,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                  color: Color.fromRGBO(250, 193, 157, 0.68),
                ),
                child: new Column(
                  children: <Widget>[
                    SizedBox(height: 22),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        listItemStats(
                          imgpath: 'images/notification.png',
                          name: "Notificações",
                          value: notificationValue,
                          onChanged: (value) {
                            setState(() {
                              notificationValue = value;
                            });
                          },
                        ),
                        listItemStats(
                          imgpath: 'images/creative.png',
                          name: "Alarme",
                          value: alarmValue,
                          onChanged: (value) {
                            setState(() {
                              alarmValue = value;
                            });
                          },
                        ),
                        listItemStats(
                          imgpath: 'images/sprinkler.png',
                          name: "Sprinklers",
                          value: sprinklersValue,
                          onChanged: (value) {
                            if (widget.averageValue >= 50){
                              sprinklersValue == false
                                  ? showAlertDialog(context, () {
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
                          color: Colors.white,
                        )),
                    SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Row(
                        children: <Widget>[
                          Text(
                            "Valor Máximo Atingido",
                            style: new TextStyle(color: Colors.white),
                          ),
                          Spacer(),
                          Text(
                            widget.maxValue.toString() + "%",
                            style: new TextStyle(color: Colors.white),
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
                            style: new TextStyle(color: Colors.white),
                          ),
                          Spacer(),
                          Text(
                            widget.totalHours.toString(),
                            style: new TextStyle(color: Colors.white),
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
                            style: new TextStyle(color: Colors.white),
                          ),
                          Spacer(),
                          Text(
                            widget.averageValue.toString() + "%",
                            style: new TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: 5, left: 20, right: 20),
                        child: Divider(
                          color: Colors.white,
                        )),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 10),
                      child: Row(
                        children: <Widget>[
                          Text(
                            "Acionar monitoramento",
                            style: new TextStyle(color: Colors.white),
                          ),
                          Spacer(),
                          Switch(
                            value: detailPageStore.activeMonitoring,
                            onChanged: (newVal) {
                              setState(() {
                                detailPageStore.activeMonitoring = newVal;
                                if (newVal == false) {
                                  widget.totalHours = 0;
                                }

                                if (newVal == true) {
                                  startTimer();
                                }

                                // print(newVal);
                              });
                            },
                            activeColor: Colors.lightGreen,
                          )
                        ],
                      ),
                    ),
                  ],
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
      width: 120,
      height: 150,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: value == true
              ? Colors.white
              : Color.fromRGBO(210, 153, 117, 0.75)),
      child: Column(
        children: <Widget>[
          SizedBox(height: 15),
          Image(
              image: AssetImage(imgpath),
              width: 45,
              height: 45,
              color: value == true ? Colors.black : Colors.white),
          SizedBox(height: 15),
          Text(name,
              style: TextStyle(
                  fontSize: 13,
                  color: value == true ? Colors.black : Colors.white)),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.lightGreen,
          )
        ],
      ),
    );
  }

  showAlertDialog(BuildContext context, Function funcao) {
    Widget cancelaButton = TextButton(
      child: Text("Cancelar", style: GoogleFonts.roboto()),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continuaButton = TextButton(
      child: Text("Continuar", style: GoogleFonts.roboto()),
      onPressed: () {
        Navigator.of(context).pop();
        funcao();
      },
    );
    //configura o AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Atenção!", style: GoogleFonts.roboto(
        fontSize: 24
      )),
      content: Text("Deseja realmente acionar os sprinklers?", style: GoogleFonts.roboto()),
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

  late Timer _timer;
  int _start = 0;

  void startTimer() {
    const oneHour = const Duration(seconds: 3600);
    _timer = new Timer.periodic(
      oneHour,
      (Timer timer) {
        setState(() {
          _start++;
          widget.totalHours = _start;
          print(widget.totalHours);
        });
      },
    );
  }

  Future<void> _generateNotification() async {
    String title = "";
    String body = "";

    if(widget.averageValue == 0) {
      title = "Apenas atualização de status...";
      body = "Sem vazamento de gás no momento atual.";
    } else if(widget.averageValue > 0 && widget.averageValue < 50){
      title = "Verifique as opções de monitoramento";
      body = "Detectamos níveis baixos de vazamento em sua residência.";
    } else if (widget.averageValue >= 50) {
      title = "Nível ALTO de vazamento em sua residência!";
      body = "Entre agora em opções de monitoramento para acionamento dos sprinkles ou chame um técnico.";
    }

    final NotificationModel? notification =
        await create(title, body);

    setState(() {
      _notification = notification;
    });


  }

  Future<NotificationModel?> create(
      String title, String body) async {
    print(token);
    var url = Uri.parse("https://fcm.googleapis.com/fcm/send");

    Map<String,String> headers = {'Content-Type':'application/json','Authorization':'key=AAAASZ_kz40:APA91bHd7M5FzqhG1GoDKZilvUBHeaoB-YeHDbxtM8WyXrgtkZ8oFrt1us4wNcawELFZc1WFQusfpFWwyDRgUpWOtFEBSFnSBjBVrmnGqwA0Ojgbj5BoFUUeHfAfh8vgs5ieqm1mggHD'};

    final bodyJSON = jsonEncode({
      "registration_ids": [ token ],
      "notification": {"title": title, "body": body}
    });

    print(bodyJSON);
    print(headers);

    final response = await http.post(url,
        body: bodyJSON,
        headers: headers);

    print(response.body);

    if (response.statusCode == 200) {
      final String responseString = response.body;
      return notificationModelFromJson(responseString);
    } else {
      return null;
    }
  }
}
