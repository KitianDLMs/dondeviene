import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/services/services.dart';

class DrawerAdmin extends StatelessWidget {
  const DrawerAdmin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
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
                    '${authService.usuario!.nombre}',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                    maxLines: 1,
                  ),
                  Text(
                    '${authService.usuario!.email}',
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
                    context, 'admin/home', (route) => false);
              }),
          ListTile(
              title: Text('Información'),
              trailing: Icon(Icons.info_outline),
              onTap: () async {
                Navigator.pushNamedAndRemoveUntil(
                    context, 'admin/info', (route) => false);
              }),
          ListTile(
              title: Text('Cerrar sesión'),
              trailing: Icon(Icons.exit_to_app_outlined),
              onTap: () async {
                Navigator.pushNamedAndRemoveUntil(
                    context, 'login', (route) => false);
                AuthService.deleteToken();
              }),
        ],
      ),
    );
  }
}
