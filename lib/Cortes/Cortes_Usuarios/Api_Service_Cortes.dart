import 'dart:convert';

import 'package:app_actasalinstante/RFCDescargas/services/Variables.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Cortes_Model.dart';

class FetchUserListCortes {
  var data = [];
  String datesforuserrfc;
  List<Cortes_model> results = [];
  List<Cortes_model> resultsid = [];
  String Token = "";

  Future<List<Cortes_model>> Get_Cortes({String query}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Token = prefs.getString('token');
    Map<String, String> mainheader = new Map();
    mainheader["content-type"] = "application/json";
    mainheader['x-access-token'] = Token;
    Response response = await get(
      Uri.parse(
          'https://actasalinstante.com:3030/api/actas/reg/myCorte/' +
              datesforuserrfc.toString()),
      headers: mainheader,
    );
    try {
      if (response.statusCode == 200) {
        data = json.decode(response.body);
         print(data);
        results = data.map((e) => Cortes_model.fromJson(e)).toList();
        if (query != null) {
          results = results
              .where((element) =>
                  element.data.toLowerCase().contains((query.toLowerCase())))
              .toList();
          resultsid = results
              .where((element) => element.id
                  .toString()
                  .toLowerCase()
                  .contains((query.toLowerCase())))
              .toList();
        }
      } else {
        print("fetch error");
      }
    } on Exception catch (e) {
      print('error: $e');
    }
    return results + resultsid;
  }

  Future<List<Cortes_model>> searchrfc({String query}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Token = prefs.getString('token');
    Map<String, String> mainheader = new Map();
    mainheader["content-type"] = "application/json";
    mainheader['x-access-token'] = Token;
    Response response = await get(
      Uri.parse(
          'https://actasalinstante.com:3030/api/rfc/request/getMyRequest/'),
      headers: mainheader,
    );
    try {
      if (response.statusCode == 200) {
        data = json.decode(response.body);
        // print(data);
        results = data.map((e) => Cortes_model.fromJson(e)).toList();
        if (query != null) {
          results = results
              .where((element) =>
                  element.data.toLowerCase().contains((query.toLowerCase())))
              .toList();
          resultsid = results
              .where((element) => element.id
                  .toString()
                  .toLowerCase()
                  .contains((query.toLowerCase())))
              .toList();
        }
      } else {
        print("fetch error");
      }
    } on Exception catch (e) {
      print('error: $e');
    }
    return results + resultsid;
  }
}
