import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:gas_out_app/app/screens/login/login_screen.dart';
import 'package:gas_out_app/app/stores/controller/login/login_controller.dart';
import 'package:kf_drawer/kf_drawer.dart';
import '../../helpers/global.dart';
import '../detail/details_screen.dart';

class HomeScreen extends KFDrawerContent {
  final String? username;

  HomeScreen({required this.username});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                        onPressed: () {
                          Navigator.pop(context);
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
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Olá, ${(widget.username)?.split(' ')[0]}!",
                        style: TextStyle(
                            fontSize: 23, fontWeight: FontWeight.bold)),
                    SizedBox(height: 15),
                    Container(
                      alignment: Alignment.center,
                      child: Image(
                        image: AssetImage('images/logoPequena.png'),
                        width: 220,
                      ),
                    ),
                    SizedBox(height: 50),
                    Text("Sobre o APP:",
                        style: TextStyle(
                            fontSize: 19, fontWeight: FontWeight.bold)),
                    SizedBox(height: 15),
                    Text(
                      "No GasOut apresentamos um relatório completo sobre possíveis vazamentos de gás na sua residência."
                      " Sugerimos seguir as recomendações em caso de alterações ou resultados indesejados.",
                      style: TextStyle(color: Colors.grey),
                    ),
                    SizedBox(height: 30),
                    Text("Escolha um cômodo:",
                        style: TextStyle(
                            fontSize: 19, fontWeight: FontWeight.bold)),
                    SizedBox(height: 15),
                    Container(
                        height: 300,
                        width: double.infinity,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: <Widget>[
                            _listItem(
                              'images/quarto.jpg',
                              'Quarto',
                              10,
                              14.7,
                            ),
                            new SizedBox(width: 15),
                            _listItem(
                                'images/cozinha.jpg', 'Cozinha', 51.3, 62.5),
                            new SizedBox(width: 15),
                            _listItem(
                              'images/sala.jpg',
                              'Sala de estar',
                              8,
                              6,
                            ),
                            new SizedBox(width: 15),
                            _listItem(
                              'images/banheiro.jpg',
                              'Banheiro',
                              0,
                              2,
                            ),
                          ],
                        )),
                    SizedBox(height: 30),
                    Padding(
                        padding: EdgeInsets.only(top: 5, left: 20, right: 20),
                        child: Divider(
                          color: Colors.black54,
                        )),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 10),
                      child: Row(
                        children: <Widget>[
                          Text(
                            "Acionar monitoramento",
                            style: new TextStyle(color: Colors.black87),
                          ),
                          Spacer(),
                          Observer(builder: (_) {
                            return Switch(
                              value: monitoringController.activeMonitoring,
                              onChanged: monitoringController.setValue,
                              activeColor: Colors.lightGreen,
                            );
                          })
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
    );
  }

  Widget _listItem(
      String imgpath, String stringPath, double averageValue, double maxValue) {
    return Stack(children: [
      InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => DetailsScreen(
                    imgPath: imgpath,
                    averageValue: averageValue,
                    maxValue: maxValue,
                    totalHours: monitoringController.monitoringTotalHours,
                  )));
        },
        child: Stack(alignment: Alignment.center, children: [
          Container(
            width: 325,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              image: DecorationImage(
                  image: AssetImage(imgpath), fit: BoxFit.cover, opacity: 0.96),
            ),
          ),
          Container(
            alignment: Alignment.center,
            width: 200,
            child: Text(stringPath,
                style: TextStyle(
                    fontSize: 36,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(1.0),
                        offset: Offset(0.0, 0.0),
                        blurRadius: 30.0,
                      ),
                    ])),
          ),
        ]),
      )
    ]);
  }
}
