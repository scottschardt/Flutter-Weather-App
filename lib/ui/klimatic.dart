import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import '../util/utils.dart' as util;

class Klimatic extends StatefulWidget {
  @override
  _KlimaticState createState() => _KlimaticState();
}


class _KlimaticState extends State<Klimatic> {

  String _cityEntered;

  Future _goToNextScreen(BuildContext context) async {
    Map results = await Navigator.of(context).push(
      new MaterialPageRoute(builder:
      (BuildContext context) {
        return new ChangeCity();
      })
    );
    if (results != null && results.containsKey('info')) {
      _cityEntered = results['info'];
    }
  }

  void showStuff() async {
    Map data = await getWeather(util.apiId, util.defaultCity);
    print(data.toString());
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Klimatic"),
          backgroundColor: Colors.white,
          actions: <Widget>[
            new IconButton(
                icon: new Icon(Icons.menu, color: Colors.red),
                onPressed: () {_goToNextScreen(context);})
          ],
        ),
        body: new Stack(
            children: <Widget>[
              new Center(
                child: new Image.asset(
                  'images/umbrella.jpg',
                  height: 1200.0,
                  fit: BoxFit.fill,
                ),
              ),
              new Container(
                alignment: Alignment.topRight,
                margin: const EdgeInsets.fromLTRB(0.0, 10.9, 10.9, 0.0),
                child: new Text("${_cityEntered == null ? util.defaultCity : _cityEntered}",
                  style: citystyle(),),
              ),
              new Container(
                alignment: Alignment.center,
                child: new Image.asset(
                  'images/lightrain_2.png',
                  width: 150.0,
                  height: 150.0,
                ),
              ),
              new Container(
                margin: const EdgeInsets.fromLTRB(0.0, 390.0, 150.0, 0.0),
                alignment: Alignment.center,
                child: updateTempWidget(_cityEntered),
              )
            ]

        )

    );
  }

  Future<Map> getWeather(String apiId, String city) async {
    String apiUrl = 'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=${util
        .apiId}&units=imperial';
    http.Response response = await http.get(apiUrl);
    return json.decode(response.body);
  }

  Widget updateTempWidget(String city) {
    return FutureBuilder(
        future: getWeather(util.apiId, city == null ? util.defaultCity : city),
        builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
          if (snapshot.hasData) {
            Map content = snapshot.data;
            return new Container(
              child: new Column(
                children: <Widget>[
                  new ListTile(
                    title: new Text("${content['main']['temp'].toString()} F",
                      style: new TextStyle(
                          color: Colors.white,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w300,
                          fontSize: 40.0
                      ),),
                    subtitle: ListTile(
                      title: new Text("Temp Min: ${content['main']['temp_min']} F" +
                        " \n" + "Temp Max: ${content['main']['temp_max']} F" + " \n" +
                        "Humidity: ${content['main']['humidity']}% ",
                      style: new TextStyle(
                        color: Colors.white,
                        fontSize: 17.0
                      ),),
                    )
                  )
                ],
              ),
            );
          } else {
            return new Container();
          }
        }
    );
  }
}

TextStyle weatherStyle(){
  return new TextStyle(
    color: Colors.white,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
    fontSize: 49.9
  );}

TextStyle citystyle(){
return new TextStyle(
  color: Colors.white,
  fontSize: 19.9,
  fontStyle: FontStyle.italic
);}

class ChangeCity extends StatelessWidget {
  var _cityFieldController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('Change City'),
          backgroundColor: Colors.red,
        centerTitle: true,
      ),
      body: new Stack(
        children: <Widget>[
          new ListView(
            children: <Widget>[
              new Image.asset('images/sunrise.jpg',
              width: 490.0,
              height: 1200.0,
              fit: BoxFit.fill,),
            ],
          ),
          new ListView(
            children: <Widget>[
              new ListTile(
                title: new TextField(
                  decoration: new InputDecoration(
                    hintText: "Enter City",),
                  controller: _cityFieldController,
                  keyboardType: TextInputType.text,

                ),
              ),
              new ListTile(
                title: new FlatButton(
                    onPressed: () {
                      Navigator.pop(context, {
                        'info': _cityFieldController.text
                      });
                    },
                color: Colors.white70,
                textColor: Colors.redAccent,
                child: new Text("Get Weather")),
              )
            ],
          )
        ],
      ),
    );
  }
}




