import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kf_drawer/kf_drawer.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:image/image.dart' as img;

class StatsScreen extends KFDrawerContent {
  StatsScreen({
    Key? key, required this.client,
  });
  final MqttServerClient client;

  @override
  _StatsScreenState createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Column(
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
                      icon: Icon(
                        Icons.menu,
                        color: Colors.black,
                      ),
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
                      ),
                      onPressed: (){
                        _showLogOutAlertDialog(context);
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                      },
                    ),
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
  }

  Widget _buildBaseBody(){
    return Container(
      color: Colors.black,
      child: StreamBuilder(
        stream: widget.client.updates,
        builder: (context, snapshot){
          if(!snapshot.hasData){
            return Center(
              child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white),),
            );
          } else {
            final mqttReceivedMessages = snapshot.data as List<MqttReceivedMessage<MqttMessage>>?;
            final recMess = mqttReceivedMessages![0].payload as MqttPublishMessage;
            final messPub = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

            final messPubJsonValue = json.decode(messPub)['message'];

            print(messPubJsonValue);

            return Center(
              child: Text(
                messPubJsonValue,
                style: TextStyle(
                    color: Colors.white,
                  fontSize: 40
                ),
              ),
            );
          }
        },
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
      child: Text("Continuar", style: GoogleFonts.muli(fontSize: 16)),
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

}