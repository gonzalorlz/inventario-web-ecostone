// To parse this JSON data, do
//
//     final productoModel = productoModelFromJson(jsonString);

import 'dart:convert';

ProductoModel productoModelFromJson(String str) =>
    ProductoModel.fromJson(json.decode(str));

String productoModelToJson(ProductoModel data) => json.encode(data.toJson());

class ProductoModel {
  ProductoModel({
    this.codigoFsl,
    this.codigoEcostone,
    this.categoria,
    this.stock,
    this.modelo,
  });

  String codigoFsl;
  String codigoEcostone;
  String categoria;
  String stock;
  String modelo;

  factory ProductoModel.fromJson(Map<String, dynamic> json) => ProductoModel(
        codigoFsl: json["codigo_fsl"],
        codigoEcostone: json["codigo_ecostone"],
        categoria: json["categoria"],
        stock: json["stock"],
        modelo: json["modelo"],
      );

  Map<String, dynamic> toJson() => {
        "codigo_fsl": codigoFsl,
        "codigo_ecostone": codigoEcostone,
        "categoria": categoria,
        "stock": stock,
        "modelo": modelo,
      };
}
