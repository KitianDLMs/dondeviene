import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'package:dondeviene/src/global/environment.dart';
import 'package:dondeviene/src/data/models/models.dart';

class TripService {
  String _api = 'trip';
  BuildContext? context;
  Usuario? usuario;
  final _storage = new FlutterSecureStorage();

  Future init(BuildContext context, Function refresh) {
    this.context = context;
    return refresh();
  }

  Future<List<Trip>> getByStatus(String status) async {
    try {
      var url = Uri.parse('${Environment.apiUrl}/$_api/findByStatus/$status');

      Map<String, String> headers = {'Content-type': 'application/json'};

      final res = await http.get(url, headers: headers);

      if (res.statusCode == 401) {
        mostrarAlerta(context!, 'error al obtener los Viajes',
            'hay un error al obtener los viajes intentelo denuevo');
      }

      final data = json.decode(res.body); // Trips
      Trip trip = Trip.fromJsonList(data);
      return trip.toList;
    } catch (e) {
      return [];
    }
  }

  Future<List<Trip>> getByLine(String line) async {
    try {
      var url = Uri.parse('${Environment.apiUrl}/$_api/findByStatus/$line');

      Map<String, String> headers = {'Content-type': 'application/json'};

      final res = await http.get(url, headers: headers);

      if (res.statusCode == 401) {
        mostrarAlerta(context!, 'error al obtener los Viajes',
            'hay un error al obtener los viajes intentelo denuevo');
      }

      final data = json.decode(res.body); // Trips
      Trip trip = Trip.fromJsonList(data);
      return trip.toList;
    } catch (e) {
      return [];
    }
  }

  Future<List<Trip>> findByDriverAndStatus() async {
    final _storage = new FlutterSecureStorage();
    var id = await _storage.read(key: 'uid');
    try {
      var url =
          Uri.parse('${Environment.apiUrl}/$_api/findByDriverAndStatus/$id');

      Map<String, String> headers = {'Content-type': 'application/json'};

      final res = await http.get(url, headers: headers);
      if (res.statusCode == 401) {
        mostrarAlerta(context!, 'error al obtener los Viajes',
            'hay un error al obtener los viajes intentelo denuevo');
      }

      final data = json.decode(res.body); // Trips
      Trip trip = Trip.fromJsonList(data);
      return trip.toList;
    } catch (e) {
      return [];
    }
  }

  Future<List<Trip>> getAll() async {
    try {
      var url = Uri.parse('${Environment.apiUrl}/$_api');

      Map<String, String> headers = {'Content-type': 'application/json'};

      final res = await http.get(url, headers: headers);

      final data = json.decode(res.body); // Trips
      Trip trip = Trip.fromJsonList(data);
      return trip.toList;
    } catch (e) {
      return [];
    }
  }

  Future<ResponseApi> createTrip(Trip trip) async {
    try {
      var url = Uri.parse('${Environment.apiUrl}/$_api');
      String bodyParams = json.encode(trip);
      Map<String, String> headers = {'Content-type': 'application/json'};

      final res = await http.post(url, headers: headers, body: bodyParams);

      if (res.statusCode == 401) {
        mostrarAlerta(context!, 'error al crear Viaje',
            'hay un error al crear el viaje intentelo denuevo');
      }
      final data = json.decode(res.body);
      ResponseApi responseApi = await ResponseApi.fromJson(data);
      return responseApi;
    } catch (e) {
      // ignore: null_check_always_fails
      return null!;
    }
  }

  Future<ResponseApi> updateTripToEnCamino(Trip trip) async {
    try {
      var url = Uri.parse('${Environment.apiUrl}/$_api/updateTripToDispatched');
      String bodyParams = json.encode(trip);
      print(bodyParams);
      final driverUid = await _storage.read(key: 'driveruid');
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'uid': '$driverUid'
      };

      final res = await http.put(url, headers: headers, body: bodyParams);
      if (res.statusCode == 401) {
        mostrarAlerta(context!, 'error al aactualizar el Viaje',
            'hay un error al actualizar el viaje intentelo denuevo');
      }
      final data = json.decode(res.body);
      ResponseApi responseApi = await ResponseApi.fromJson(data);
      return responseApi;
    } catch (e) {
      return null!;
    }
  }

  Future<ResponseApi> updateTripToFinish(Trip trip) async {
    try {
      var url = Uri.parse('${Environment.apiUrl}/$_api/updateTripToFinish');
      String bodyParams = json.encode(trip);
      final driverUid = await _storage.read(key: 'driveruid');
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'uid': '$driverUid'
      };

      final res = await http.put(url, headers: headers, body: bodyParams);
      if (res.statusCode == 401) {
        mostrarAlerta(context!, 'error al aactualizar el Viaje',
            'hay un error al actualizar el viaje intentelo denuevo');
      }
      final data = json.decode(res.body);
      ResponseApi responseApi = await ResponseApi.fromJson(data);
      return responseApi;
    } catch (e) {
      return null!;
    }
  }

  Future<ResponseApi> updateLatLng(Trip trip) async {
    try {
      var url = Uri.parse('${Environment.apiUrl}/$_api/updateLatLng');
      String bodyParams = json.encode(trip);
      final driverUid = await _storage.read(key: 'driveruid');
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'uid': '$driverUid'
      };

      final res = await http.put(url, headers: headers, body: bodyParams);
      if (res.statusCode == 401) {
        mostrarAlerta(context!, 'error al aactualizar el Viaje',
            'hay un error al actualizar el viaje intentelo denuevo');
      }
      final data = json.decode(res.body);
      ResponseApi responseApi = await ResponseApi.fromJson(data);
      return responseApi;
    } catch (e) {
      return null!;
    }
  }

  Future<ResponseApi> updateTripTo(Trip trip) async {
    try {
      var url = Uri.parse('${Environment.apiUrl}/$_api/updateTrip');
      String bodyParams = json.encode(trip);
      print(bodyParams);
      Map<String, String> headers = {'Content-type': 'application/json'};

      final res = await http.put(url, headers: headers, body: bodyParams);
      print(res.body);
      if (res.statusCode == 401) {
        mostrarAlerta(context!, 'error al actualizar el Viaje',
            'hay un error al actualizar el viaje intentelo denuevo');
      }
      final data = json.decode(res.body);
      ResponseApi responseApi = await ResponseApi.fromJson(data);
      return responseApi;
    } catch (e) {
      return null!;
    }
  }

  Future<ResponseApi> deleteTrip(uid) async {
    try {
      var url = Uri.parse('${Environment.apiUrl}/$_api/delete/$uid');

      Map<String, String> headers = {'Content-type': 'application/json'};

      final res = await http.delete(url, headers: headers);
      print(res.body);
      if (res.statusCode == 401) {
        mostrarAlerta(context!, 'error al eliminar el Viaje',
            'hay un error al actualizar el viaje intentelo denuevo');
      }
      final data = json.decode(res.body);
      ResponseApi responseApi = await ResponseApi.fromJson(data);
      return responseApi;
    } catch (e) {
      return null!;
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
