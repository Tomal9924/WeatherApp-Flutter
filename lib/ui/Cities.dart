class Cities{

  String countryName;
  String cityName;
  String regionName;

  Cities(this.countryName, this.cityName, this.regionName);

  Cities.fromMap(Map<String, dynamic> map)
  {
    countryName = map['name'];
    cityName = map['capital'];
    regionName = map['region'];
  }


}