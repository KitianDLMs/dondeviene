import 'dart:convert';

Value valueFromJson(String str) => Value.fromJson(json.decode(str));

String valueToJson(Value data) => json.encode(data.toJson());

class Value {
  String? nombre;
  String? adulto;
  String? adultoMayor;
  String? estudianteUni;
  String? estudiante;
  String? local;
  String? intermedio;
  List<Value> toList = [];

  Value(
      {this.nombre,
      this.adulto,
      this.adultoMayor,
      this.estudiante,
      this.estudianteUni,
      this.local,
      this.intermedio});

  factory Value.fromJson(Map<String, dynamic> json) => Value(
        nombre: json["nombre"],
        adulto: json["adulto"],
        adultoMayor: json["adultoMayor"],
        estudianteUni: json["estudianteUni"],
        estudiante: json["estudiante"],
        local: json["local"],
        intermedio: json["intermedio"],
      );

  Value.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;
    jsonList.forEach((item) {
      Value value = Value.fromJson(item);
      toList.add(value);
    });
  }

  Map<String, dynamic> toJson() => {
        "nombre": nombre,
        "adulto": adulto,
        "adultoMayor": adultoMayor,
        "estudianteUni": estudianteUni,
        "estudiante": estudiante,
        "local": local,
        "intermedio": intermedio,
      };
}
