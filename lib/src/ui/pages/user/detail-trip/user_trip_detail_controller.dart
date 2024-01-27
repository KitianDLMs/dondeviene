import 'package:flutter/material.dart';
import 'package:dondeviene/src/data/models/models.dart';

import '../../../../data/services/services.dart';

class UserTripDetailController {
  BuildContext? context;
  Function? refresh;

  Trip? trip;
  List<Usuario> usuarios = [];
  UsuariosService usuariosService = new UsuariosService();
  TripService tripService = new TripService();
  ValueService valueService = new ValueService();
  String? idDriver;
  List<String> status = ['Estacionado', 'EnCamino', 'Finalizado'];

  Future? init(BuildContext context, Function refresh, Trip trip) {
    this.context = context;
    this.refresh = refresh;
    this.trip = trip;
    usuariosService.init(context, refresh);
    tripService.init(context, refresh);
    getUsuarios();
    getValues();
    refresh();
  }

  void updateTrip() async {
    Navigator.pushNamed(context!, 'user/map', arguments: trip!.toJson() ?? '');
  }

  Future<List<Value>> getValues() async {
    return await valueService.getAll();
  }

  void getUsuarios() async {
    usuarios = await usuariosService.getDrivers();
    refresh!();
  }
}
