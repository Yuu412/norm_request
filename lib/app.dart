import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:norm_request/ui/auth/login/login_page.dart';
import 'package:norm_request/ui/home/home_page.dart';
import 'package:norm_request/ui/header.dart';


class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => StreamBuilder<User?>(
    stream: FirebaseAuth.instance.authStateChanges(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        // スプラッシュ画面などに書き換えても良い
        return const SizedBox();
      }

      if (snapshot.hasData) {
        return HomeApp();
      }
      return LoginPage();
    },
  );
}

class HomeApp extends StatefulWidget {
  const HomeApp({Key? key}) : super(key: key);

  @override
  _HomeApp createState() => _HomeApp();
}

class _HomeApp extends State<HomeApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
            home: Scaffold(
              appBar: Header("route"),
              body: HomePage(),
            ),
          );
  }

}
