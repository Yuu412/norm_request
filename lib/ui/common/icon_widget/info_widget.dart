import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:norm_request/const/color_config.dart';

class InfoIcon extends StatelessWidget {
  final String description;
  InfoIcon(this.description);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            return InfoDialog(description);
          },
        );
      },
      child: Icon(
        Icons.info_outline,
        color: Color(RetIconColor().lightGray()),
        size: 18,
      ),
    );
  }
}

class InfoDialog extends StatelessWidget {
  final String description;
  InfoDialog(this.description);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("説明"),
      content: Text(description),
      actions: [
        FlatButton(
          child: Text("OK"),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}