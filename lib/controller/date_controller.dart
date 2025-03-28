import 'package:flutter/material.dart';

class DateController extends ChangeNotifier {
  String selected = 'Bharath Gas'; 

  void changeDropDownValue(String value) {
    selected = value;
    notifyListeners();
  }
}
