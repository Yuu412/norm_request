import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:norm_request/ui/auth/login/login_page.dart';
import 'package:norm_request/ui/home/home_page.dart';
import 'package:norm_request/ui/header.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:version/version.dart';

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

          //FirebaseAuth.instance.signOut();

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
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: Header("route"),
        body: JudgeUpdate(),
      ),
    );
  }
}

class JudgeUpdate extends StatelessWidget {
  /// FIXME ストアにアプリを登録したらurlが入れられる
  static const appStoreURL =
      'https://apps.apple.com/jp/app/id[アプリのApple ID]?mt=8';

  /// ダイアログを表示
  void showUpdateDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        const title = 'バージョン更新のお知らせ';
        const message = '新しいバージョンのアプリが利用可能です。ストアより更新版を入手して、ご利用下さい。';
        const btnLabel = '今すぐ更新';
        return CupertinoAlertDialog(
          title: const Text(title),
          content: const Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text(
                btnLabel,
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () async {
                if (await canLaunch(appStoreURL)) {
                  await launch(
                    appStoreURL,
                    forceSafariVC: true,
                    forceWebView: true,
                  );
                } else {
                  throw Error();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Future<void> versionCheck() async {
      //アプリのバージョンを取得
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = Version.parse(packageInfo.version);

      //Firestoreからアップデートしたいバージョンを取得
      final doc = await FirebaseFirestore.instance
          .collection('config')
          .doc('8vcZ2rNFIL04UAWOKlXm')
          .get();

      final newVersion =
          Version.parse(doc.data()!['ios_force_app_version'] as String);

      //バージョンを比較し、現在のバージョンの方が低ければダイアログを出す
      if (currentVersion < newVersion) {
        showUpdateDialog(context);
      }
    }

    versionCheck();

    return HomePage();
  }
}
