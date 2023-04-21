// To parse this JSON data, do
//
//     final crearInventarioModel = crearInventarioModelFromJson(jsonString);

import 'dart:convert';

CrearInventarioModel crearInventarioModelFromJson(String str) =>
    CrearInventarioModel.fromJson(json.decode(str));

String crearInventarioModelToJson(CrearInventarioModel data) =>
    json.encode(data.toJson());

class CrearInventarioModel {
  CrearInventarioModel({
    this.nombre,
  });

  String nombre;

  factory CrearInventarioModel.fromJson(Map<String, dynamic> json) =>
      CrearInventarioModel(
        nombre: json["nombre"],
      );

  Map<String, dynamic> toJson() => {
        "nombre": nombre,
      };
}
