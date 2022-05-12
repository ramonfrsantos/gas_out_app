import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:gas_out_app/app/screens/login/login_screen.dart';
import 'package:gas_out_app/app/stores/controller/login/login_controller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kf_drawer/kf_drawer.dart';
import 'package:gas_out_app/app/helpers/dependency_injection.dart' as di;
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
      theme: ThemeData(
        primarySwatch: MaterialColor(0xFFc70000, color)
    ).copyWith(
        textTheme: GoogleFonts.muliTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: LoginScreen()
      // MainWidget(
      //   title: 'Gas Out',
      // ),
    );
  }
}

class MainWidget extends StatefulWidget {
  MainWidget({Key? key, required this.title, this.username, this.email}) : super(key: key);
  final String title;
  final String? username;
  final String? email;

  @override
  _MainWidgetState createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> with TickerProviderStateMixin {
  late KFDrawerController _drawerController;
  LoginController loginController = LoginController();

  @override
  void initState() {
    super.initState();
    ClassBuilder.registerNotification(widget.email);
    ClassBuilder.registerStats();
    ClassBuilder.registerHome(widget.username);
    print(widget.username);
    print(widget.email);

    _drawerController = KFDrawerController(
      initialPage: ClassBuilder.fromString('HomeScreen'),
      items: [
        KFDrawerItem.initWithPage(
          text: Text('Página Inicial',
              style: TextStyle(color: Colors.white, fontSize: 18)),
          icon: Icon(Icons.home, color: Colors.white),
          page: HomeScreen(username: widget.username,),
        ),
        KFDrawerItem.initWithPage(
          text: Text(
            'Notificações',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          icon: Icon(Icons.notifications_active, color: Colors.white),
          page: NotificationScreen(email: widget.email,),
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
            "images/icWhatsApp.png",
            color: Colors.white,
            width: 26,
            height: 26,
          ),
          onPressed: () {
            String url = 'whatsapp://send?phone=${ConstantsSupport.phone}&text=${ConstantsSupport.message}';
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
        header: Row(
          children: [
            Container(
              height: 50,
              width: 200,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('images/logoPequenaBranco.png'),
                    fit: BoxFit.fitHeight,
                    opacity: 1.0),
              ),
            ),
            SizedBox(
              width: 150,
              height: 95,
            )
          ],
        ),
        footer: Container(),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              ConstantColors.primaryColor,
              ConstantColors.secondaryColor
            ],
            tileMode: TileMode.repeated,
          ),
        ),
      ),
    );
  }
}

Map<int, Color> color =
{
  50:Color.fromRGBO(199,0,0, .1),
  100:Color.fromRGBO(199,0,0, .2),
  200:Color.fromRGBO(199,0,0, .3),
  300:Color.fromRGBO(199,0,0, .4),
  400:Color.fromRGBO(199,0,0, .5),
  500:Color.fromRGBO(199,0,0, .6),
  600:Color.fromRGBO(199,0,0, .7),
  700:Color.fromRGBO(199,0,0, .8),
  800:Color.fromRGBO(199,0,0, .9),
  900:Color.fromRGBO(199,0,0, 1),
};
