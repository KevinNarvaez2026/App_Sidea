import 'dart:convert';

import 'package:app_actasalinstante/RFCDescargas/SearchapiRFC/user_model.dart';
import 'package:app_actasalinstante/RFCDescargas/services/Variables.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Robots_Model.dart';

class Robots_get {
  var data = [];
  String datesforuserrfc;
  List<Robots_model> results = [];
  List<Robots_model> resultsid = [];
  String Token = "";

  Future<List<Robots_model>> get_robots({String query}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Token = prefs.getString('token');
    Map<String, String> mainheader = new Map();
    mainheader["content-type"] = "application/json";
    mainheader['x-access-token'] = Token;
    Response response = await get(
      Uri.parse('https://actasalinstante.com:3030/api/robots/getAll/'),
      headers: mainheader,
    );

    try {
      if (response.statusCode == 200) {
        data = json.decode(response.body);

        for (var i = 0; i < data.length; i++) {
       //   print(data[i]['name']);

        
            results = data.map((e) => Robots_model.fromJson(e)).toList();
        
         
        }

        // if (query != null) {
        //   results = results
        //       .where((element) =>
        //           element.data.toLowerCase().contains((query.toLowerCase())))
        //       .toList();
        //   resultsid = results
        //       .where((element) => element.id
        //           .toString()
        //           .toLowerCase()
        //           .contains((query.toLowerCase())))
        //       .toList();
        // }
      } else {
        print("fetch error");
      }
    } on Exception catch (e) {
      print('error: $e');
    }
    return results;
  }

  // Future<List<Userlist2>> searchrfc({String query}) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();

  //   Token = prefs.getString('token');
  //   Map<String, String> mainheader = new Map();
  //   mainheader["content-type"] = "application/json";
  //   mainheader['x-access-token'] = Token;
  //   Response response = await get(
  //     Uri.parse(
  //         'https://actasalinstante.com:3030/api/rfc/request/getMyRequest/'),
  //     headers: mainheader,
  //   );
  //   try {
  //     if (response.statusCode == 200) {
  //       data = json.decode(response.body);
  //       // print(data);
  //       results = data.map((e) => Userlist2.fromJson(e)).toList();
  //       if (query != null) {
  //         results = results
  //             .where((element) =>
  //                 element.data.toLowerCase().contains((query.toLowerCase())))
  //             .toList();
  //         resultsid = results
  //             .where((element) => element.id
  //                 .toString()
  //                 .toLowerCase()
  //                 .contains((query.toLowerCase())))
  //             .toList();
  //       }
  //     } else {
  //       print("fetch error");
  //     }
  //   } on Exception catch (e) {
  //     print('error: $e');
  //   }
  //   return results + resultsid;
  // }
}
