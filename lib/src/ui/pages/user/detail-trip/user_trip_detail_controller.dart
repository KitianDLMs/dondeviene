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
  String? idDriver;

  Future? init(BuildContext context, Function refresh, Trip trip) {
    this.context = context;
    this.refresh = refresh;
    this.trip = trip;
    usuariosService.init(context, refresh);
    tripService.init(context, refresh);
    getUsuarios();
    refresh();
  }

  void updateTrip() async {
    Navigator.pushNamed(context!, 'user/map', arguments: trip!.toJson() ?? '');
  }

  void getUsuarios() async {
    usuarios = await usuariosService.getDrivers();
    refresh!();
  }
}
