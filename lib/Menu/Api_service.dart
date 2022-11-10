import 'dart:convert';

import 'package:app_actasalinstante/RFCDescargas/services/Variables.dart';
import 'package:app_actasalinstante/services/SearchapiACTAS/user_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../../views/controller/controller.dart';

class FetchUserLists {
  var data = [];
  List<Userlists> results = [];
  List<Userlists> results2 = [];
  List<Userlists> results3 = [];
  List<Userlists> resultsid = [];
  Userlists _user = Userlists();
  //String urlLists = 'https://actasalinstante.com:3030/api/rfc/request/getMyRequest/';
  final _controller = Get.find<Controller>();
  Future<List<Userlists>> getuserLists({String query}) async {
    Map<String, String> mainheader = new Map();
    mainheader["content-type"] = "application/json";
    mainheader['x-access-token'] = getIt<AuthModel>().token;
    var response = await get(
      Uri.parse(
          'https://actasalinstante.com:3030/api/actas/requests/obtainAll/'),
      headers: mainheader,
    );
    try {
      if (response.statusCode == 200) {
        //_controller.sendNotification();
        data = jsonDecode(response.body);
        

        results = data.map((e) => Userlists.fromJson(e)).toList();
        results2 = data.map((e) => Userlists.fromJson(e)).toList();
        results3 = data.map((e) => Userlists.fromJson(e)).toList();
        if (query != null) {
          results3 = results
              .where((element) => element.metadatacadena
                  .toString()
                  .toLowerCase()
                  .contains((query.toLowerCase())))
              .toList();
          results2 = results
              .where((element) => element.username
                  .toString()
                  .toLowerCase()
                  .contains((query.toLowerCase())))
              .toList();
          results = results
              .where((element) => element.metadata
                  .toString()
                  .toLowerCase()
                  .contains((query.toLowerCase())))
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
    // return results;
    return results2 + results + results3 + resultsid;
  }
}
