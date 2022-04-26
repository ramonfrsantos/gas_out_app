import 'package:flutter/material.dart';
import 'package:kf_drawer/kf_drawer.dart';
import 'detailpage.dart';

class Home extends KFDrawerContent {
  Home({
    Key? key,
  });

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              Row(
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
                  SizedBox(width: 15)
                ],
              ),
              Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text("Bem vindo!", style: TextStyle(fontSize: 17)),
                      ],
                    ),
                    SizedBox(height: 30),
                    Text("Relatório de monitoramento",
                        style: TextStyle(
                            fontSize: 19, fontWeight: FontWeight.bold)),
                    SizedBox(height: 15),
                    Text(
                      "Aqui está um relatório completo sobre possíveis vazamentos de gás na sua residência."
                      " Sugerimos seguir as recomendações em caso de alterações ou resultados indesejados.",
                      style: TextStyle(color: Colors.grey),
                    ),
                    SizedBox(height: 30),
                    Text("Cômodos",
                        style: TextStyle(
                            fontSize: 19, fontWeight: FontWeight.bold)),
                    SizedBox(height: 15),
                    Container(
                        height: 300,
                        width: double.infinity,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: <Widget>[
                            listItem('images/quarto.jpg', 'Quarto'),
                            new SizedBox(width: 15),
                            listItem('images/cozinha.jpg', 'Cozinha'),
                            new SizedBox(width: 15),
                            listItem('images/sala.jpg', 'Sala de estar'),
                            new SizedBox(width: 15),
                            listItem('images/banheiro.jpg', 'Banheiro'),
                          ],
                        )),
                    SizedBox(height: 15),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget listItem(String imgpath, String stringPath) {
        return Stack(children: [
          InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => DetailPage(
                        imgPath: imgpath,
                      )));
            },
            child: Stack(alignment: Alignment.center, children: [
              Container(
                width: 325,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  image: DecorationImage(
                      image: AssetImage(imgpath),
                      fit: BoxFit.cover,
                      opacity: 0.85),
                ),
              ),
              Text(stringPath,
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
            ]),
          )
        ]);
  }

  Widget listItemStats(String imgpath, String name, bool value) {
    return Container(
      width: 110,
      height: 150,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: value == true
              ? Colors.white
              : Color.fromRGBO(255, 230, 215, 0.6)),
      child: Column(
        children: <Widget>[
          SizedBox(height: 20),
          Image(
              image: AssetImage(imgpath),
              width: 45,
              height: 45,
              color: value == true ? Colors.black : Colors.white),
          SizedBox(height: 15),
          Text(name,
              style: TextStyle(
                  fontSize: 13,
                  color: value == true ? Colors.black : Colors.white)),
          SizedBox(height: 5),
          Switch(
            value: value,
            onChanged: (newVal) {
              setState(() {
                value = newVal;
                print(newVal);
              });
            },
            activeColor: Colors.orange,
          )
        ],
      ),
    );
  }
}
