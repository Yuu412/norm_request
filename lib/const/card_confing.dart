import 'package:flutter/material.dart';
import 'package:norm_request/const/color_config.dart';
import 'package:norm_request/const/size_config.dart';

class Styles {
  static final cardStyle = BoxDecoration(
    color: Color(RetCardColor().white()),
    borderRadius: BorderRadius.circular(10.0),
    boxShadow: [
      BoxShadow(
        color: Color(ShadowColor().shadowColor()), //色
        offset: Offset(3, 3),
        blurRadius: 10.0,
        spreadRadius: 1,
      ),
    ],
  );
}

class SelectedCard {
  static final boxDecoration = BoxDecoration(
    gradient: LinearGradient(
      begin: FractionalOffset.topCenter,
      end: FractionalOffset.bottomCenter,
      colors: [
        Color(RetCardColor().gradientBlue()),
        Color(RetCardColor().gradientPurple()),
      ],
    ),
    borderRadius: BorderRadius.circular(10.0),
    boxShadow: [
      BoxShadow(
        color: Color(ShadowColor().shadowColor()), //色
        offset: Offset(3, 3),
        blurRadius: 10.0,
        spreadRadius: 1,
      ),
    ],
  );
}