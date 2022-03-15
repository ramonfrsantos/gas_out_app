import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:gas_check_app/firebase_messaging/custom_firebase_messaging.dart';
import 'package:gas_check_app/screens/base_screen.dart';
import 'package:gas_check_app/stores/signup_store.dart';
import 'package:get_it/get_it.dart';

import 'helpers/extensions.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  setupLocators();
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Firebase.initializeApp();
  await CustomFirebaseMessaging().initialize();
  await CustomFirebaseMessaging().getTokenFirebase();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
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
      title: 'Gas Check!',
      theme: _buildShrineTheme(),
      initialRoute: '/home',
      routes: {
        '/home': (_) => BaseScreen(title: 'Home Page'),
        '/virtual': (_) => Scaffold(
          appBar: AppBar(),
          body: const SizedBox.expand(
            child: Center(child: Text('Virtual Page')),
          ),
        )
      },
    );
  }
}

IconThemeData _customIconTheme(IconThemeData original) {
  return original.copyWith(color: shrinePurple900);
}

ThemeData _buildShrineTheme() {
  final ThemeData base = ThemeData.dark();
  return base.copyWith(
    primaryColor: shrineBlack100,
    scaffoldBackgroundColor: shrineBlack400,
    cardColor: shrineBlack400,
    errorColor: shrineErrorRed,
    buttonTheme: const ButtonThemeData(
      colorScheme: _shrineColorScheme,
      textTheme: ButtonTextTheme.normal,
    ),
    primaryIconTheme: _customIconTheme(base.iconTheme),
    textTheme: _buildShrineTextTheme(base.textTheme),
    primaryTextTheme: _buildShrineTextTheme(base.primaryTextTheme),
    iconTheme: _customIconTheme(base.iconTheme), colorScheme: _shrineColorScheme.copyWith(secondary: shrinePurple900),
  );
}

const ColorScheme _shrineColorScheme = ColorScheme(
  primary: shrinePurple900,
  secondary: shrinePurple900,
  surface: shrineBlack400,
  background: shrineBlack400,
  error: shrineErrorRed,
  onPrimary: shrinePurple900,
  onSecondary: Colors.white,
  onSurface: shrinePurple900,
  onBackground: shrinePurple900,
  onError: shrineBlack400,
  brightness: Brightness.dark,
);

TextTheme _buildShrineTextTheme(TextTheme base) {
  return base
      .copyWith(
    headline5: base.headline5!.copyWith(
      fontWeight: FontWeight.w900,
      letterSpacing: defaultLetterSpacing,
    ),
    headline6: base.headline6!.copyWith(
      fontWeight: FontWeight.w900,
      fontSize: 18,
      letterSpacing: defaultLetterSpacing,
    ),
    caption: base.caption!.copyWith(
      fontWeight: FontWeight.w400,
      fontSize: 14,
      letterSpacing: defaultLetterSpacing,
    ),
    bodyText1: base.bodyText1!.copyWith(
      fontWeight: FontWeight.w900,
      fontSize: 16,
      letterSpacing: defaultLetterSpacing,
    ),
    bodyText2: base.bodyText2!.copyWith(
      fontWeight: FontWeight.w900,
      letterSpacing: defaultLetterSpacing,
    ),
    subtitle1: base.subtitle1!.copyWith(
      fontWeight: FontWeight.w900,
      letterSpacing: defaultLetterSpacing,
    ),
    headline4: base.headline4!.copyWith(
      fontWeight: FontWeight.w900,
      letterSpacing: defaultLetterSpacing,
    ),
    button: base.button!.copyWith(
      fontWeight: FontWeight.w900,
      fontSize: 14,
      letterSpacing: defaultLetterSpacing,
    ),
  )
      .apply(
    fontFamily: 'UniSans-Thin',
    displayColor: shrinePurple900,
    bodyColor: shrineSurfaceWhite,
  );
}