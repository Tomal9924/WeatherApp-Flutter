class WeatherModel {
  double _temp;
  String _time;
  String _image;

  WeatherModel(this._temp, this._time, this._image);

  String get image => _image;

  set image(String value) {
    _image = value;
  }

  String get time => _time;

  set time(String value) {
    _time = value;
  }

  double get temp => _temp;

  set temp(double value) {
    _temp = value;
  }
}
