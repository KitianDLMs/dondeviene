import 'package:flutter/material.dart';

import '../../../../data/services/services.dart';

class DriverHomeController {
  BuildContext? context;
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();
  TripService _tripService = new TripService();

  Future? init(BuildContext context) {
    this.context = context;
  }

  void openDrawer() {
    key.currentState?.openDrawer();
  }
}
