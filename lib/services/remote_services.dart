import 'dart:convert';

import 'package:app_actasalinstante/login.dart';
import 'package:http/http.dart' as http;
import 'package:app_actasalinstante/models/product.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:app_actasalinstante/login.dart';
import 'package:http/http.dart';

import '../RFCDescargas/services/Variables.dart';

class RemoteServices {
  static var client = http.Client();

  final Product product;
  const RemoteServices(this.product);

  static Future<List<Product>> fetchProducts() async {
    Map<String, String> mainheader = new Map();
    mainheader["content-type"] = "application/json";
    mainheader['x-access-token'] = getIt<AuthModel>().token;
    // print( Variables().Token);

    try {
      Response response = await get(
        Uri.parse(
            'https://actasalinstante.com:3030/api/actas/requests/obtainAll/'),
        headers: mainheader,
      );
      List<dynamic> data = jsonDecode(response.body);

      for (var i = 0; i < data.length; i++) {
        data[i].toString();
        print(data[i].toString());
      }
      if (response.statusCode == 200) {
        List<Product> productFromJson(String str) => List<Product>.from(
            json.decode(response.body).map((x) => Product.fromJson(x)));
        var jsonString = response.body;
        return productFromJson(jsonString);
      } else {
        //show error message
        return null;
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
