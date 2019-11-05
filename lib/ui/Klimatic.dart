import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/util/utils.dart' as util;

import 'TextStyle.dart';

class Klimatic extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new KlimateState();
  }
}

var temperature;
String convertedCelcious = "";
Map responceData;
class KlimateState extends State<Klimatic> {
  String _cityName;
  var _time = responceData['timezone'];

  /*var time = new DateTime.now();
  var timeFormatting = DateTime.parse("");*/


  Future goToTakeDirectionScreen(BuildContext context) async {
    Map results = await Navigator.of(context)
        .push(new MaterialPageRoute<Map>(builder: (BuildContext context) {
      return new TakeLocation();
    }));
    if (results != null && results.containsKey('location')) {
      // print(results['location'].toString());
      _cityName = results['location'];
    }
  }

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
              icon: new Icon(Icons.menu),
              onPressed: () {
                goToTakeDirectionScreen(context);
              })
        ],
      ),
      body: new Stack(
        children: <Widget>[
          new Container(
            decoration: new BoxDecoration(color: Colors.lightBlue),
          ),
          /*new Center(
            child: */ /*new Image.asset(
              "images/umbrella.png",
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
            ),*/ /*
          ),*/

          new Column(
            children: <Widget>[
              new Container(
                  alignment: Alignment.topCenter,
                  padding: new EdgeInsets.all(16),
                  margin: new EdgeInsets.fromLTRB(0, 150, 0, 0),
                  child: new PlaceText(
                      '${_cityName == null ? util.defaultCity : _cityName}')),
              new Container(
                /*alignment: Alignment.center,
            child: new Image.asset("images/light_rain.png"),*/
                child: new Text("Updated: 11.25 AM", style:
                new TextStyle(
                    fontSize: 20,
                    color: Colors.white
                ),),

              ),
            ],
          ),

          updateWidget(_cityName)
        ],
      ),
    );
  }
}

Future<Map> getWeather(String appId, String City) async {
  String apiUrl =
      'http://api.openweathermap.org/data/2.5/weather?q=$City&APPID='
      '${util.appID}&units=metric';
  http.Response response = await http.get(apiUrl);

  return jsonDecode(response.body);
}

class TakeLocation extends StatelessWidget {
  var _getLocationController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Change City"),
      ),
      body: new Stack(
        children: <Widget>[
          new Center(
            child: new Image.asset(
              "images/white_snow.png",
              height: double.infinity,
              width: double.infinity,
              fit: BoxFit.fill,
            ),
          ),
          new ListView(
            children: <Widget>[
              new ListTile(
                title: new TextField(
                  decoration: new InputDecoration(hintText: "Enter City"),
                  keyboardType: TextInputType.text,
                  controller: _getLocationController,
                ),
              ),
              new ListTile(
                  title: new FlatButton(
                      color: Colors.lightBlue.shade400,
                      textColor: Colors.white,
                      onPressed: () {
                        Navigator.pop(
                            context, {'location': _getLocationController.text});
                      },
                      child: new Text("Get Weather")))
            ],
          )
        ],
      ),
    );
  }
}

Widget updateWidget(String city) {
  return new FutureBuilder(
      future: getWeather(util.appID, city == null ? util.defaultCity : city),
      // ignore: missing_return
      builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
        // ignore: missing_return
        if (snapshot.hasData) {
          responceData = snapshot.data;
          temperature = responceData['main']['temp'].toString();
          return new Container(
            margin: const EdgeInsets.fromLTRB(30, 250, 0, 0),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              // ignore: missing_return
              children: <Widget>[
                new ListTile(
                  title: new Text(
                    // ignore: missing_return
                    "$temperature C",
                    style: new TextStyle(
                        fontSize: 39.0,
                        color: Colors.orange,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.bold),
                  ),
                  subtitle: new ListTile(
                    title: new Text(
                      "Humidity: ${responceData['main']['humidity']
                          .toString()} \n"
                          "Minimum: ${responceData['main']['temp_min']
                          .toString()} C \n"
                          "Maximum: ${responceData['main']['temp_max']
                          .toString()} C \n"
                          "Description: ${responceData['weather'][0]['description']}\n",
                      style: new TextStyle(fontSize: 22.0, color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          );
        } else {
          return new CircularProgressIndicator();
        }
      });
}
