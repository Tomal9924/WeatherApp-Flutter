import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/ui/Klimatic.dart';
import 'package:weather_app/ui/ThemeChanger.dart';

void main() {
  runApp(
      final theme=Provider.of(con)
      new MaterialApp(
    title: "Klimatic",
    theme: ThemeData(fontFamily: 'Roboto'),
    debugShowCheckedModeBanner: false,
    home: new Klimatic(),
  ));
}







