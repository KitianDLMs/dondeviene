import 'dart:async';
import 'dart:io';

import 'package:dondeviene/src/ui/pages/access/ios/login_page_ios.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/blocs.dart';

class GpsAccessPage extends StatefulWidget {
  const GpsAccessPage({Key? key}) : super(key: key);

  @override
  State<GpsAccessPage> createState() => _GpsAccessPageState();
}

class _GpsAccessPageState extends State<GpsAccessPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(milliseconds: 2500), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPageIos()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: BlocBuilder<GpsBloc, GpsState>(
        builder: (context, state) {
          return _EnableGpsMessage();
        },
      )),
    );
  }
}

class _AccessButton extends StatelessWidget {
  const _AccessButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('¿Dónde viene? funciona mejor con tu ubicación'),
        MaterialButton(
            child: const Text('Solicitar Acceso',
                style: TextStyle(color: Colors.white)),
            color: Colors.black,
            shape: const StadiumBorder(),
            elevation: 0,
            splashColor: Colors.transparent,
            onPressed: () {
              final gpsBloc = BlocProvider.of<GpsBloc>(context);
              gpsBloc.askGpsAccess();
            })
      ],
    );
  }
}

class _EnableGpsMessage extends StatelessWidget {
  const _EnableGpsMessage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Image.asset(
        //   'assets/dv-logo-black.png',
        //   scale: 2.0,
        // ),
        SizedBox(height: 20),
        const Text(
          'Ingresando...',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w300),
        ),
        Divider(color: Colors.transparent),
        CircularProgressIndicator(
            color: Colors.black, backgroundColor: Colors.grey),
      ],
    );
  }
}
