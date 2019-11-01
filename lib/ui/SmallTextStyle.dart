import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;

class SmallText extends StatelessWidget {
  final String text;

  SmallText(this.text);

  Widget build(BuildContext context) {
    return new Text(
      text,
      style: new prefix0.TextStyle(
          fontSize: 30, color: Colors.white, fontWeight: FontWeight.w600),
    );
  }
}
