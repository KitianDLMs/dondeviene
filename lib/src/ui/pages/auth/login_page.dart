import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:dondeviene/src/data/services/services.dart';
import 'package:dondeviene/src/ui/widgets/widgets.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

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
                  Labels(ruta: 'login-ios', titulo: '', subtitulo: 'Pasajero'),
                  Text(
                    '®dondeviene',
                    style: TextStyle(fontWeight: FontWeight.w200),
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
  bool obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Container(
      margin: EdgeInsets.only(top: 40),
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          CustomInput(
            icon: Icons.mail_outline,
            placeholder: 'Correo',
            keyboardType: TextInputType.emailAddress,
            textController: emailCtrl,
          ),
          CustomInput(
            icon: Icons.lock_outline,
            placeholder: 'Contraseña',
            isPassword: true,
            textController: passCtrl,
            suffixIcon: IconButton(
              icon: Icon(
                obscurePassword ? Icons.visibility_off : Icons.visibility,
              ),
              onPressed: () {
                setState(() {
                  obscurePassword = !obscurePassword;
                });
              },
            ),
            obscureText: obscurePassword,
          ),
          BotonAzul(
              text: 'Ingresar',
              onPressed: () async {
                if (!authService.autenticando) {
                  final _storage = new FlutterSecureStorage();
                  FocusScope.of(context).unfocus();
                  final loginOk = await authService.login(
                      emailCtrl.text.trim(), passCtrl.text.trim());
                  if (loginOk == true) {
                    final role = await _storage.read(key: 'role');
                    if (role == 'admin') {
                      Navigator.pushReplacementNamed(context, 'admin/home');
                    } else if (role == 'driver') {
                      Navigator.pushReplacementNamed(context, 'driver/home');
                    } else if (role == 'user') {
                      Navigator.pushReplacementNamed(context, 'user/home');
                    }
                  } else {
                    mostrarAlerta(
                        context, 'Login incorrecto', 'Revise sus credenciales');
                  }
                } else {
                  return null;
                }
              })
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
