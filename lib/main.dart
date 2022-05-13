import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:gas_out_app/app/screens/login/login_screen.dart';
import 'package:gas_out_app/app/stores/controller/login/login_controller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kf_drawer/kf_drawer.dart';
import 'package:gas_out_app/app/helpers/dependency_injection.dart' as di;
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:ndialog/ndialog.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'app/config/app_config.dart';
import 'app/config/environments.dart';
import 'app/constants/gasout_constants.dart';
import 'app/screens/home/home_screen.dart';
import 'app/screens/notification/notification_screen.dart';
import 'app/screens/stats/stats_screen.dart';
import 'data/firebase_messaging/custom_firebase_messaging.dart';
import 'data/model/class_builder_model.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

String token = "";

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  AppConfig.getInstance(config: Environment.dev);

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  di.init();
  await Firebase.initializeApp();
  await CustomFirebaseMessaging().initialize();
  await CustomFirebaseMessaging().getTokenFirebase().then((getTokenString) {
    if (getTokenString != null) {
      token = getTokenString;
      print("TOKEN: " + token);
    }
  });

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
    FlutterNativeSplash.remove();
  });
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme:
          ThemeData(primarySwatch: MaterialColor(0xFFc70000, color)).copyWith(
        textTheme: GoogleFonts.muliTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
      // MainWidget(
      //   title: 'Gas Out',
      // ),
    );
  }
}

class MainWidget extends StatefulWidget {
  MainWidget({Key? key, required this.title, this.username, this.email})
      : super(key: key);
  final String title;
  final String? username;
  final String? email;

  @override
  _MainWidgetState createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> with TickerProviderStateMixin {
  String statusText = "Status Text";
  bool isConnected = false;
  TextEditingController idTextController = TextEditingController();

  final MqttServerClient client =
      MqttServerClient('aulwdm3oigmf5-ats.iot.us-east-1.amazonaws.com', '');

  late KFDrawerController _drawerController;
  LoginController loginController = LoginController();

  @override
  void initState() {
    super.initState();
    ClassBuilder.registerNotification(widget.email);
    ClassBuilder.registerStats();
    ClassBuilder.registerHome(widget.username, widget.email, client);
    print(widget.username);
    print(widget.email);

    _drawerController = KFDrawerController(
      initialPage: ClassBuilder.fromString('HomeScreen'),
      items: [
        KFDrawerItem.initWithPage(
          text: Text('Página Inicial',
              style: TextStyle(color: Colors.white, fontSize: 18)),
          icon: Icon(Icons.home, color: Colors.white),
          page: HomeScreen(
            username: widget.username,
            email: widget.email,
            client: client
          ),
        ),
        KFDrawerItem.initWithPage(
          text: Text(
            'Notificações',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          icon: Icon(Icons.notifications_active, color: Colors.white),
          page: NotificationScreen(
            email: widget.email,
          ),
        ),
        KFDrawerItem.initWithPage(
          text: Text(
            'Análise Geral',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          icon: Icon(Icons.trending_up, color: Colors.white),
          page: StatsScreen(),
        ),
        KFDrawerItem.initWithPage(
          text: Text(
            'Acionar suporte',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          icon: Image.asset(
            "assets/images/icWhatsApp.png",
            color: Colors.white,
            width: 26,
            height: 26,
          ),
          onPressed: () {
            String url =
                'whatsapp://send?phone=${ConstantsSupport.phone}&text=${ConstantsSupport.message}';
            launchUrlString(url);
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);

    return Scaffold(
      body: KFDrawer(
        controller: _drawerController,
        menuPadding: EdgeInsets.only(left: 15),
        header: Padding(
          padding: EdgeInsets.only(top: 15),
          child: Row(
            children: [
              Container(
                height: 80,
                width: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/logoPequenaBranco.png'),
                      fit: BoxFit.fitHeight,
                      opacity: 1.0),
                ),
              ),
              SizedBox(
                width: 150,
                height: 125,
              )
            ],
          ),
        ),
        footer: Padding(
          padding: EdgeInsets.only(top: 30, left: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 200,
                height: 50,
                child: isConnected ? TextButton(
                    onPressed: _disconnect,
                    child: Text("Desconectar")
                ) : TextFormField(
                  controller: idTextController,
                  enabled: !isConnected,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(left: 10, top: 5),
                      labelText: 'MQTT Client ID',
                      labelStyle: TextStyle(fontSize: 10),
                      suffixIcon: IconButton(
                          onPressed: _connect,
                          icon: Icon(Icons.subdirectory_arrow_left)
                      )
                  ),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Colors.white,
                ),
              ),
              SizedBox(
                width: 20,
              )
            ],
          ),
        ),
        decoration: BoxDecoration(
          color: ConstantColors.primaryColor,
          // gradient: LinearGradient(
          //   begin: Alignment.centerLeft,
          //   end: Alignment.centerRight,
          //   colors: [
          //     ConstantColors.primaryColor,
          //     ConstantColors.secondaryColor
          //   ],
          //   tileMode: TileMode.repeated,
          // ),
        ),
      ),
    );
  }

  _connect() async {
    if(idTextController.text.trim().isNotEmpty){
      print(idTextController.text.trim());
      ProgressDialog progressDialog = ProgressDialog(
        context,
        blur: 0,
        dialogTransitionType: DialogTransitionType.Shrink,
        dismissable: false,
      );
      progressDialog.setLoadingWidget(CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(Colors.red),
      ));
      progressDialog.setMessage(
          Text("Aguarde, conectando ao AWS MQTT Broker..."));
      progressDialog.setTitle(Text("Conectando"));
      progressDialog.show();

      isConnected = await mqttConnect(idTextController.text.trim());
      progressDialog.dismiss();

      Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(username: widget.username, email: widget.email, client: client)));
    }
  }

  _disconnect() {
    client.disconnect();
  }

  Future<bool> mqttConnect(String uniqueId) async {
    setStatus("Conectando ao MQTT Broker...");
    ByteData rootCA = await rootBundle.load('assets/certs/RootCA.pem');
    ByteData deviceCert =
        await rootBundle.load('assets/certs/DeviceCertificate.crt');
    ByteData privateKey = await rootBundle.load('assets/certs/Private.key');

    SecurityContext context = SecurityContext.defaultContext;
    context.setClientAuthoritiesBytes(rootCA.buffer.asUint8List());
    context.useCertificateChainBytes(deviceCert.buffer.asUint8List());
    context.usePrivateKeyBytes(privateKey.buffer.asUint8List());

    client.securityContext = context;
    client.logging(on: true);
    client.keepAlivePeriod = 20;
    client.port = 8883;
    client.secure = true;
    client.onConnected = onConnected;
    client.onDisconnected = onDisconnected;
    client.pongCallback = pong;

    final MqttConnectMessage connMess =
        MqttConnectMessage().withClientIdentifier(uniqueId).startClean();
    client.connectionMessage = connMess;

    await client.connect();
    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      print("Conectado ao AWS com sucesso.");
    } else {
      return false;
    }

    const topic = 'localgateway_to_awsiot';
    client.subscribe(topic, MqttQos.atMostOnce);

    return true;
  }

  void setStatus(String content) {
    setState(() {
      statusText = content;
    });
  }

  void onConnected() {
    setStatus("A conexão do cliente foi bem sucedida.");
  }

  void onDisconnected() {
    setStatus("Cliente desconectado.");
    isConnected = false;
  }

  void pong() {
    print('Ping response client callback invoked');
  }
}

Map<int, Color> color = {
  50: Color.fromRGBO(199, 0, 0, .1),
  100: Color.fromRGBO(199, 0, 0, .2),
  200: Color.fromRGBO(199, 0, 0, .3),
  300: Color.fromRGBO(199, 0, 0, .4),
  400: Color.fromRGBO(199, 0, 0, .5),
  500: Color.fromRGBO(199, 0, 0, .6),
  600: Color.fromRGBO(199, 0, 0, .7),
  700: Color.fromRGBO(199, 0, 0, .8),
  800: Color.fromRGBO(199, 0, 0, .9),
  900: Color.fromRGBO(199, 0, 0, 1),
};
