import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:gas_out_app/main.dart';
import 'package:http/http.dart' as http;

import '../model/notification_model.dart';

class Message {
  String? title;
  String? body;
  String? message;
  Message(title, body, message) {
    this.title = title;
    this.body = body;
    this.message = message;
  }
}

class BaseScreen extends StatefulWidget {
  const BaseScreen({Key? key, required this.title, required this.token}) : super(key: key);

  final String title;
  final String token;

  @override
  _BaseScreenState createState() => _BaseScreenState();
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

class _BaseScreenState extends State<BaseScreen> {
  NotificationModel? _notification;

  final TextEditingController successController = TextEditingController();
  final TextEditingController messageIdController = TextEditingController();

  void initState() {
    super.initState();
    initialization();
  }

  void initialization() async {
    // print('ready in 3...');
    // await Future.delayed(const Duration(seconds: 1));
    // print('ready in 2...');
    // await Future.delayed(const Duration(seconds: 1));
    // print('ready in 1...');
    // await Future.delayed(const Duration(seconds: 1));
    // print('go!');
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);

    return Scaffold(
      appBar: AppBar(),
      body: _buildBaseBody(),
      floatingActionButton: _listaFloatingButton(),
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
              : Text("A notificação foi enviada!!!")
        ],
      ),
    );
  }

  Widget _listaFloatingButton() {
    return FloatingActionButton(
      onPressed: () async {
        final String title = "Atualização de status...";
        final String body = "Sem vazamento de gás no momento atual.";

        final NotificationModel? notification =
            await create(title, body);

        setState(() {
          _notification = notification;
        });
      },
      tooltip: 'Lista de clientes',
      child: Icon(
        Icons.message,
        size: 40,
      ),
    );
  }
}
