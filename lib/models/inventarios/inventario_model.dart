import 'dart:convert';

InventarioModel inventarioModelFromJson(String str) =>
    InventarioModel.fromJson(json.decode(str));

String inventarioModelToJson(InventarioModel data) =>
    json.encode(data.toJson());

class InventarioModel {
  InventarioModel({
    this.id,
    this.fecha,
    this.nombre,
    this.usuario,
  });

  String id;
  DateTime fecha;
  String nombre;
  String usuario;

  factory InventarioModel.fromJson(Map<String, dynamic> json) =>
      InventarioModel(
        id: json["_id"],
        fecha: DateTime.parse(json["fecha"]),
        nombre: json["nombre"],
        usuario: json["usuario"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "fecha": fecha.toIso8601String(),
        "nombre": nombre,
        "usuario": usuario,
      };
}
