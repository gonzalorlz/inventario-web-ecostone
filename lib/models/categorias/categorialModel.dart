// To parse this JSON data, do
//
//     final categoriaModel = categoriaModelFromJson(jsonString);

import 'dart:convert';

CategoriaModel categoriaModelFromJson(String str) => CategoriaModel.fromJson(json.decode(str));

String categoriaModelToJson(CategoriaModel data) => json.encode(data.toJson());

class CategoriaModel {
    CategoriaModel({
         this.id,
         this.nombre,
         this.fecha,
         this.arrayDetalle,
    });

    String id;
    String nombre;
    DateTime fecha;
    List<dynamic> arrayDetalle;

    factory CategoriaModel.fromJson(Map<String, dynamic> json) => CategoriaModel(
        id: json["_id"],
        nombre: json["nombre"],
        fecha: DateTime.parse(json["fecha"]),
        arrayDetalle: List<dynamic>.from(json["arrayDetalle"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "nombre": nombre,
        "fecha": fecha.toIso8601String(),
        "arrayDetalle": List<dynamic>.from(arrayDetalle.map((x) => x)),
    };
}
