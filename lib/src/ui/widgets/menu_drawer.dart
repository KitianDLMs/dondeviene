import 'package:dondeviene/src/ui/pages/pages.dart';
import 'package:flutter/material.dart';

class MenuDrawer extends StatelessWidget {
  UserPrevHomePageController _con = new UserPrevHomePageController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _con.openDrawer,
      child: Container(
        margin: EdgeInsets.only(left: 20),
        alignment: Alignment.centerLeft,
        child: Image.asset(
          'assets/menu.png',
          width: 20,
          height: 20,
        ),
      ),
    );
  }
}
