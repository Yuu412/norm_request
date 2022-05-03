import 'package:flutter/material.dart';
import 'package:norm_request/ui/components/drawer.dart';
import '../header.dart';

class MessagePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: 250,
            height: 250,
            child: Image.asset('images/message.png',),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              "公開準備中",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          Text(
            '現在、機能の準備を進めています。\n　今しばらくお待ちください。',
            style: TextStyle(
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}