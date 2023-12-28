import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:dondeviene/src/ui/widgets/widgets.dart';
import 'package:dondeviene/src/data/services/services.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffF2F2F2),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              height: Platform.isIOS
                  ? MediaQuery.of(context).size.height * 0.9
                  : MediaQuery.of(context).size.height * 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Logo(),
                  _Form(),
                  Labels(
                      ruta: 'login',
                      titulo: '¿Ya tienes una cuenta?',
                      subtitulo: '¡Ingresa aqui!'),
                  Text(
                    'dondeviene',
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
  final nombreCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final confirmPassCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Container(
      margin: EdgeInsets.only(top: 40),
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          CustomInput(
            icon: Icons.person_outline,
            placeholder: 'Nombre',
            textController: nombreCtrl,
          ),
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
          ),
          CustomInput(
            icon: Icons.lock,
            placeholder: 'Confirmar Contraseña',
            isPassword: true,
            textController: confirmPassCtrl,
          ),
          BotonAzul(
              text: 'Registrar',
              onPressed: () async {
                if (!authService.autenticando) {
                  if (passCtrl.value.text != confirmPassCtrl.value.text) {
                    mostrarAlerta(context, 'Registro incorrecto',
                        'contraseñas no coinciden');
                    return;
                  }
                  if (passCtrl.text.length < 6 ||
                      confirmPassCtrl.text.length < 6) {
                    mostrarAlerta(context, 'Registro incorrecto',
                        'las contraseñas deben tener un minimo de 6 seis caracteres');
                    return;
                  }
                  final registroOk = await authService.register(
                      nombreCtrl.text.trim(),
                      emailCtrl.text.trim(),
                      passCtrl.text.trim());

                  if (registroOk == true) {
                    Navigator.pushReplacementNamed(context, 'user/home');
                  } else {
                    mostrarAlerta(
                        context, 'Registro incorrecto', '$registroOk');
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
