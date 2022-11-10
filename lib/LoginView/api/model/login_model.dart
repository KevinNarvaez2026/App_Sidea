import '../../../RFCDescargas/services/Variables.dart';

class LoginResponseModel {
  final String token;
  final String error;

  LoginResponseModel({this.token, this.error});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      token: json["token"] != null ? json["token"] : "",
      error: json["error"] != null ? json["error"] : "",
    );
  }
}

class LoginRequestModel {
  String email;
  String password;

  LoginRequestModel({
    this.email,
    this.password,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'username': email.trim(),
      'password': password.trim(),


    };
    
 getIt<AuthModel>().usuario = map['username'];
 getIt<AuthModel>().token = map['token'];
 
    return map;
  }
}
