import 'package:flutter/material.dart';

class ShadePasswordModel extends ChangeNotifier {
  bool? isObsucure;

  void init() async {
    isObsucure = true;
    notifyListeners();
  }

  changeState() async{
    isObsucure = !isObsucure!;
    notifyListeners();
  }
}