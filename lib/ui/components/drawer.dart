import 'package:flutter/material.dart';
import 'package:norm_request/const/size_config.dart';
import 'package:norm_request/ui/common/icon_widget/info_widget.dart';

class CommonDrawer extends StatelessWidget{
  const CommonDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(50),
          ),
          color: Colors.transparent,
        ),
        child: DrawerListView(),
      ),
    );
  }
}

class DrawerListView extends StatelessWidget{
  @override

  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        CommonDrawerHeader(),
        DrawerListTile(Icon(Icons.home_outlined), 'Home', 'ホーム画面に戻ります。'),
        DrawerListTile(Icon(Icons.pets_outlined), 'Practice', '面接練習を行います。'),
        DrawerListTile(Icon(Icons.description_outlined), 'Report', '選考対策レポートを表示します。'),
        DrawerListTile(Icon(Icons.bookmark_outlined), 'Bookmark Company', 'お気に入りに登録した企業を表示します。'),
      ],
    );
  }
}

class CommonDrawerHeader extends StatelessWidget{
  @override

  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: DrawerHeader(
            child: Container(
              padding: EdgeInsets.only(
                left: 30,
              ),
              alignment: Alignment.centerLeft,
              child: DrawerHeaderProfile(),
            ),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/porigon.png'),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(75),
              ),
              color: Colors.yellow,
            ),
          ),
    );
  }
}

class DrawerHeaderProfile extends StatelessWidget{
  @override

  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Container(
          width: 60,
          height: 60,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage('images/icons/yuu.png'),
            ),
          ),
        ),
        const Text(
          "吉田 裕哉",
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const Text(
          "＠yuu",
          style: TextStyle(
            color: Colors.white70,
          ),
        ),
      ],
    );
  }
}

class DrawerListTile extends StatelessWidget{
  @override

  final Icon leading_icon;
  final String title;
  final String description;

  DrawerListTile(this.leading_icon, this.title, this.description);
  Widget build(BuildContext context) {
    return ListTile(
      leading: leading_icon,
      title: Text(title),
      trailing: InfoIcon(description),
    );
  }
}