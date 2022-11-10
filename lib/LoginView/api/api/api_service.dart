import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../NavBar.dart';
import '../../../RFCDescargas/services/Variables.dart';
import '../model/login_model.dart';

class APIService {
  Future<LoginResponseModel> login(LoginRequestModel requestModel) async {
    String url = 'https://actasalinstante.com:3030/api/user/signin/';

    final response = await http.post(Uri.parse(url), body: requestModel.toJson());
    if (response.statusCode == 200 || response.statusCode == 400) {
       var data = jsonDecode(response.body.toString());
         getIt<AuthModel>().usuario = data['username'];
        getIt<AuthModel>().token = data['token'];
        
      return LoginResponseModel.fromJson(
        json.decode(response.body),
      );

    } else {
  
      
        final snackBar =
                                        SnackBar(content: Text("Error"));

                                    // ScaffoldMessenger.of(context)
                                    //     .showSnackBar(snackBar);
                                    // scaffoldKey.currentState
                                    //  .showSnackBar(snackBar);
     //throw Exception('Failed to load data!');
    
         
    }
  }



}
