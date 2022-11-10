import 'dart:ffi';

import 'package:get/get.dart';

class Userlists {
  int id;
  String data;
  String username;
  String apellido1;
  String apellido2;
  String susername;
  String sapellido1;
  String sapellido2;
  String email;
  Object type;
  bool descarga;
  Object metadatatype;
  Object metadata;
  Object metadatacadena;
  Object metadataestado;
  String phone;
  String website;
  DateTime fecha;
  String comments;

  Userlists({
    this.id,
    this.metadatatype,
    this.metadatacadena,
    this.username,
    this.descarga,
    this.apellido1,
    this.apellido2,
    this.susername,
    this.sapellido1,
    this.sapellido2,
    this.email,
     this.comments,
    this.metadataestado,
    this.phone,
    this.website,
    this.fecha,
    this.type,
   
  });

  Userlists.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    // data = json['metadata']["curp"];
    type = json['type'];
    metadatatype = json['metadata']["type"];
    metadata = json['metadata']["curp"];
    metadatacadena = json['metadata']["cadena"];
    username = json['metadata']['nombre'];
    apellido1 = json['metadata']['primerapellido'];
    apellido2 = json['metadata']['segundoapelido'];
    susername = json['metadata']['snombre'];
    sapellido1 = json['metadata']['sprimerapellido'];
    sapellido2 = json['metadata']['ssegundoapellido'];
    email = json['namefile'];
    fecha = DateTime.parse(json["createdAt"]);
 
    metadataestado = json['metadata']["state"];
    website = json['url'];
    comments = json['comments'];
    descarga = json['downloaded'] as bool;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['metadata']["type"] = this.metadatatype;
    data['metadata']["curp"] = this.metadata;
    data['metadata']["state"] = this.metadataestado;
    data['metadata']["nombre"] = this.username;
    data['createdAt'] = this.fecha;

    return data;
  }
}
