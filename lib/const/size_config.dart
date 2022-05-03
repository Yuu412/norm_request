import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BlockSize{
  double width(BuildContext context) => MediaQuery.of(context).size.width / 100;
  double height(BuildContext context) => MediaQuery.of(context).size.height / 100;
}

