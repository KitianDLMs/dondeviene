// To parse this JSON data, do
//
//     final usuario = usuarioFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/material.dart';

Usuario usuarioFromJson(String str) => Usuario.fromJson(json.decode(str));

String usuarioToJson(Usuario data) => json.encode(data.toJson());

class Usuario {
  Usuario(
      {required this.nombre,
      required this.email,
      required this.online,
      required this.uid,
      this.trip,
      this.role});

  late String nombre;
  late String email;
  late bool online;
  late String uid;
  List<Usuario> toList = [];
  String? role;
  String? trip;

  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
        nombre: json["nombre"],
        email: json["email"],
        online: json["online"],
        uid: json["uid"],
        role: json["role"],
        trip: json["trip"],
      );

  Usuario.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;
    jsonList.forEach((item) {
      Usuario usuario = Usuario.fromJson(item);
      toList.add(usuario);
    });
  }

  Map<String, dynamic> toJson() => {
        "nombre": nombre,
        "email": email,
        "online": online,
        "uid": uid,
        "role": role,
        "trip": trip,
      };
}
