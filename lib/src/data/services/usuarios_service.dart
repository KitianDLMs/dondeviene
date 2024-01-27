import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dondeviene/src/data/models/usuarios_response.dart';
import 'package:dondeviene/src/data/services/services.dart';
import 'package:dondeviene/src/global/environment.dart';

class UsuariosService {
  BuildContext? context;
  Usuario? usuario;

  // Future init(BuildContext context, Usuario sesionUsuario) {
  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    await refresh();
    // this.usuario = sesionUsuario;
  }

  Future<List<Usuario>> getUsuarios() async {
    try {
      var url = Uri.parse('${Environment.apiUrl}/usuarios');

      final resp = await http.get(url, headers: {
        'Content-Type': 'application/json'
        // 'x-token': await AuthService.getToken()
      });

      final usuariosResponse = usuariosResponseFromJson(resp.body);
      return usuariosResponse.msg!;
    } catch (e) {
      return [];
    }
  }

  Future<List<Usuario>> getDrivers() async {
    try {
      var url = Uri.parse('${Environment.apiUrl}/usuarios/findByDriver');

      final resp = await http.get(url, headers: {
        'Content-Type': 'application/json'
        // 'x-token': await AuthService.getToken()
      });

      final data = json.decode(resp.body);
      Usuario usuario = Usuario.fromJsonList(data);

      return usuario.toList;
    } catch (e) {
      return [];
    }
  }
}
