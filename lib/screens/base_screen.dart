import 'package:bordered_text/bordered_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:gas_check_app/components/signup_button_component.dart';
import 'package:gas_check_app/helpers/extensions.dart';

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
  const BaseScreen({Key? key, required this.title}) : super(key:key);

  final String title;

  @override
  _BaseScreenState createState() => _BaseScreenState();
}


class _BaseScreenState extends State<BaseScreen> {

  void initState() {
    super.initState();
    initialization();
  }

  void initialization() async {
    // This is where you can initialize the resources needed by your app while
    // the splash screen is displayed.  Remove the following example because
    // delaying the user experience is a bad design practice!
    // ignore_for_file: avoid_print

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
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: shrineBlack400,
        toolbarHeight: 100,
        elevation: 0,
        title: BorderedText(
          strokeWidth: 10.0,
          strokeColor: shrinePurple900,
          child: Text(
            widget.title,
            style: TextStyle(
              fontSize: 40,
              fontFamily: 'UniSans-Heavy',
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: _buildBaseBody(),
      floatingActionButton: _listaFloatingButton(),
    );
  }

  Widget _buildBaseBody() {
    return Container(
      margin: EdgeInsets.only(bottom: 100),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SingUpButton(),
              SizedBox(
                height: 30,
              ),
              _buildCompartilhaButton(),
              SizedBox(
                height: 50,
              ),
              SizedBox(
                height: 300,
                width: 340,
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: GestureDetector(
                    onTap: (){},
                    child: Card(
                      margin: EdgeInsets.all(20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40.0),
                      ),
                      color: Colors.white,
                      elevation: 10,
                      clipBehavior: Clip.antiAlias,
                      child: Container(
                        padding: EdgeInsets.only(top: 15, right: 15),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            border:
                            Border.all(width: 4, color: shrinePurple900),
                            image: DecorationImage(
                              image: AssetImage("assets/images/cardFundo.png"),
                              colorFilter: new ColorFilter.mode(
                                  Colors.black.withOpacity(0.3),
                                  BlendMode.dstATop),
                              fit: BoxFit.cover,
                            )),
                        child: Center(
                          child: Image.asset(
                            'assets/images/logoApp.png',
                            width: 300,
                            height: 300,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Text(
                  "Clique para monitorar",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _listaFloatingButton() {
    return FloatingActionButton(
      onPressed: () {},
      tooltip: 'Lista de clientes',
      child: Icon(
        Icons.people,
        size: 40,
      ),
    );
  }

  Widget _buildCompartilhaButton() {
    return SizedBox(
      width: 250,
      height: 60,
      child: ElevatedButton(
        onPressed: () {},
        child: Text(
          'Compartilhamento',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
