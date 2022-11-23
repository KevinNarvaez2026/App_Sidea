import 'package:get/get.dart';

class Userlist2 {
  int id;
  String data;
  String username;
  String email;
  String comments;
  bool descarga;
  String phone;
  String website;
DateTime fecha;
  DateTime horaTotal;
  var isFavorite = false.obs;
  Userlist2({
    this.id,
    this.data,
    this.username,
    this.email,
    this.comments,
    this.descarga,
    this.phone,
    this.fecha,
        this.horaTotal,
  });

  Userlist2.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    data = json['data'];
    username = json['username'];
    email = json['namefile'];
    comments = json['comments'];
    descarga = json['downloaded'] as bool;
    phone = json['search'];
    website = json['website'];
    fecha = DateTime.parse(json["createdAt"]);
     DateTime fecha2 = DateTime.parse('0000-00-00 06:00:00Z');
    horaTotal =
        fecha.add(Duration(hours: fecha2.hour, minutes: fecha2.minute) * -1);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['data'] = this.data;
    data['username'] = this.username;
    data['namefile'] = this.email;

    data['phone'] = this.phone;
    data['website'] = this.website;
 data['createdAt'] = this.fecha;
    return data;
  }
}
