import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dondeviene/src/data/models/models.dart';
import 'package:dondeviene/src/data/services/trip_service.dart';

class AdminCreateTripController {
  BuildContext? context;
  Function? refresh;

  TextEditingController nombreCtrl = new TextEditingController();
  TextEditingController descripcionCtrl = new TextEditingController();

  TripService _tripService = new TripService();
  Usuario? usuario;

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;

    _tripService.init(context, refresh);
  }

  void createTrip() async {
    String nombre = nombreCtrl.text.trim();
    String descripcion = descripcionCtrl.text.trim();

    if (nombre.isEmpty || descripcion.isEmpty) {
      mostrarAlerta(context!, 'Error', 'debe ingresar todos los campos');
      return;
    }

    Trip trip = new Trip(nombre: nombre, descripcion: descripcion);

    ResponseApi responseApi = await _tripService.createTrip(trip);
    mostrarAlerta(context!, 'Ok', 'el viaje se creo correctamente');
    Navigator.pushNamedAndRemoveUntil(context!, 'admin/info', (route) => false);
    if (responseApi.data != null) {
      nombreCtrl.text = '';
      descripcionCtrl.text = '';
    }
  }
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
