import 'package:dondeviene/src/data/models/trip.dart';
import 'package:dondeviene/src/ui/pages/access/ios/login_page_ios.dart';
import 'package:flutter/material.dart';
import 'package:dondeviene/src/ui/pages/pages.dart';

final Map<String, Widget Function(BuildContext)> appRoutes = {
  'loading': (context) => LoadingPage(),
  // ignore: todo
  // TODO * ADMIN
  'admin/home': (context) => HomeAdminMainPage(),
  'admin/info': (context) => AdminGetTripPage(),
  'admin/map': (context) => AdminMapPage(),
  'admin/trip': (context) => AdminCreateTripPage(),
  'admin/trip/update': (context) => AdminUpdateTripPage(),

  // ? USER
  'user/home': (context) => UserHomeMainPage(),
  'user/info': (context) => UserGetTripPage(),
  'user/trip': (context) => UserGetTripPage(),
  'user/map': (context) => UserMapPage(),
  'user/trip/detail': (context) =>
      UserTripDetailPage(trip: new Trip(descripcion: '')),

  'driver/home': (context) => DriverHomePage(),
  // ! DRIVER
  'driver/trip': (context) => DriverGetTripPage(),
  'driver/info': (context) => DriverGetTripPage(),
  'driver/map': (context) => DriverMapPage(),
  'driver/trip/detail': (context) => DriverTripDetailPage(),

  'login': (context) => LoginPage(),
  'login-ios': (context) => LoginPageIos(),
  'register': (context) => RegisterPage(),
};
