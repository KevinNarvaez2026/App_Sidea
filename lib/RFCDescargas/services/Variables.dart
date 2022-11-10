import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

class AuthModel {
  
  int id;
  String usuario ;
   String token;
   
   AuthModel({this.id,this.usuario,this.token});
   
}

void setup() {
  
  getIt.registerSingleton<AuthModel>(AuthModel());
 // print(getIt);
}