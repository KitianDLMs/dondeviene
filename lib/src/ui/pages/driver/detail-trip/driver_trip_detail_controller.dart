import 'package:dondeviene/src/ui/pages/pages.dart';
import 'package:flutter/material.dart';
import 'package:dondeviene/src/data/models/models.dart';
import 'package:dondeviene/src/data/services/services.dart';
import 'package:dondeviene/src/data/services/trip_service.dart';

class DriverTripDetailController {
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

  void updateTrip(Trip trip, context) async {
    Navigator.pushNamed(context, 'driver/map', arguments: trip.toJson() ?? '');
  }

  void getUsuarios() async {
    usuarios = await usuariosService.getDrivers();
    refresh!();
  }
}
