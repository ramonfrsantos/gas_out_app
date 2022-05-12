import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:gas_out_app/app/constants/gasout_constants.dart';
import 'package:gas_out_app/data/repositories/user/user_repository.dart';
import 'package:simple_animations/simple_animations.dart';

import '../../../data/model/login/login_response_model.dart';
import '../../../data/repositories/login/login_repository.dart';
import '../../../main_dev.dart';
import '../../stores/controller/login/login_controller.dart';
import '../home/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  int _pageState = 1;

  double _loginWidth = 0;
  double _loginHeight = 0;
  double _loginOpacity = 1;
  double _loginXOffset = 0;
  double _loginYOffset = 0;
  double _registerYOffset = 0;
  double _registerHeight = 0;

  double windowWidth = 0;
  double windowHeight = 0;

  bool _keyboardVisible = false;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
  }

  TextEditingController emailLoginController = TextEditingController();
  TextEditingController passwordLoginController = TextEditingController();
  TextEditingController emailSignUpController = TextEditingController();
  TextEditingController passwordSignUpController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  UserRepository userRepository = UserRepository();
  LoginRepository loginRepository = LoginRepository();
  LoginController loginController = LoginController();

  @override
  Widget build(BuildContext context) {
    _keyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;
    windowHeight = MediaQuery.of(context).size.height;
    windowWidth = MediaQuery.of(context).size.width;

    _loginHeight = windowHeight - 190;
    _registerHeight = windowHeight - 190;

    switch (_pageState) {
      case 0:
        _loginWidth = windowWidth;
        _loginOpacity = 1;

        _loginYOffset = windowHeight;
        _loginHeight = _keyboardVisible ? windowHeight : windowHeight - 190;

        _loginXOffset = 0;
        _registerYOffset = windowHeight;
        break;

      case 1:
        _loginWidth = windowWidth;
        _loginOpacity = 1;

        _loginYOffset = _keyboardVisible ? 40 : 190;
        _loginHeight = _keyboardVisible ? windowHeight : windowHeight - 190;

        _loginXOffset = 0;
        _registerYOffset = windowHeight;
        break;

      case 2:
        _loginWidth = windowWidth - 40;
        _loginOpacity = 0.5;

        _loginYOffset = _keyboardVisible ? 40 : 190;
        _loginHeight = _keyboardVisible ? windowHeight : windowHeight - 190;

        _loginXOffset = 20;
        _registerYOffset = _keyboardVisible ? 40 : 190;
        _registerHeight = _keyboardVisible ? windowHeight : windowHeight - 190;
        break;
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          AnimatedContainer(
            width: double.infinity,
            curve: Curves.fastLinearToSlowEaseIn,
            duration: Duration(milliseconds: 1000),
            decoration: BoxDecoration(color: ConstantColors.primaryColor),
            // gradient: LinearGradient(
            //     begin: Alignment.topCenter,
            //     colors: [Color(0xffd23232), Color(0xffe37f7f)])),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 50,
                      ),
                      FadeAnimation(
                        delay: 1,
                        child: Image(
                          image: AssetImage('images/logoPequenaBranco.png'),
                          width: 200,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),

          // Login Screen
          AnimatedContainer(
            padding: _keyboardVisible
                ? EdgeInsets.only(bottom: 40, left: 40, right: 40, top: 55)
                : EdgeInsets.all(40),
            width: _loginWidth,
            height: _loginHeight,
            curve: Curves.fastLinearToSlowEaseIn,
            duration: Duration(milliseconds: 1000),
            transform:
                Matrix4.translationValues(_loginXOffset, _loginYOffset, 1),
            decoration: BoxDecoration(
                color: _loginOpacity == 1
                    ? Colors.white
                    : Color.fromRGBO(255, 255, 255, _loginOpacity),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50))),
            child: Opacity(
              opacity: _loginOpacity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      FadeAnimation(
                        delay: 1.4,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                    color: Color.fromRGBO(32, 132, 232, 0.3),
                                    blurRadius: 20,
                                    offset: Offset(0, 10))
                              ]),
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey.shade200))),
                                child: TextField(
                                  controller: emailLoginController,
                                  decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.email),
                                      hintText: "E-mail",
                                      hintStyle: TextStyle(
                                        color: Colors.grey,
                                      ),
                                      border: InputBorder.none),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey.shade200))),
                                child: TextField(
                                  controller: passwordLoginController,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.vpn_key),
                                      hintText: "Senha",
                                      hintStyle: TextStyle(
                                        color: Colors.grey,
                                      ),
                                      border: InputBorder.none),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      GestureDetector(
                        onTap: () {
                          print('Forget working');
                        },
                        child: Container(
                          height: 30,
                          child: FadeAnimation(
                              delay: 1.5,
                              child: Text(
                                "Esqueci minha senha",
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 16),
                              )),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      FadeAnimation(
                        delay: 1.6,
                        child: FlatButton(
                          onPressed: () async {
                            LoginResponseModel? response =
                                await loginRepository.doLogin(emailLoginController.text, passwordLoginController.text);
                            if(response?.userId != null){
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => MainWidget(title: 'GasOut', username: response?.userName)),
                              );
                            }
                          },
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          child: Container(
                            height: 50,
                            margin: EdgeInsets.symmetric(horizontal: 50),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: ConstantColors.primaryColor),
                            child: Center(
                              child: Text(
                                'Entrar',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Login with social media

                      // SizedBox(
                      //   height: 15,
                      // ),
                      // FadeAnimation(
                      //     delay: 1.7,
                      //     child: Text(
                      //       "Faça login com sua conta",
                      //       style: TextStyle(color: Colors.grey),
                      //     )),
                      // SizedBox(
                      //   height: 12,
                      // ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     Container(
                      //       child: FadeAnimation(
                      //           delay: 1.8,
                      //           child: Container(
                      //             child: MaterialButton(
                      //               onPressed: () {},
                      //               color: Color(0xff3b5998),
                      //               textColor: Colors.white,
                      //               child: Icon(
                      //                 FontAwesomeIcons.facebookF,
                      //                 size: 30,
                      //               ),
                      //               padding: EdgeInsets.all(16),
                      //               shape: CircleBorder(),
                      //             ),
                      //           )),
                      //     ),
                      //     Container(
                      //       child: FadeAnimation(
                      //           delay: 1.8,
                      //           child: Container(
                      //             child: MaterialButton(
                      //               onPressed: () {},
                      //               color: Color(0xffea4335),
                      //               textColor: Colors.white,
                      //               child: Icon(
                      //                 FontAwesomeIcons.google,
                      //                 size: 30,
                      //               ),
                      //               padding: EdgeInsets.all(16),
                      //               shape: CircleBorder(),
                      //             ),
                      //           )),
                      //     ),
                      //     Container(
                      //       child: FadeAnimation(
                      //           delay: 1.8,
                      //           child: Container(
                      //             child: MaterialButton(
                      //               onPressed: () {},
                      //               color: Color(0xff34a853),
                      //               textColor: Colors.white,
                      //               child: Icon(
                      //                 FontAwesomeIcons.mobileAlt,
                      //                 size: 30,
                      //               ),
                      //               padding: EdgeInsets.all(16),
                      //               shape: CircleBorder(),
                      //             ),
                      //           )),
                      //     ),
                      //   ],
                      // ),
                      SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          print("sign  up working");
                          setState(() {
                            _pageState = 2;
                          });
                        },
                        child: Container(
                          child: FadeAnimation(
                            delay: 1.5,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Não possui uma conta? ",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 18),
                                ),
                                Text(
                                  "Cadastre-se",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),

          // Signup Screen
          AnimatedContainer(
            padding: EdgeInsets.all(40),
            height: _registerHeight,
            curve: Curves.fastLinearToSlowEaseIn,
            duration: Duration(milliseconds: 1000),
            transform: Matrix4.translationValues(0, _registerYOffset, 1),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    FadeAnimation(
                      delay: 1.4,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                  color: Color.fromRGBO(32, 132, 232, 0.3),
                                  blurRadius: 20,
                                  offset: Offset(0, 10))
                            ]),
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.grey.shade200))),
                              child: TextField(
                                controller: nameController,
                                decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.person),
                                    hintText: "Nome completo",
                                    hintStyle: TextStyle(
                                      color: Colors.grey,
                                    ),
                                    border: InputBorder.none),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.grey.shade200))),
                              child: TextField(
                                controller: emailSignUpController,
                                decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.email),
                                    hintText: "E-mail",
                                    hintStyle: TextStyle(
                                      color: Colors.grey,
                                    ),
                                    border: InputBorder.none),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.grey.shade200))),
                              child: TextField(
                                controller: passwordSignUpController,
                                obscureText: true,
                                decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.vpn_key),
                                    hintText: "Senha",
                                    hintStyle: TextStyle(
                                      color: Colors.grey,
                                    ),
                                    border: InputBorder.none),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.grey.shade200))),
                              child: TextField(
                                controller: confirmPasswordController,
                                onChanged: (value) {
                                  print(
                                      "senha: ${passwordSignUpController.text} || confirmar senha: $value");
                                  if (passwordSignUpController.text == value) {
                                    loginController.setValue(false);
                                  } else {
                                    loginController.setValue(true);
                                  }
                                },
                                obscureText: true,
                                decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.vpn_key),
                                    hintText: "Confirmar senha",
                                    hintStyle: TextStyle(
                                      color: Colors.grey,
                                    ),
                                    border: InputBorder.none),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    FadeAnimation(
                      delay: 1.6,
                      child: Observer(
                        builder: (context) {
                          return FlatButton(
                            onPressed: loginController.isSignUpButtonDisabled
                                ? null
                                : () async {
                                    setState(() {
                                      _loading = true;
                                    });

                                    int? statusCode =
                                        await userRepository.createUser(
                                            emailSignUpController.text,
                                            nameController.text,
                                            passwordSignUpController.text);

                                    if (statusCode == 200) {
                                      setState(() {
                                        _pageState = 1;
                                        _loading = false;
                                      });
                                    } else {
                                      setState(() {
                                        _loading = false;
                                      });
                                      print(statusCode);
                                    }
                                  },
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            child: Container(
                              height: 50,
                              margin: EdgeInsets.symmetric(horizontal: 50),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: loginController.isSignUpButtonDisabled
                                      ? ConstantColors.secondaryColor
                                      : ConstantColors.primaryColor),
                              child: Center(
                                // child: Text(
                                //   'Cadastrar',
                                //   style: TextStyle(
                                //       color: Colors.white,
                                //       fontWeight: FontWeight.bold,
                                //       fontSize: 20),
                                // ),
                                child: _loading
                                    ? CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                    : Text(
                                        'Cadastrar',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        print("sign  up working");
                        setState(() {
                          _pageState = 1;
                        });
                      },
                      child: Container(
                        child: FadeAnimation(
                          delay: 1.5,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Já possui uma conta? ",
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 18),
                              ),
                              Text(
                                "Entre aqui.",
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class FadeAnimation extends StatelessWidget {
  final double delay;
  final Widget child;
  const FadeAnimation({Key? key, required this.delay, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tween = MultiTween<String>()
      ..add("opacity", Tween(begin: 0.0, end: 1.0), Duration(milliseconds: 500))
      ..add("translateY", Tween(begin: -30.0, end: 1.0),
          Duration(milliseconds: 500), Curves.easeOut);
    return PlayAnimation<MultiTweenValues<String>>(
      delay: Duration(milliseconds: (500 * delay).round()),
      duration: tween.duration,
      tween: tween,
      child: child,
      builder: (context, child, animation) => Opacity(
          opacity: animation.get("opacity"),
          child: Transform.translate(
              offset: Offset(0, animation.get("translateY")), child: child)),
    );
  }
}
