import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/services/services.dart';

class DrawerUsr extends StatelessWidget {
  const DrawerUsr({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.lightGreenAccent.shade700,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pasajero',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                    maxLines: 1,
                  ),
                  Text(
                    'Conectado',
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic),
                    maxLines: 1,
                  ),
                  Container(
                    height: 60,
                    margin: EdgeInsets.only(top: 10),
                    child: FadeInImage(
                      placeholder: AssetImage('assets/logo.png'),
                      image: AssetImage('assets/logo.png'),
                      fadeInDuration: Duration(milliseconds: 50),
                      fit: BoxFit.contain,
                    ),
                  )
                ],
              )),
          ListTile(
              title: Text('Inicio'),
              trailing: Icon(Icons.home_outlined),
              onTap: () async {
                Navigator.pushNamedAndRemoveUntil(
                    context, 'user/home', (route) => false);
              }),
          ListTile(
              title: Text('Lista de viajes'),
              trailing: Icon(Icons.info_outline),
              onTap: () async {
                Navigator.pushNamedAndRemoveUntil(
                    context, 'user/info', (route) => false);
              }),
          // ListTile(
          //     title: Text('Terminos y condiciones'),
          //     trailing: Icon(Icons.settings_outlined),
          //     onTap: () async {
          //       launch("${_url}");
          //     }),
          ListTile(
              title: Text('Salir'),
              trailing: Icon(Icons.exit_to_app_outlined),
              onTap: () async {
                Navigator.pushNamedAndRemoveUntil(
                    context, 'login-ios', (route) => false);

                AuthService.deleteToken();
              }),
        ],
      ),
    );
  }
}
