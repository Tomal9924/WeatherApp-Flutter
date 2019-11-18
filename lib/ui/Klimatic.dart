import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:weather_app/ui/row.dart';
import 'package:weather_app/util/utils.dart' as util;

import 'TextStyle.dart';

class Klimatic extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new KlimateState();
  }
}


List<RowForecast> _currentArrayList;
//2019-11-15 12:00:00
DateTime now = DateTime.now();
final today = DateTime(now.year, now.month, now.day);
final tomorrow = DateTime(now.year, now.month, now.day + 1);
String formattedDateToday = DateFormat('yyyy-MM-dd').format(today);
String formattedDateTomorrow = DateFormat('yyyy-MM-dd').format(tomorrow);
List<RowForecast> todayArraylist = new List();
List<RowForecast> tomorrowArrayList = new List();
String convertedCelcious = "";
Map responceData;
var _windSpeed;
var temperature;
var _index = responceData.length;
var arraylist = responceData['list'];
var _weatherDescriptions;
bool buttonState = true;
String _unitText = "metric";

_updateList() {
  _currentArrayList = tomorrowArrayList;
}

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

    ScreenUtil.instance = ScreenUtil(
      width: 1125,
      height: 2436,
      allowFontScaling: true,
    )
      ..init(context);

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

//Todo:-------------------Api Call--------------------------------
Future<Map> getWeather(String appId, String City, String unit) async {
  String apiUrl =
      'http://api.openweathermap.org/data/2.5/forecast?q=$City&APPID='
      '${util.appID}&units=$_unitText';
  http.Response response = await http.get(apiUrl);
  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    return data;
  } else {
    new Center(
        child: new Text(
          "Data Not Found",
          style: new TextStyle(color: Colors.white, fontSize: 35.0),
        ));
  }
}

class TakeLocation extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new InfoScreen();
  }
}

class InfoScreen extends State<TakeLocation> {
  var _getLocationController = new TextEditingController();
  int radiovalue = null;

  void handleRadioValueChanged(int value) {
    setState(() {
      radiovalue = value;
      switch (radiovalue) {
        case 0:
          print(value);
          break;
        case 1:
          print(value);
          break;
        case 2:
          _unitText = "metric";
          break;
        case 3:
          _unitText = "imperial";
          break;
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
                  title: Container(
                    child: new TextField(
                      style: new TextStyle(fontSize: 24, height: 2),
                      decoration: new InputDecoration(hintText: "Enter City"),
                      keyboardType: TextInputType.text,
                      controller: _getLocationController,
                    ),
                  )),
              new ListTile(
                  title: new FlatButton(
                      color: Colors.lightBlue.shade400,
                      textColor: Colors.white,
                      onPressed: () {
                        Navigator.pop(
                            context, {'location': _getLocationController.text});
                      },
                      child: new Text("Get Weather"))),
              new ListTile(
                title: new Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                    "Theme",
                    style: new TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Dark",
                      style: TextStyle(color: Colors.black87),
                    ),
                    new Radio<int>(
                        activeColor: Colors.brown,
                        value: 0,
                        groupValue: radiovalue,
                        onChanged: handleRadioValueChanged),
                  ],
                ),
                subtitle: Divider(
                  color: Colors.grey,
                  height: 1,
                ),
              ),
              ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Light",
                      style: TextStyle(color: Colors.black87),
                    ),
                    new Radio<int>(
                        activeColor: Colors.brown,
                        value: 1,
                        groupValue: radiovalue,
                        onChanged: handleRadioValueChanged),
                  ],
                ),
              ),
              new ListTile(
                title: new Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                    "Units",
                    style: new TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Celcious",
                      style: TextStyle(color: Colors.black87),
                    ),
                    new Radio<int>(
                        activeColor: Colors.brown,
                        value: 2,
                        groupValue: radiovalue,
                        onChanged: handleRadioValueChanged),
                  ],
                ),
                subtitle: Divider(
                  color: Colors.grey,
                  height: 1,
                ),
              ),
              ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Farenheight",
                      style: TextStyle(color: Colors.black87),
                    ),
                    new Radio<int>(
                        activeColor: Colors.brown,
                        value: 3,
                        groupValue: radiovalue,
                        onChanged: handleRadioValueChanged),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

Widget updateWidget(String city) {
  //Todo:-------------------------JSON Calling---------------------------------
  return new FutureBuilder(
      future: getWeather(
          util.appID, city == null ? util.defaultCity : city, util.units),
      builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {

        if (snapshot.hasData) {
          responceData = snapshot.data;
          arraylist = responceData['list'];
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
            case "Clouds":
              _images = 'images/cloudy.png';
              break;
            default:
              _images = 'images/beach.png';
          }

          for (var time in arraylist) {
            RowForecast row = new RowForecast(
                time['main']['temp'], _images, time['dt_txt']);
            if (time['dt_txt'].toString().contains(formattedDateToday)) {
              todayArraylist.add(row);
            }
            else
            if (time['dt_txt'].toString().contains(formattedDateTomorrow)) {
              tomorrowArrayList.add(row);
            }
          }
          _currentArrayList = todayArraylist;

          //Todo: Getting All the json Data from responceData-------------------.
          temperature = responceData['list'][0]['main']['temp'].toString();
          _weatherDescriptions = responceData['list'][0]['weather'][0]['main'];
          _windSpeed = responceData['list'][0]['wind']['speed'];

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
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceAround,
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
                                                  color: Colors.white30,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18),
                                            ),
                                            new Text(
                                              "${responceData['list'][0]['main']['temp_min']
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
                                                color: Colors.white30,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18),
                                          ),
                                          new Text(
                                            "${responceData['list'][0]['main']['humidity']}",
                                            style: new TextStyle(
                                                fontSize: 18.0,
                                                color: Colors.white),
                                          ),
                                          new Text(
                                            "%",
                                            style: new TextStyle(
                                                fontSize: 14.0,
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),

                                  // TODO: 2nd Column--------------------
                                  new Divider(
                                    color: Colors.black,
                                  ),
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
                                                color: Colors.white30,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18),
                                          ),
                                          new Text(
                                            "${responceData['list'][0]['main']['temp_max']}",
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
                                    const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                    child: new Row(
                                      children: <Widget>[
                                        new Text(
                                          "Wind: ",
                                          style: new TextStyle(
                                              color: Colors.white30,
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
                                          "m/s",
                                          style: new TextStyle(
                                              fontSize: 14.0,
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

                            //Todo:----------------------Today Tomorrow After ---------------------
                            new Column(
                              children: <Widget>[
                                new Container(
                                  margin: const EdgeInsets.only(top: 24),
                                  child: new Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: <Widget>[
                                      new InkWell(
                                        child: new Text(
                                          "Today",
                                          style: new TextStyle(
                                              color: Colors.white),
                                        ),
                                        onTap: () {
                                          print("Today");
                                          _currentArrayList = todayArraylist;
                                        },
                                      ),
                                      new InkWell(
                                        child: new Text(
                                          "Tomorrow",
                                          style: new TextStyle(
                                              color: Colors.white),
                                        ),
                                        onTap: _updateList
                                        /*() {

                                      print("Tomorrow");
                                      for(int i=0; i< currentArraylist.length; i++) {
                                        currentArraylist.removeAt(i);
                                      }
                                      for(int i=0; i< tomorrowArrayList.length; i++) {
                                        currentArraylist.add(tomorrowArrayList[i]);
                                      }
                                    }*/,
                                      ),
                                      new InkWell(
                                        child: new Text(
                                          "After",
                                          style: new TextStyle(
                                              color: Colors.white),
                                        ),
                                        onTap: () {
                                          print("After");
                                        },
                                      ),
                                    ],
                                  ),
                                ),

                                //Todo:----------------List----------------------
                            new Container(
                                margin: const EdgeInsets.only(top: 16),
                                height: 200.0,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: _currentArrayList.length,
                                    itemBuilder: (context, index) {
                                      return _currentArrayList[index];
                                      /*Container(
                                        width: 100.0,
                                        child: Card(
                                          elevation: 7,
                                          color: Colors.white24,
                                          child: Container(
                                            child: Center(
                                                child: new Container(
                                              child: new Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: <Widget>[
                                                  new ListTile(
                                                    title: new Text(
                                                      currentArraylist[index]['dt_txt']
                                                          .toString()
                                                          .substring(11, 16),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: new TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ),
                                                  new ListTile(
                                                    title: new Image.asset(
                                                      "$_images",
                                                      height: 50.0,
                                                      width: 50.0,
                                                    ),
                                                  ),
                                                  new ListTile(
                                                    title: new Text(
                                                      currentArraylist[index]['main']
                                                                  ['temp']
                                                              .toString() +
                                                          "°",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 20.0),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )),
                                          ),
                                        ),
                                      );*/
                                    }))
                              ],
                            ),
                          ],
                        )),
                  ],
                ),
              ));
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        } else {
          return new Center(
            child: new CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          );
        }
      });
}
