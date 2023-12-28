// To parse this JSON data, do
//
//     final viaje = viajeFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Viaje {
  Viaje(
      {required this.available,
      required this.name,
      this.picture,
      required this.salida,
      this.id,
      this.latLng});

  bool available;
  String name;
  String? picture;
  String salida;
  String? id;
  LatLng? latLng;

  // factory Viaje.fromRawJson(String str) => Viaje.fromJson(json.decode(str));

  // String toRawJson() => json.encode(toJson());

  factory Viaje.fromJson(String str) => Viaje.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Viaje.fromMap(Map<String, dynamic> json) => Viaje(
      available: json["available"],
      name: json["name"],
      picture: json["picture"],
      salida: json["salida"],
      latLng: json["latLng"]);

  Map<String, dynamic> toMap() => {
        "available": available,
        "name": name,
        "picture": picture,
        "salida": salida,
        "latLng": latLng,
      };

  Viaje copy() => Viaje(
      available: this.available,
      name: this.name,
      picture: this.picture,
      salida: this.salida,
      id: this.id,
      latLng: this.latLng);
}
