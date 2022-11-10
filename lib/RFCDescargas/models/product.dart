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
    this.id,
    this.metadata,
     
    this.type,
    this.url,
    // this.fecha,
    // this.updatedAt,

  });

  int id;
  String metadata;

  String type;
  String url;
   //DateTime fecha;
  // DateTime updatedAt;


  var isFavorite = false.obs;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],     
        metadata: json["data"],
     
   
        type: json["search"],
         url: json["namefile"],
     
        //fecha: DateTime.parse(json["createdAt"]),
        // updatedAt: DateTime.parse(json["updated_at"]),
      
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "metadata": metadata,
        "type": type,
        "url": url,

       //  "createdAt": fecha.toIso8601String(),
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
