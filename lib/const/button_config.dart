import 'package:flutter/material.dart';
import 'package:norm_request/const/color_config.dart';
import 'package:norm_request/const/size_config.dart';

class NextButton {
  static final boxDecoration = BoxDecoration(
    gradient: LinearGradient(
      colors: [
        Color(RetButtonColor().gradientBlue()),
        Color(RetButtonColor().gradientPurple()),
      ],
    ),
    color: Color(RetBackgroundColor().white()),
    borderRadius: BorderRadius.circular(30),
  );

}