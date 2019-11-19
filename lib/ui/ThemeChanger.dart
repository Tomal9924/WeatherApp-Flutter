
import 'package:flutter/material.dart';

class ThemeChanger extends ChangeNotifier{
   ThemeData _themeData;

   ThemeChanger(this._themeData);

   ThemeData get themeData => _themeData;

   set themeData(ThemeData theme) {
     _themeData = theme;
     notifyListeners();
   }


}