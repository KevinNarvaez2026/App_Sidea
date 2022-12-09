import 'package:get/get.dart';

class Robots_model {
  int id;
  String data;
  String username;
  String email;
  String comments;
  String current;

  Robots_model({
    this.data,
    this.username,
    this.email,
    this.comments,
    this.current
  });

  Robots_model.fromJson(Map<String, dynamic> json) {
    data = json['status'];
    //current = json['current'];
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
