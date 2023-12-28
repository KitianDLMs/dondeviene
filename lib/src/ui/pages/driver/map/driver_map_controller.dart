import 'dart:async';

import 'package:dondeviene/src/global/environment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' as location;
import 'package:dondeviene/src/data/models/models.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../../../data/services/services.dart';

class DriverMapController {
  BuildContext? context;

  Function? refresh;
  Position? _position;
  StreamSubscription? _positionStream;

  String? addressName;
  LatLng? addressLatLng;

  CameraPosition initialPosition =
      CameraPosition(target: LatLng(-33.3240483, -70.7252671), zoom: 14);

  Completer<GoogleMapController> _mapController = Completer();

  BitmapDescriptor? tripMarker;
  BitmapDescriptor? tripToMarker;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  late Trip trip;

  Set<Polyline> polylines = {};
  List<LatLng> points = [];

  TripService tripService = new TripService();
  SocketService socketService = new SocketService();
  IO.Socket? socket;

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    trip = Trip.fromJson(
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>);

    tripMarker = await createMarkerFromAssets('assets/trip.png');
    tripToMarker = await createMarkerFromAssets('assets/terminal.png');

    socket = IO.io('${Environment.API_URL}trip/driver', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false
    });
    socket!.connect();

    updateLocation();
    tripService.init(context, refresh);
    checkGps();
  }

  void saveLocation() async {
    trip!.lat = _position!.latitude;
    trip!.lng = _position!.longitude;
    await tripService.updateLatLng(trip!);
  }

  void emitPosition() {
    if (_position != null) {
      socket!.emit('position', {
        'id_trip': trip!.uid,
        'lat': _position!.latitude,
        'lng': _position!.longitude,
      });
    }
  }

  void isCloseToDriverPosition() {}

  void updateToFinish() async {
    ResponseApi responseApi = await tripService.updateTripToFinish(trip!);
    Navigator.pushNamedAndRemoveUntil(
        context!, 'driver/info', (route) => false);
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

  void addMarker(String markerId, double lat, double lng, String title,
      String content, BitmapDescriptor iconMarker) {
    MarkerId id = MarkerId(markerId);
    Marker marker = Marker(
        markerId: id,
        icon: iconMarker,
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
          refresh;
        }
      }
    }
  }

  void onMapCreated(GoogleMapController controller) {
    controller.setMapStyle(
        '[{"elementType":"geometry","stylers":[{"color":"#f5f5f5"}]},{"elementType":"labels.icon","stylers":[{"visibility":"off"}]},{"elementType":"labels.text.fill","stylers":[{"color":"#616161"}]},{"elementType":"labels.text.stroke","stylers":[{"color":"#f5f5f5"}]},{"featureType":"administrative.land_parcel","elementType":"labels.text.fill","stylers":[{"color":"#bdbdbd"}]},{"featureType":"poi","elementType":"geometry","stylers":[{"color":"#eeeeee"}]},{"featureType":"poi","elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"featureType":"poi.park","elementType":"geometry","stylers":[{"color":"#e5e5e5"}]},{"featureType":"poi.park","elementType":"labels.text.fill","stylers":[{"color":"#9e9e9e"}]},{"featureType":"road","elementType":"geometry","stylers":[{"color":"#ffffff"}]},{"featureType":"road.arterial","elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"featureType":"road.highway","elementType":"geometry","stylers":[{"color":"#dadada"}]},{"featureType":"road.highway","elementType":"labels.text.fill","stylers":[{"color":"#616161"}]},{"featureType":"road.local","elementType":"labels.text.fill","stylers":[{"color":"#9e9e9e"}]},{"featureType":"transit.line","elementType":"geometry","stylers":[{"color":"#e5e5e5"}]},{"featureType":"transit.station","elementType":"geometry","stylers":[{"color":"#eeeeee"}]},{"featureType":"water","elementType":"geometry","stylers":[{"color":"#c9c9c9"}]},{"featureType":"water","elementType":"labels.text.fill","stylers":[{"color":"#9e9e9e"}]}]');
    _mapController.complete(controller);
  }

  void dispose() {
    _positionStream?.cancel();
    socket!.disconnect();
  }

  void updateLocation() async {
    try {
      await _determinePosition(); // OBTENER LA POSICION ACTUAL Y TAMBIEN SOLICITAR LOS PERMISOS
      _position = await Geolocator.getLastKnownPosition(); // LAT Y LNG
      saveLocation();

      animatedCameraToPosition(_position!.latitude, _position!.longitude);
      saveLocation();

      addMarker('Paradero Escuela la Merced', -33.0902654, -70.9233629,
          'Escuela La Merced', '', tripToMarker!);
      addMarker('Terminal Estación central, Santiago', -33.4509132, -70.6791715,
          'Estacion central', '', tripToMarker!);

      LatLng from = new LatLng(-33.4509132, -70.6791715);
      LatLng to = new LatLng(-33.0902654, -70.9233629);
      setPolylines(from, to);

      _positionStream =
          Geolocator.getPositionStream().listen((Position position) {
        _position = position;
        emitPosition();
        //! MARCADOR EN TIEMPO REAL
        addMarker('iddriver', _position!.latitude, _position!.longitude,
            'Tu Posición', '', tripMarker!);
        animatedCameraToPosition(_position!.latitude, _position!.longitude);
        isCloseToDriverPosition();

        refresh!();
      });
    } catch (e) {
      print('Error: $e');
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
}
