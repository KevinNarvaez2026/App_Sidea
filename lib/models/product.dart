// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);

import 'dart:convert';
import 'package:get/get.dart';

List<Product> productFromJson(String str) =>
    List<Product>.from(json.decode(str).map((x) => Product.fromJson(x)));

String productToJson(List<Product> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Product {
  Product({
    this.nm,
    this.id,
    this.metadata,
    this.metadatas,
    this.metadatacadena,
    this.metadataestado,
    this.metadatanombres,
    this.metadataapellido1,
    this.metadataapellido2,
    this.snombre,
    this.ssegundoapellido,
    this.sprimerapellido,
    this.type,
    this.url,
    this.fecha,
    this.corte,
    // this.createdAt,
    // this.updatedAt,
  });
  int nm;
  int id;
  Object metadata;
  Object metadatas;
  Object metadatacadena;
  Object metadataestado;
  Object metadatanombres;
  Object metadataapellido1;
  Object metadataapellido2;
  DateTime fecha;
  Object snombre;
  Object sprimerapellido;
  Object ssegundoapellido;
  String type;
  String url;
  String corte;
  // DateTime createdAt;
  // DateTime updatedAt;

  var isFavorite = false.obs;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        nm: json["nm"],
        id: json["id"],

        metadata: json["metadata"]["type"],
        metadatas: json["metadata"]["curp"],
        metadatacadena: json["metadata"]["cadena"],
        metadataestado: json["metadata"]["state"],
        metadatanombres: json["metadata"]["nombre"],
        metadataapellido1: json["metadata"]["primerapellido"],
        metadataapellido2: json["metadata"]["segundoapelido"],
        snombre: json["metadata"]["snombre"],
        sprimerapellido: json["metadata"]["sprimerapellido"],
        ssegundoapellido: json["metadata"]["ssegundoapellido"],
        type: json["type"],
        url: json["url"],
        corte: json["corte"],

        fecha: DateTime.parse(json["createdAt"]),

        // updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "nm": nm,
        "id": id,
        "metadata": metadata,
        "type": type,
        "url": url,

        "createdAt": fecha.toIso8601String(),
        // "updated_at": updatedAt.toIso8601String(),
      };
}

enum Brand { MAYBELLINE }

final brandValues = EnumValues({"maybelline": Brand.MAYBELLINE});

class ProductColor {
  ProductColor({
    this.hexValue,
    this.colourName,
  });

  String hexValue;
  String colourName;

  factory ProductColor.fromJson(Map<String, dynamic> json) => ProductColor(
        hexValue: json["hex_value"],
        colourName: json["colour_name"] == null ? null : json["colour_name"],
      );

  Map<String, dynamic> toJson() => {
        "hex_value": hexValue,
        "colour_name": colourName == null ? null : colourName,
      };
}

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
