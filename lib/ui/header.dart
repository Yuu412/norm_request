import 'package:flutter/material.dart';
import 'package:norm_request/const/color_config.dart';

class Header extends StatelessWidget with PreferredSizeWidget{
  final String leading;
  Header(this.leading);

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color(RetBackgroundColor().white()),
      title: _HeaderTitle(),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
      ),
      elevation: 0.0, // AppBar下の影が消える
    );
  }
}

class _HeaderTitle extends StatelessWidget {
  const _HeaderTitle({Key? key}) : super(key: key);
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return Text(
      'norm',
      style: TextStyle(
        fontSize: 28,
        color: Color(RetTextColor().gray()),
        fontWeight: FontWeight.w300,
      ),
    );
  }
}
