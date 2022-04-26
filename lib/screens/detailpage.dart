import 'dart:async';

import 'package:flutter/material.dart';

class DetailPage extends StatefulWidget {
  final imgPath;
  double averageValue;
  double maxValue;
  int totalHours;
  bool sprinklersOn = false;

  DetailPage({Key? key, this.imgPath,  required this.averageValue, required this.maxValue, required this.totalHours}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool isMonitoring = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          new Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(widget.imgPath), fit: BoxFit.cover)),
          ),
          new Padding(
            padding: EdgeInsets.only(top: 25),
            child: new Row(
              children: <Widget>[
                new IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                SizedBox(width: 15)
              ],
            ),
          ),
          new Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 340,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                color: Color.fromRGBO(250, 193, 157, 0.68),
              ),
              child: new Column(
                children: <Widget>[
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      listItemStats('images/notification.png',"Notificações",
                          widget.averageValue > 0 ? true : false
                      ),
                      listItemStats('images/creative.png',"Alarme",
                          widget.averageValue > 0 ? true : false
                      ),
                      listItemStats('images/sprinkler.png',"Sprinklers",
                          widget.averageValue >= 50 ? true : false
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10, left: 20, right: 20),
                    child: Divider(color: Colors.white,)
                  ),
                  SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Row(
                      children: <Widget>[
                        Text("Valor Máximo Atingido", style: new TextStyle(color: Colors.white),),
                        Spacer(),
                        Text(widget.maxValue.toString() + "%", style: new TextStyle(color: Colors.white),),
                      ],
                    ),
                  ),
                  SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Row(
                      children: <Widget>[
                        Text("Total de Horas Monitoradas", style: new TextStyle(color: Colors.white),),
                        Spacer(),
                        Text(widget.totalHours.toString(), style: new TextStyle(color: Colors.white),),
                      ],
                    ),
                  ),
                  SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Row(
                      children: <Widget>[
                        Text("Valor Médio Diário", style: new TextStyle(color: Colors.white),),
                        Spacer(),
                        Text(widget.averageValue.toString() + "%", style: new TextStyle(color: Colors.white),),
                      ],
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 5, left: 20, right: 20),
                      child: Divider(color: Colors.white,)
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 10),
                    child: Row(
                      children: <Widget>[
                        Text("Acionar monitoramento", style: new TextStyle(color: Colors.white),),
                        Spacer(),
                        Switch(
                          value: isMonitoring,
                          onChanged: (newVal){
                            setState(() {
                              isMonitoring = newVal;
                              if(newVal == false){
                                widget.totalHours = 0;
                              }

                              if(newVal == true){
                                startTimer();
                              }

                              // print(newVal);
                            });
                          },
                          activeColor: Colors.lightGreen,
                        )
                      ],
                    ),
                  ),
                ],
              )
            ),
          )
        ],
      ),
    );
  }

  Widget listItemStats(String imgpath, String name, bool value){
    return Container(
      width: 110,
      height: 150,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: value == true ? Colors.white : Color.fromRGBO(
              210, 153, 117, 0.75)
      ),
      child: Column(
        children: <Widget>[
          SizedBox(height: 20),
          Image(image: AssetImage(imgpath),width: 45,height: 45, color: value == true ? Colors.black : Colors.white),
          SizedBox(height: 15),
          Text(name, style: TextStyle(fontSize: 13, color: value == true ? Colors.black : Colors.white)),
          SizedBox(height: 5),
          Switch(
            value: value,
            onChanged: (newVal){
              // if(name.compareTo("Sprinklers") == 0 && newVal == true) {
              //   setState(() {
              //       showAlertDialog(context);
              //       newVal = widget.sprinklersOn;
              //       value = newVal;
              //       print(value);
              //   });
              // } else{
                value = newVal;
                // print(newVal);
              // }
            },
            activeColor: Colors.lightGreen,
          )
        ],
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    Widget cancelaButton = TextButton(
      child: Text("Cancelar"),
      onPressed:  () {
        widget.sprinklersOn = false;
        Navigator.of(context).pop();
      },
    );
    Widget continuaButton = TextButton(
      child: Text("Continar"),
      onPressed:  () {
        widget.sprinklersOn = true;
        Navigator.of(context).pop();
      },
    );
    //configura o AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("AlertDialog"),
      content: Text("Deseja realmente acionar os sprinklers?"),
      actions: [
        cancelaButton,
        continuaButton,
      ],
    );
    //exibe o diálogo
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  late Timer _timer;
  int _start = 0;

  void startTimer() {
    const oneHour = const Duration(seconds: 3600);
    _timer = new Timer.periodic(
      oneHour,
          (Timer timer) {
          setState(() {
            _start++;
            widget.totalHours = _start;
            print(widget.totalHours);
          });
      },
    );
  }
}
