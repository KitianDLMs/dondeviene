import 'dart:convert';

Trip tripFromJson(String str) => Trip.fromJson(json.decode(str));

String tripToJson(Trip data) => json.encode(data.toJson());

class Trip {
  String? uid;
  String? nombre;
  late String descripcion;
  String? comuna;
  double? lat;
  double? lng;
  bool? online;
  String? status;
  String? idDriver;
  List<Trip> toList = [];

  Trip(
      {this.uid,
      this.nombre,
      required this.descripcion,
      this.comuna,
      this.lat,
      this.lng,
      this.online,
      this.status,
      this.idDriver});

  factory Trip.fromJson(Map<String, dynamic> json) => Trip(
        uid: json["uid"] is int ? json["uid"].toString() : json["uid"],
        nombre: json["nombre"],
        descripcion: json["descripcion"],
        comuna: json["comuna"],
        lat: json["lat"] is String
            ? double.parse(json["lat"].toDouble())
            : json["lat"],
        lng: json["lng"] is String
            ? double.parse(json["lng"].toDouble())
            : json["lng"],
        online: json["online"],
        status: json["status"],
        idDriver: json["idDriver"],
      );

  Trip.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;
    jsonList.forEach((item) {
      Trip trip = Trip.fromJson(item);
      toList.add(trip);
    });
  }

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "nombre": nombre,
        "descripcion": descripcion,
        "comuna": comuna,
        "lat": lat,
        "lng": lng,
        "online": online,
        "idDriver": idDriver,
      };
}
