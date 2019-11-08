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
var _windSpeed;
var temperature;
var now = new DateTime.now();
//var _weatherDescriptions = responceData['weather'][0]['main'];
var _weatherDescriptions;

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
                      icon: new Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        goToTakeDirectionScreen(context);
                      }),
                )
              ],
            ),
          ),
          new Column(
            children: <Widget>[
              /*new Container(
                child: new Text(
                  "${new DateFormat.jm().format(now)}",
                  style: new TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),*/
              new Container(
                  margin: new EdgeInsets.fromLTRB(0, 100, 0, 0),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new IconButton(
                          icon: new Icon(
                            Icons.location_on,
                            color: Colors.white,
                          ),
                          onPressed: () {}),
                      new PlaceText(
                          '${_cityName == null ? util.defaultCity : _cityName}')
                    ],
                  )),
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
          temperature = responceData['main']['temp'].toString();
          _weatherDescriptions = responceData['weather'][0]['main'];
          _windSpeed = responceData['wind']['speed'];
          print(_windSpeed);
          var _images;
          switch (_weatherDescriptions) {
            case "haze":
              _images = 'images/haze.png';
              break;
            case "Snow":
              _images = 'images/snow.png';
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
              _images = 'images/few_clouds.png';
              break;
            case "moderate rain":
              _images = 'images/rain.png';
              break;
            case "mist":
              _images = 'images/mist.png';
              break;
            case "smoke":
              _images = 'images/smoky.png';
              break;
            default:
              _images = 'images/beach.png';
          }
          return new Container(
              margin: const EdgeInsets.fromLTRB(30, 150, 0, 0),
              child: new Container(
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new Center(
                        child: new Column(
                          children: <Widget>[
                            new Image.asset(
                              "$_images",
                              height: 100.0,
                              width: 100.0,
                            ),
                            //----------------------------------------Todo:main temp--------------------------------------
                            new Container(
                                margin: new EdgeInsets.only(top: 16),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    new Text(
                                      "$temperature",
                                      style: new TextStyle(
                                          fontSize: 64.0,
                                          color: Colors.white,
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Roboto'),
                                    ),
                                    new Container(
                                      margin: new EdgeInsets.fromLTRB(
                                          8, 0, 0, 20),
                                      child: new Text(
                                        "°C",
                                        style: new TextStyle(
                                            fontSize: 22.0,
                                            color: Colors.white,
                                            fontFamily: 'Roboto'),
                                      ),
                                    )
                                  ],
                                )),
                            //---------------------------------TODO: Humidity,Min,Max,WindSpeed-----------------------------------
                            new Container(
                              child: new Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  new Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: <Widget>[
                                      new Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          children: <Widget>[
                                            new Text(
                                              "Min: ",
                                              style: new TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18),
                                            ),
                                            new Text(
                                              "${responceData['main']['temp_min']
                                                  .toString()}",
                                              style: new TextStyle(
                                                  fontSize: 18.0,
                                                  color: Colors.white),
                                            ),
                                            new Text(
                                              "°",
                                              style: new TextStyle(
                                                  fontSize: 22.0,
                                                  color: Colors.white),
                                            ),
                                          ]),
                                      new Row(
                                        children: <Widget>[
                                          new Text(
                                            "Humaidity: ",
                                            style: new TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18),
                                          ),
                                          new Text(
                                            "${responceData['main']['humidity']
                                                .toString()}",
                                            style: new TextStyle(
                                                fontSize: 18.0,
                                                color: Colors.white),
                                          ),
                                          new Text(
                                            "°",
                                            style: new TextStyle(
                                                fontSize: 22.0,
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),

                                  // TODO: 2nd Column--------------------

                                  new Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                children: <Widget>[
                                  new Container(
                                    margin:
                                    const EdgeInsets.fromLTRB(20, 0, 0, 0),
                                    child: new Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        children: <Widget>[
                                          new Text(
                                            "Max: ",
                                            style: new TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18),
                                          ),
                                          new Text(
                                            "${responceData['main']['temp_max']
                                                .toString()}",
                                            style: new TextStyle(
                                                fontSize: 18.0,
                                                color: Colors.white),
                                          ),
                                          new Text(
                                            "°",
                                            style: new TextStyle(
                                                fontSize: 22.0,
                                                color: Colors.white),
                                          ),
                                        ]),
                                  ),
                                  new Container(
                                    margin:
                                    const EdgeInsets.fromLTRB(20, 0, 0, 0),
                                    child: new Row(
                                      children: <Widget>[
                                        new Text(
                                          "Wind: ",
                                          style: new TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                        new Text(
                                          "${_windSpeed.toString()}",
                                          style: new TextStyle(
                                              fontSize: 18.0,
                                              color: Colors.white),
                                        ),
                                        new Text(
                                          "°",
                                          style: new TextStyle(
                                              fontSize: 22.0,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                                  )
                                ],
                              ),
                            ),
                            //----------------------------Todo: Description-------------------
                            new Container(
                              child: new Text(
                                "$_weatherDescriptions",
                                style: new TextStyle(
                                    fontSize: 34.0, color: Colors.white70),
                              ),
                            ),

                            new Container(
                              child: new Row(
                                children: <Widget>[
                                  new Column(
                                    children: <Widget>[
                                      new Text("Today",
                                          style: new TextStyle(
                                              color: Colors.white, fontSize: 20)
                                      ),
                                      new Text("5°",
                                          style: new TextStyle(
                                              color: Colors.white, fontSize: 20)
                                      )
                                    ],
                                  ),
                                  new Stack(
                                    alignment: Alignment.center,
                                    children: <Widget>[
                                      new Column(
                                        children: <Widget>[
                                          new Text("Tomorrow",
                                              style: new TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20)
                                          )
                                        ],
                                      ),
                                    ],

                                  ),

                                  new Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: <Widget>[
                                      new Text("After",
                                          style: new TextStyle(
                                              color: Colors.white, fontSize: 20)
                                      )
                                    ],
                                  )

                                ],
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
