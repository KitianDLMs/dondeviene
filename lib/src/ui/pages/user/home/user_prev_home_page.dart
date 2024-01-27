import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../pages.dart';

class UserHomeMainPage extends StatefulWidget {
  const UserHomeMainPage({super.key});

  @override
  State<UserHomeMainPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<UserHomeMainPage> {
  UserPrevHomePageController _con = new UserPrevHomePageController();

  @override
  Widget build(BuildContext context) {
    final Uri _url = Uri.parse('');
    return Scaffold(
      key: _con.key,
      appBar: AppBar(
        leading: _menuDrawer(),
        title: const Text(
          "®Echnelapp",
          style: TextStyle(color: Colors.grey, fontSize: 15),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            Image.asset("assets/logo.png", height: 40),
            const SizedBox(
              height: 20,
            ),
            const Padding(
              padding: EdgeInsets.all(4.0),
              child: Text(
                "Esta App fue desarrollada en Santiago.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "En caso de cualquier uso indebido o cualquier informe, comuníquese con el administrador a echnelapp@gmail.com",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: GestureDetector(
                  onTap: () => {launch("${_url}")},
                  child: Text(
                    'Terminos y condiciones',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  )),
            ),
            const SizedBox(
              height: 550,
            ),
            const Padding(
              padding: EdgeInsets.all(4.0),
              child: Text(
                "®Echnelapp.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuDrawer() {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamedAndRemoveUntil(
            context, 'user/info', (route) => false);
      },
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
