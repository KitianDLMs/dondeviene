import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:dondeviene/src/data/services/services.dart';
import 'package:dondeviene/src/ui/widgets/widgets.dart';

class LoginPageIos extends StatelessWidget {
  LoginPageIos({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffF2F2F2),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.9,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Logo(),
                  _Form(),
                  Platform.isAndroid
                      ? Labels(ruta: 'login', titulo: '', subtitulo: 'Auth')
                      : Container(),
                  Container(
                    margin: EdgeInsets.only(bottom: 30),
                    child: Text(
                      '®dondeviene',
                      style: TextStyle(fontWeight: FontWeight.w200),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}

class _Form extends StatefulWidget {
  @override
  __FormState createState() => __FormState();
}

class __FormState extends State<_Form> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Container(
      margin: EdgeInsets.only(top: 40),
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          BotonAzul(
              text: 'Ingresar',
              onPressed: () {
                Navigator.pushReplacementNamed(context, 'user/info');
              }
              // authService.autenticando
              //     ? null
              //     : () async {
              //         Navigator.pushReplacementNamed(context, 'user/info');
              //       }
              )
        ],
      ),
    );
  }

  mostrarAlerta(BuildContext context, String titulo, String subtitulo) {
    if (Platform.isAndroid) {
      return showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: Text(titulo),
                content: Text(subtitulo),
                actions: [
                  MaterialButton(
                      child: Text('Ok'),
                      elevation: 5,
                      textColor: Colors.blue,
                      onPressed: () => Navigator.pop(context))
                ],
              ));
    }

    showCupertinoDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
              title: Text(titulo),
              content: Text(subtitulo),
              actions: [
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: Text('Ok'),
                  onPressed: () => Navigator.pop(context),
                )
              ],
            ));
  }
}
