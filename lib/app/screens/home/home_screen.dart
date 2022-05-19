import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:gas_out_app/app/constants/gasout_constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kf_drawer/kf_drawer.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import '../../helpers/global.dart';
import '../../stores/controller/room/room_controller.dart';
import '../detail/details_screen.dart';

class HomeScreen extends KFDrawerContent {
  HomeScreen(
      {required this.username,
      required this.email,
      required this.client,
      required this.isConnected});

  final String? username;
  final String? email;
  final MqttServerClient client;
  late bool isConnected;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  RoomController _roomController = RoomController();

  @override
  void initState() {
    super.initState();
    _roomController.getUserRooms(widget.email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                      child: Material(
                        shadowColor: Colors.transparent,
                        color: Colors.transparent,
                        child: IconButton(
                          icon: Icon(Icons.menu, color: Colors.black, size: 30),
                          onPressed: widget.onMenuPressed,
                        ),
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                      child: Material(
                        shadowColor: Colors.transparent,
                        color: Colors.transparent,
                        child: IconButton(
                          icon: Icon(
                            Icons.exit_to_app,
                            color: Colors.black,
                            size: 30,
                          ),
                          onPressed: () {
                            _showLogOutAlertDialog(context);
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => LoginScreen()));
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                          "Olá, ${(widget.username == null ? "" : widget.username)?.split(' ')[0]}!",
                          style: TextStyle(
                              fontSize: 21, fontWeight: FontWeight.bold)),
                      SizedBox(height: 28),
                      Container(
                        padding: EdgeInsets.only(right: 20),
                        alignment: Alignment.center,
                        child: Image(
                          image: AssetImage('assets/images/logoPequena.png'),
                          width: 250,
                        ),
                      ),
                      SizedBox(height: 30),
                      Text(
                        "Faça o controle de vazamento de gás em seu ambiente residencial e/ou industrial.",
                        textAlign: TextAlign.justify,
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(height: 30),
                      Text("Escolha um cômodo",
                          style: TextStyle(
                              fontSize: 19, fontWeight: FontWeight.bold)),
                      SizedBox(height: 25),
                      Container(
                        padding: EdgeInsets.only(left: 15),
                        key: UniqueKey(),
                        height: 300,
                        width: double.infinity,
                        child: StreamBuilder(
                          stream: widget.client.updates,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              final mqttReceivedMessages = snapshot.data
                                  as List<MqttReceivedMessage<MqttMessage>>?;
                              final recMessBytes = mqttReceivedMessages![0]
                                  .payload as MqttPublishMessage;
                              final recMessString =
                                  MqttPublishPayload.bytesToStringAsString(
                                      recMessBytes.payload.message);

                              final recMessValue =
                                  json.decode(recMessString)['message'];

                              print(recMessValue.toInt());
                            }

                            return GridView.count(
                              primary: false,
                              padding: EdgeInsets.all(20),
                              mainAxisSpacing: 20,
                              crossAxisCount: 2,
                              children: <Widget>[
                                Row(
                                    children: _roomController.roomList!
                                        .map((notification) => _listItem(
                                            'assets/images/${notification.name.toLowerCase()}.jpg',
                                            notification.name,
                                            notification.sensorValue.toInt(),
                                            0,
                                            AssetImage(
                                                'assets/images/icon-${notification.name.toLowerCase()}.png')))
                                        .toList()),
                              ],
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 30),
                      Padding(
                          padding: EdgeInsets.only(top: 5, left: 20, right: 20),
                          child: Divider(
                            color: Colors.black54,
                          )),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 10),
                        child: Column(
                          children: [
                            Row(
                              children: <Widget>[
                                Text(
                                  "Horas de monitoramento",
                                  style: new TextStyle(color: Colors.black87),
                                ),
                                Spacer(),
                                Observer(builder: (_) {
                                  return Switch(
                                    value:
                                        monitoringController.activeMonitoring,
                                    onChanged: monitoringController.setValue,
                                    activeColor: ConstantColors.primaryColor,
                                  );
                                })
                              ],
                            ),
                            Text(
                              '* Reinicia a contagem de horas totais de monitoramento.',
                              style: TextStyle(
                                  fontSize: 12, color: Colors.black38),
                              textAlign: TextAlign.left,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _showLogOutAlertDialog(BuildContext context) {
    Widget cancelaButton = TextButton(
      child: Text("Cancelar", style: GoogleFonts.muli(fontSize: 16)),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continuaButton = TextButton(
      child: Text("Sair", style: GoogleFonts.muli(fontSize: 16)),
      onPressed: () {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      },
    );
    //configura o AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Atenção!", style: GoogleFonts.muli(fontSize: 24)),
      content: Text("Deseja realmente sair da sua conta?",
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

  Widget _listItem(String imgpath, String stringPath, int averageValue,
      double maxValue, AssetImage icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Stack(children: [
        InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => DetailsScreen(
                      imgPath: imgpath,
                      averageValue: averageValue,
                      maxValue: maxValue,
                      totalHours: monitoringController.monitoringTotalHours,
                      email: widget.email,
                      roomName: stringPath,
                    )));
          },
          child: Stack(alignment: Alignment.center, children: [
            Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: ConstantColors.primaryColor
                    .withOpacity(0.8), // image: DecorationImage(
                //     image: AssetImage(imgpath), fit: BoxFit.cover, opacity: 0.96),
              ),
            ),
            Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 60.0,
                  width: 60.0,
                  decoration: BoxDecoration(
                      image: DecorationImage(image: icon, fit: BoxFit.cover)),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  alignment: Alignment.center,
                  width: 120,
                  child: Text(stringPath,
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                )
              ],
            ),
          ]),
        )
      ]),
    );
  }
}
