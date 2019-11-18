import 'package:flutter/material.dart';


class RowForecast extends StatelessWidget {
  double _temperature;
  String _image;
  String _time;

  RowForecast(this._temperature, this._image, this._time);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        new Container(
          child: new Text(
            _time.substring(11, 16),
            textAlign:
            TextAlign.center,
            style: new TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
        new Container(
          child: new Image.asset(
            _image,
            height: 50.0,
            width: 50.0,
          ),
        ),
        new Container(
          child: new Text(
            _temperature.toString() +
                "°",
            textAlign:
            TextAlign.center,
            style: TextStyle(
                color: Colors.white,
                fontSize: 20.0),
          ),
        ),
      ],
    );
  }
}
