import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'TextStyle.dart';
import 'SmallTextStyle.dart';
import 'package:weather_app/util/utils.dart' as util;

class Klimatic extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new KlimateState();
  }
}

class KlimateState extends State<Klimatic> {

  void showData() async {
    Map data = await getWeather(util.appID, util.defaultCity);
    print(data.toString());
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Weather App"),
        actions: <Widget>[
          new IconButton(
              icon: new Icon(Icons.menu), onPressed: showData)
        ],
      ),
      body: new Stack(
        children: <Widget>[
          new Center(
            child: new Image.asset(
              "images/umbrella.png",
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
            ),
          ),
          new Container(
              alignment: Alignment.topRight,
              padding: new EdgeInsets.all(16),
              margin: new EdgeInsets.only(right: 8),
              child: new PlaceText("Location Name")
          ),
          new Container(
            alignment: Alignment.center,
            child: new Image.asset("images/light_rain.png"),
          ),
          new Container(
            margin: const EdgeInsets.fromLTRB(30, 340, 0, 0),
            child: updateWidget("Dhaka"),
          )
        ],
      ),
    );
  }

/*static TextStyle cityStyle(){

    return new TextStyle(fontSize: 26,
        color: Colors.white,
        fontStyle: FontStyle.italic);
  }*/
}

Future<Map> getWeather(String appId, String City) async {
  String apiUrl = 'http://api.openweathermap.org/data/2.5/weather?q=$City&APPID=''${util
      .appID}&units=imperial';
  http.Response response = await http.get(apiUrl);

  return jsonDecode(response.body);
}

Widget updateWidget(String city) {
  return new FutureBuilder(
    future: getWeather(util.appID,  city),
      builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
      if(snapshot.hasData){
       Map responceData=snapshot.data;
       return new Container(
         child: new Column(
           children: <Widget>[
             new ListTile(
               title: new PlaceText(responceData['main']['temp'].toString(),),
             )
           ],
         ),
       );
      }


      });
}
