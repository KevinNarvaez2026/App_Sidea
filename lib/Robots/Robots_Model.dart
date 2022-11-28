import 'package:get/get.dart';

class Robots_model {
  int id;
  String data;
  String username;
  String email;
  String comments;

  Robots_model({
    this.data,
    this.username,
    this.email,
    this.comments,
  });

  Robots_model.fromJson(Map<String, dynamic> json) {
    data = json['status'];

    username = json['name'];
    email = json['source'];
    comments = json['system'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['data'] = this.data;
    data['username'] = this.username;
    data['namefile'] = this.email;

    return data;
  }
}
