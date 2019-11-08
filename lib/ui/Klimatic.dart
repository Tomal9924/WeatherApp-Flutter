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

String convertedCelcious = "";
Map responceData;
var timeResponceddata;
var temperature;
var now = new DateTime.now();
var _weatherDescriptions = responceData['weather'][0]['description'];
var _images;

class KlimateState extends State<Klimatic> {
  String _cityName;

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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return new Scaffold(
      backgroundColor: Colors.green.shade400,
      body: new Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.topRight,
          ),
          new Container(
            margin: new EdgeInsets.fromLTRB(20, 48, 0, 0),
            padding: new EdgeInsets.all(5),
            decoration: new BoxDecoration(color: Colors.green.shade400),
            child: new Row(
              children: <Widget>[
                new Container(
                  child: new Text(
                    "Quick Weather",
                    style: new TextStyle(fontSize: 24.0, color: Colors.white),
                  ),
                ),
                new Container(
                  margin: new EdgeInsets.fromLTRB(120, 0, 0, 0),
                  child: new IconButton(
                      alignment: Alignment.centerRight,
                      icon: new Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        goToTakeDirectionScreen(context);
                      }),
                ),
              ],
            ),
          ),
          new Column(
            children: <Widget>[
              new Container(
                alignment: Alignment.topCenter,
                padding: new EdgeInsets.fromLTRB(20, 10, 0, 0),
                margin: new EdgeInsets.fromLTRB(0, 100, 0, 0),
                child: new Container(
                    child: new Row(
                      children: <Widget>[
                        new Container(
                          padding: new EdgeInsets.fromLTRB(10, 0, 30, 16),
                          child: new Image.asset(
                            "$_images",
                            height: 40.0,
                            width: 40.0,
                          ),
                        ),
                        new Container(
                          child: new Text(
                            "$temperature",
                            style: new TextStyle(
                                fontSize: 75.0,
                                color: Colors.white,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Roboto'),
                          ),
                        ),
                        new Container(
                          margin: new EdgeInsets.fromLTRB(6, 0, 0, 19),
                          alignment: Alignment.topRight,
                          child: new Text(
                            "°C",
                            style: new TextStyle(
                                fontSize: 22.0,
                                color: Colors.white,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Roboto'),
                          ),
                        )
                      ],
                    )),
              ),
              new Container(
                  padding: new EdgeInsets.fromLTRB(0, 0, 30, 0),
                  child: new PlaceText(
                      '${_cityName == null ? util.defaultCity : _cityName}')
                /*new Text(
                  "Updated: ${new DateFormat.jm().format(now)}",
                  style: new TextStyle(fontSize: 20, color: Colors.white),
                ),*/
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
  var data = jsonDecode(response.body);
  return data;
}

class TakeLocation extends StatelessWidget {
  var _getLocationController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Change City"),
        backgroundColor: Colors.green.shade400,
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
          temperature = responceData['main']['temp'];
          print(temperature);
          _weatherDescriptions = responceData['weather'][0]['description'];

          switch (_weatherDescriptions) {
            case "haze":
              _images = 'images/haze.png';
              break;
            case "broken clouds":
              _images = 'images/cloudy.png';
              break;
            case "clear sky":
              _images = 'images/beach.png';
              break;
            case "scattered clouds":
              _images = 'images/storm.png';
              break;
            case "few clouds":
              _images = 'images/cloudy.png';
              break;
            case "moderate rain":
              _images = 'images/rain.png';
              break;
            default:
              _images = 'images/beach.png';
          }
          return new Container(
              margin: const EdgeInsets.fromLTRB(30, 250, 0, 0),
              child: new Container(
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new Center(
                        child: new Column(
                          children: <Widget>[
                            /*new Container(
                          margin: new EdgeInsets.only(top: 16),
                          child: new Text(
                            "$temperature °C",
                            style: new TextStyle(
                                fontSize: 64.0,
                                color: Colors.white,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Roboto'),
                          ),
                        ),*/
                            new Container(
                              alignment: Alignment.center,
                              child: new Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  new Container(
                                    child: new Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .center,
                                      children: <Widget>[
                                        new Icon(Icons.arrow_downward,
                                            color: Colors.redAccent, size: 24),
                                        new Text(
                                          "${responceData['main']['temp_min']
                                              .toString()} °C",
                                          style: new TextStyle(
                                              fontSize: 24.0,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                  new Container(
                                    child: new Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .center,
                                      children: <Widget>[
                                        new Icon(
                                          Icons.arrow_upward,
                                          color: Colors.yellowAccent,
                                          size: 24,
                                        ),
                                        new Text(
                                          "${responceData['main']['temp_max']
                                              .toString()} °C",
                                          style: new TextStyle(
                                              fontSize: 24.0,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            new Container(
                              child: new Text(
                                "$_weatherDescriptions",
                                style: new TextStyle(
                                    fontSize: 34.0, color: Colors.white70),
                              ),
                            )
                          ],
                        )),
                  ],
                ),
              ));
        } else {
          return new Center(
            child: new CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          );
        }
      });
}
