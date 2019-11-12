import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DateSelector extends StatefulWidget {
  final List<String> dates;

  DateSelector({@required this.dates});

  @override
  _DateSelectorState createState() => new _DateSelectorState();
}

class _DateSelectorState extends State<DateSelector> {
  int _currentIndex = 0;
  bool _isDetected;

  List<Widget> _createDates() {
    return widget.dates.map((date) {
      var index = widget.dates.indexOf(date);
      _isDetected = _currentIndex == index;
      return Padding(
        padding: EdgeInsets.only(right: ScreenUtil().setWidth(75)),
        child: GestureDetector(
          onTap: () {
            setState(() {
              _currentIndex = index;
            });
          },
          child: Text(date,
              style: new TextStyle(
                  color: _isDetected ? Colors.grey.shade400 : Colors.white,
                  fontSize: _isDetected ? 22 : 16,
                  fontWeight: FontWeight.w500,
                  fontFamily: "Roboto")),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(
      children: _createDates(),
    );
  }
}
