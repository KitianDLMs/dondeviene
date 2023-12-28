import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' as location;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:google_maps_webservice/directions.dart' as GSM;

import '../../../../data/models/models.dart';
import '../../../../data/services/services.dart';
import '../../../../global/environment.dart';

class UserMapController {
  BuildContext? context;
  Function? refresh;
  Position? position;

  String? addressName;
  LatLng? addressLatLng;
  String? duration;

  CameraPosition initialPosition =
      CameraPosition(target: LatLng(-33.3240483, -70.7252671), zoom: 10);

  Completer<GoogleMapController> _mapController = Completer();

  BitmapDescriptor? tripMarker;
  BitmapDescriptor? tripMarkerUsr;
  BitmapDescriptor? tripToMarkerUsr;
  BitmapDescriptor? userPosition;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  TripService _tripService = new TripService();

  late Trip trip;

  Set<Polyline> polylines = {};
  List<LatLng> points = [];

  var origin;
  var to;
  // var origin = new Location();
  // var to = new Location();

  var timeLat;
  var timeLng;

  TripService tripService = new TripService();

  IO.Socket? socket;

  final _storage = new FlutterSecureStorage();

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    tripMarker = await createMarkerFromAssets('assets/trip.png');
    tripMarkerUsr = await createMarkerFromAssets('assets/terminal.png');
    tripToMarkerUsr = await createMarkerFromAssets('assets/terminal.png');
    // userPosition = await createMarkerFromAssets('assets/user-location');
    trip = Trip.fromJson(
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>);

    addMarker('Til-Til', -33.0902654, -70.9233629, 'Paradero Escuela la Merced',
        '', tripMarkerUsr!);
    addMarker('Santiago', -33.4509132, -70.6791715,
        'Terminal de Estación central, Santiago ', '', tripToMarkerUsr!);

    // setPolylines(
    //     LatLng(-33.0902654, -70.9233629), LatLng(-33.4509132, -70.6791715));

    final uidUsrTrip = await _storage.read(key: 'uidUsrTrip');

    socket = IO.io('${Environment.API_URL}trip/driver', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false
    });

    socket!.connect();
    socket!.on('position/$uidUsrTrip', (data) async {
      addMarker(
          'driverTrip', data['lat'], data['lng'], 'Tu viaje', '', tripMarker!);

      timeLat = data['lat'];
      timeLng = data['lng'];

      // setPolylines(LatLng(timeLat, timeLng),
      //     LatLng(position?.latitude, position?.longitude));

      // getTime(
      //     Location(latitude: position.latitude, longitude: position.longitude),
      //     Location(latitude: timeLat, longitude: timeLng));
    });

    tripService.init(context, refresh);

    checkGps();
  }

  // ! ES NECESARIO AGREGAR LA CUENTA DE FACTURACION PARA PODER HABILITAR LA API QUE USA ESTA FUNCION 'DIRECTIONS'
  Future<String> getTime(Location o, Location t) async {
    var duration;
    GSM.GoogleMapsDirections directions =
        GSM.GoogleMapsDirections(apiKey: '${Environment.API_KEY_MAPS}');
    print(o.toString());
    print(t.toString());
    GSM.DirectionsResponse response = await directions.directions(
        '${o.latitude},${o.longitude}', // Convierte Location en una cadena de coordenadas
        '${t.latitude},${t.longitude}');

    print('response status -> ${response.errorMessage}');

    if (response.isOkay) {
      var route = response.routes[0];
      var leg = route.legs[0];
      duration = leg.duration.text;
      var durationInSeconds = leg.duration.value;
      print('Duración estimada (en segundos): $durationInSeconds');
      return '$duration';
    } else {
      return 'Error al obtener las direcciones ${response.errorMessage}';
    }
    // return duration;
  }

  Future<List<Trip>> getTripsByStatus() async {
    return await _tripService.findByDriverAndStatus();
  }

  Future<void> setPolylines(LatLng from, LatLng to) async {
    PointLatLng pointFrom = PointLatLng(from.latitude, from.longitude);
    PointLatLng pointTo = PointLatLng(to.latitude, to.longitude);

    PolylineResult result = await PolylinePoints().getRouteBetweenCoordinates(
        Environment.API_KEY_MAPS, pointFrom, pointTo);
    for (PointLatLng point in result.points) {
      points.add(LatLng(point.latitude, point.longitude));
    }

    Polyline polyline = Polyline(
        polylineId: PolylineId('poly'),
        color: Colors.red,
        points: points,
        width: 6);

    polylines.add(polyline);

    refresh!();
  }

  addMarker(String markerId, double lat, double lng, String title,
      String content, BitmapDescriptor iconMarker) {
    MarkerId id = MarkerId(markerId);
    Marker marker = Marker(
        markerId: id,
        icon: iconMarker ?? BitmapDescriptor.defaultMarker,
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(title: title, snippet: content));
    markers[id] = marker;
    refresh!();
  }

  Future<BitmapDescriptor> createMarkerFromAssets(String path) async {
    ImageConfiguration configuration = ImageConfiguration();
    BitmapDescriptor descriptor =
        await BitmapDescriptor.fromAssetImage(configuration, path);
    return descriptor;
  }

  Future<Null> setLocationDraggableInfo() async {
    if (initialPosition != null) {
      double lat = initialPosition.target.latitude;
      double lng = initialPosition.target.longitude;

      List<Placemark> address = await placemarkFromCoordinates(lat, lng);

      if (address != null) {
        if (address.length > 0) {
          String direction = address[0].thoroughfare!;
          String street = address[0].subThoroughfare!;
          String city = address[0].locality!;
          String department = address[0].administrativeArea!;
          String country = address[0].country!;

          addressName = '$direction #$street, $city, $department';
          addressLatLng = new LatLng(lat, lng);
          refresh!();
        }
      }
    }
  }

  void dispose() {
    socket?.disconnect();
  }

  void onMapCreated(GoogleMapController controller) {
    controller.setMapStyle(
        '[{"elementType":"geometry","stylers":[{"color":"#f5f5f5"}]},{"elementType":"labels.icon","stylers":[{"visibility":"off"}]},{"elementType":"labels.text.fill","stylers":[{"color":"#616161"}]},{"elementType":"labels.text.stroke","stylers":[{"color":"#f5f5f5"}]},{"featureType":"administrative.land_parcel","elementType":"labels.text.fill","stylers":[{"color":"#bdbdbd"}]},{"featureType":"poi","elementType":"geometry","stylers":[{"color":"#eeeeee"}]},{"featureType":"poi","elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"featureType":"poi.park","elementType":"geometry","stylers":[{"color":"#e5e5e5"}]},{"featureType":"poi.park","elementType":"labels.text.fill","stylers":[{"color":"#9e9e9e"}]},{"featureType":"road","elementType":"geometry","stylers":[{"color":"#ffffff"}]},{"featureType":"road.arterial","elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"featureType":"road.highway","elementType":"geometry","stylers":[{"color":"#dadada"}]},{"featureType":"road.highway","elementType":"labels.text.fill","stylers":[{"color":"#616161"}]},{"featureType":"road.local","elementType":"labels.text.fill","stylers":[{"color":"#9e9e9e"}]},{"featureType":"transit.line","elementType":"geometry","stylers":[{"color":"#e5e5e5"}]},{"featureType":"transit.station","elementType":"geometry","stylers":[{"color":"#eeeeee"}]},{"featureType":"water","elementType":"geometry","stylers":[{"color":"#c9c9c9"}]},{"featureType":"water","elementType":"labels.text.fill","stylers":[{"color":"#9e9e9e"}]}]');
    _mapController.complete(controller);
  }

  void updateLocation() async {
    try {
      await _determinePosition();
      position = await Geolocator.getLastKnownPosition();

      // addMarker('iduser', position.latitude, position.longitude, 'Tu Posición',
      //     '', userPosition);

      refresh!();
    } catch (e) {
      print(e);
    }
  }

  void checkGps() async {
    bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    if (isLocationEnabled) {
      updateLocation();
    } else {
      bool locationGPS = await location.Location().requestService();
      if (locationGPS) {
        updateLocation();
      }
    }
  }

  Future animatedCameraToPosition(double lat, double lng) async {
    GoogleMapController controller = await _mapController.future;
    if (controller != null) {
      controller.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(lat, lng), zoom: 13)));
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  void back() {
    Navigator.pop(context!);
    socket!.disconnect();
  }
}
