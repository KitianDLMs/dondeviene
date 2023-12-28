import 'package:flutter/material.dart';

class AdminPrevHomeController {
  BuildContext? context;
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();

  Future? init(BuildContext context) {
    this.context = context;
  }

  void openDrawer() {
    key.currentState?.openDrawer();
  }
}
