

import 'package:get/get.dart';

class Userlists {
  String id;
  String data;
  String username;

  String apellido2;

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
  DateTime horaTotal;

  Userlists({
    this.id,
    this.metadatatype,
    this.metadatacadena,
    this.username,
    this.descarga,
    this.apellido2,
    this.email,
    this.comments,
    this.metadataestado,
    this.phone,
    this.website,
    this.fecha,
    this.type,
    this.horaTotal,
  });

  Userlists.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    // data = json['metadata']["curp"];
    type = json['type'];
    metadatatype = json["search"];
    metadata = json["curp"];
    metadatacadena = json["cadena"];
    username = json['nombres'];

    apellido2 = json['apellidos'];

    email = json['namefile'];
    fecha = DateTime.parse(json["createdAt"]);
    DateTime fecha2 = DateTime.parse('0000-00-00 06:00:00Z');
    horaTotal =
        fecha.add(Duration(hours: fecha2.hour, minutes: fecha2.minute) * -1);
// print(horaTotal);
// print(horaTotal.hour);
// print(horaTotal.minute);

    metadataestado = json["estado"];
    website = json['url'];
    comments = json['comments'];
    descarga = json['downloaded'] as bool;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    //  data['metadata']["type"] = this.metadatatype;
    data['metadata']["curp"] = this.metadata;
    data['metadata']["state"] = this.metadataestado;
    data['metadata']["nombre"] = this.username;
    data['createdAt'] = this.fecha;

    return data;
  }
}
