import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'package:dondeviene/src/global/environment.dart';
import 'package:dondeviene/src/data/models/models.dart';

class ValueService {
  String _api = 'values';
  BuildContext? context;
  Usuario? usuario;
  final _storage = new FlutterSecureStorage();

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    await refresh();
  }

  Future<List<Value>> getAll() async {
    try {
      var url = Uri.parse('${Environment.apiUrl}/$_api');

      Map<String, String> headers = {'Content-type': 'application/json'};

      final res = await http.get(url, headers: headers);

      final data = json.decode(res.body); // Trips
      Value value = Value.fromJsonList(data);
      print('VALUES -> ${value.toList}');
      return value.toList;
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
        // mostrarAlerta(context!, 'error al crear Viaje',
        //     'hay un error al crear el viaje intentelo denuevo');
      }
      final data = json.decode(res.body);
      ResponseApi responseApi = await ResponseApi.fromJson(data);
      return responseApi;
    } catch (e) {
      // ignore: null_check_always_fails
      return null!;
    }
  }

  Future<ResponseApi> updateTripById(Trip trip) async {
    try {
      var url = Uri.parse('${Environment.apiUrl}/$_api/:id');
      String bodyParams = json.encode(trip);
      final driverUid = await _storage.read(key: 'driveruid');
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'uid': '$driverUid'
      };

      final res = await http.put(url, headers: headers, body: bodyParams);
      if (res.statusCode == 401) {
        // mostrarAlerta(context!, 'error al aactualizar el Viaje',
        //     'hay un error al actualizar el viaje intentelo denuevo');
      }
      final data = json.decode(res.body);
      ResponseApi responseApi = await ResponseApi.fromJson(data);
      return responseApi;
    } catch (e) {
      return null!;
    }
  }
}

// mostrarAlerta(BuildContext context, String titulo, String subtitulo) {
//   if (Platform.isAndroid) {
//     return showDialog(
//         context: context,
//         builder: (_) => AlertDialog(
//               title: Text(titulo),
//               content: Text(subtitulo),
//               actions: [
//                 MaterialButton(
//                     child: Text('Ok'),
//                     elevation: 5,
//                     textColor: Colors.blue,
//                     onPressed: () => Navigator.pop(context))
//               ],
//             ));
//   }

//   showCupertinoDialog(
//       context: context,
//       builder: (_) => CupertinoAlertDialog(
//             title: Text(titulo),
//             content: Text(subtitulo),
//             actions: [
//               CupertinoDialogAction(
//                 isDefaultAction: true,
//                 child: Text('Ok'),
//                 onPressed: () => Navigator.pop(context),
//               )
//             ],
//           ));
// }
