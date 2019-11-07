import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;

class PlaceText extends StatelessWidget{

  final String text;

  PlaceText(this.text);

  Widget build(BuildContext context) {
    return new Text(text,
      style: new prefix0.TextStyle(fontSize: 20,
        color: Colors.white,
          fontStyle: FontStyle.normal),);
  }

}