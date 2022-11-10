import 'dart:convert';
import 'package:app_actasalinstante/RFCDescargas/services/Variables.dart';
import 'package:app_actasalinstante/login.dart';
import 'package:http/http.dart' as http;
import 'package:app_actasalinstante/RFCDescargas/models/product.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:app_actasalinstante/login.dart';
import 'package:http/http.dart';

class RemoteServices2 {
  static var client = http.Client();
  

  static Future<List<Product>> fetchProductsrfc() async {
    Map<String, String> mainheader = new Map();
    mainheader["content-type"] = "application/json";
    mainheader['x-access-token'] =   getIt<AuthModel>().token;
      print(  getIt<AuthModel>().token);
    try {
      
 Response response = await get(
        Uri.parse(
            'https://actasalinstante.com:3030/api/rfc/request/getMyRequest/'),
        headers: mainheader,
      );
         List<dynamic> data = jsonDecode(response.body);

       for (var i = 0; i < data.length; i++) {
         data[i].toString();
         print(data[i].toString());
       }
    if (response.statusCode == 200) {
      List<Product> productFromJson(String str) =>
List<Product>.from(
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
    
   
//   }
//  var data = [];
//   List<Product> results = [];
//   String urlList = 'https://actasalinstante.com:3030/api/rfc/request/getMyRequest/';

//   static Future<List<Product>> fetchProductsrfc() async {
//     String query;
//       Map<String, String> mainheader = new Map();
//     mainheader["content-type"] = "application/json";
//     mainheader['x-access-token'] = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6IlBydWViYXMiLCJyb2wiOiJTdXBlcnZpc29yIiwiaWQiOjk4MywiaWF0IjoxNjU3MDIzMDE5LCJleHAiOjE2NTcxMDk0MTl9.h5KJuDjQJiUZp-PVyQBoTDRaGumaDRxRx2kFxnwJoDk';
//    Response response = await get(
//         Uri.parse(
//             'https://actasalinstante.com:3030/api/rfc/request/getMyRequest/'),
//         headers: mainheader,
//       );
//     try {
    
//       if (response.statusCode == 200) {
//         print(response);
//         data = json.decode(response.body);
//         results = data.map((e) => Product.fromJson(e)).toList();
//         if (query!= null){
//           results = results.where((element) => element.metadata.toLowerCase().contains((query.toLowerCase()))).toList();
//         }
//       } else {
//         print("fetch error");
//       }
//     } on Exception catch (e) {
//       print('error: $e');
//     }
//     return results;
//   }

  }
}
