import 'package:flutter/material.dart';

class DateController extends ChangeNotifier {
   String selected = 'Bharath gas';


   void changeDropDownValue(String value){
     selected = value;
     notifyListeners();
   }
}