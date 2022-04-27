import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:gas_out_app/firebase_messaging/custom_firebase_messaging.dart';
import 'package:gas_out_app/screens/home.dart';
import 'package:gas_out_app/stores/signup_store.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kf_drawer/kf_drawer.dart';
import 'model/class_builder.dart';
import 'screens/contact.dart';
import 'screens/stats.dart';
import 'package:gas_out_app/helpers/dependency_injection.dart' as di;

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

String token = "";

Future<void> main() async {
  setupLocators();
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
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
    ClassBuilder.registerClasses();
    runApp(MyApp());
    FlutterNativeSplash.remove();
  });
}

void setupLocators() {
  GetIt.I.registerSingleton(SignUpStore());
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
        primarySwatch: Colors.blue,
      ).copyWith(
        textTheme: GoogleFonts.firaCodeTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: MainWidget(
        title: 'Gas Out',
      ),
    );

    // return MaterialApp(
    //   title: 'Gas OUT!',
    //   theme: _buildShrineTheme(),
    //   initialRoute: '/home',
    //   routes: {
    //     '/home': (_) => BaseScreen(title: 'Home Page', token: token),
    //     '/virtual': (_) => Scaffold(
    //       appBar: AppBar(),
    //       body: const SizedBox.expand(
    //         child: Center(child: Text('Virtual Page')),
    //       ),
    //     )
    //   },
    // );
  }
}

class MainWidget extends StatefulWidget {
  MainWidget({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MainWidgetState createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> with TickerProviderStateMixin {
  late KFDrawerController _drawerController;

  @override
  void initState() {
    super.initState();
    _drawerController = KFDrawerController(
      initialPage: ClassBuilder.fromString('Home'),
      items: [
        KFDrawerItem.initWithPage(
          text: Text('Página Inicial',
              style: TextStyle(color: Colors.white, fontSize: 18)),
          icon: Icon(Icons.home, color: Colors.white),
          page: Home(),
        ),
        KFDrawerItem.initWithPage(
          text: Text(
            'Notificações',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          icon: Icon(Icons.notifications_active, color: Colors.white),
          page: ClassBuilder.fromString('Notifications'),
        ),
        KFDrawerItem.initWithPage(
          text: Text(
            'Análise Geral',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          icon: Icon(Icons.trending_up, color: Colors.white),
          page: Stats(),
        ),
        KFDrawerItem.initWithPage(
          text: Text(
            'Acionar técnico',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          icon: Icon(Icons.message, color: Colors.white),
          page: Contact(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
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
              Color.fromRGBO(199, 86, 17, 1.0),
              Color.fromRGBO(246, 172, 140, 1.0)
            ],
            tileMode: TileMode.repeated,
          ),
        ),
      ),
    );
  }
}
