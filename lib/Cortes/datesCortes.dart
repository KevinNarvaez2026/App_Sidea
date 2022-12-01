
import 'dart:io';

import 'package:app_actasalinstante/Cortes/cortes.dart';
import 'package:app_actasalinstante/RFCDescargas/services/Variables.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import "package:flutter/material.dart";
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DateCortes extends StatefulWidget {
  @override
  _DateCortesState createState() => _DateCortesState();
}

class _DateCortesState extends State<DateCortes> with TickerProviderStateMixin {
  String user = "";
  GetNames() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      user = prefs.getString('username');
    });
    print(user);
  }

  List data;
  List<Provinces> listProvinces;
  List<Cibers> daa;

  var _selectedProvince;
  AnimationController _animationController;

  // Future<List<Provinces>> getProvinceList() async {
  //   Map<String, String> mainheader = new Map();
  //   mainheader["content-type"] = "application/json";
  //   mainheader['x-access-token'] = getIt<AuthModel>().token;

  //   var response = await get(
  //     Uri.parse('https://actasalinstante.com:3030/api/actas/reg/Corte/Dates/'),
  //     headers: mainheader,
  //   );

  //   listProvinces = parseProvinces(response.body);
  //   print(response.body);
  //   return parseProvinces(response.body);
  // }

  List<Provinces> parseProvinces(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

    return parsed.map<Provinces>((json) => Provinces.fromJson(json)).toList();
  }

  @override
  void initState() {
    super.initState();
    // this.getProvinceList();
    GetNames();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
  }

  listadecibers() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.SUCCES,
      animType: AnimType.BOTTOMSLIDE,
      title: 'Selecciona un Ciber',
      desc: ' ' + ciber.toString(),
      btnCancelOnPress: () {
        //  Navigator.of(context).pop(true);
      },
      btnOkOnPress: () {},
    )..show();
  }

  var label = "Fechas";
  var ciber;
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          'Corte del usuario: ' + user.toString(),
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.grey,
      ),
      body: _provinceContainer(),
    );
  }

  Widget _provinceContainer() {
    return WillPopScope(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.all(29),

                  // padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    children: [
                      // Container(
                      //   height: 190.0,
                      //   child: Lottie.network(
                      //     'https://assets1.lottiefiles.com/packages/lf20_gc3pn97g.json',
                      //     controller: _animationController,
                      //     height: 280,
                      //     repeat: false,
                      //   ),
                      // ),
                      Container(
                        height: 500,
                        width: 500,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          image: DecorationImage(
                            image: AssetImage('assets/close.gif'),
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(29)),
                        ),
                      ),
                      // FormField<String>(
                      //   builder: (FormFieldState<String> state) {
                      //     return InputDecorator(
                      //       decoration: InputDecoration(
                      //           label: Text(label.toString()),
                      //           errorStyle: TextStyle(
                      //               color: Colors.redAccent, fontSize: 16.0),
                      //           border: OutlineInputBorder(
                      //               borderRadius: BorderRadius.circular(39.0))),
                      //       isEmpty: _selectedProvince == null,
                      //       child: new DropdownButtonHideUnderline(
                      //         child: new DropdownButton<Provinces>(
                      //           value: _selectedProvince,
                      //           isDense: true,
                      //           onChanged: (Provinces newValue) {
                      //             setState(() {
                      //               _selectedProvince = newValue;
                      //               print(newValue.toString());
                      //             });
                      //           },
                      //           items: listProvinces?.map((Provinces value) {
                      //                 return new DropdownMenuItem<Provinces>(
                      //                   value: value,
                      //                   child: new Text(
                      //                     value.name.toString(),
                      //                     style: new TextStyle(fontSize: 20.0),
                      //                   ),
                      //                 );
                      //               })?.toList() ??
                      //               [],
                      //         ),
                      //       ),
                      //     );
                      //   },
                      // ),
                      SizedBox(height: 8),
                      // new Center(
                      //   child: Container(
                      //     decoration: BoxDecoration(
                      //       color: Colors.grey,
                      //       borderRadius: BorderRadius.circular(82),
                      //     ),
                      //     padding: const EdgeInsets.symmetric(
                      //         horizontal: 4, vertical: 2),
                      //     child: Row(
                      //       mainAxisSize: MainAxisSize.min,
                      //       children: [
                      //         MaterialButton(
                      //           onPressed: () {
                      //             Provinces value = _selectedProvince;
                      //             getclients();
                      //             // listadecibers();
                      //             // Navigator.push(
                      //             //           context, MaterialPageRoute(builder: (context) => cortes(value.name.toString())));
                      //             print(value.name.toString());
                      //           },
                      //           child: Text("Enviar fecha"),
                      //           textColor: Colors.white,
                      //         ),
                      //         Icon(
                      //           Icons.send,
                      //           size: 20,
                      //           color: Colors.white,
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      SizedBox(height: 18),
                      // Card(
                      //   elevation: 10,
                      //   // color: Color.fromARGB(255, 232, 234, 246),
                      //   shape: RoundedRectangleBorder(
                      //     borderRadius: BorderRadius.circular(64),
                      //   ),
                      //   child: Padding(
                      //     padding: const EdgeInsets.all(55.0),
                      //     child: Column(
                      //         crossAxisAlignment: CrossAxisAlignment.start,
                      //         mainAxisAlignment: MainAxisAlignment.start,
                      //         children: [
                      //           new Center(
                      //             child: Text(
                      //               "Ciber",
                      //               maxLines: 5,
                      //               style: TextStyle(
                      //                   fontSize: 22,
                      //                   fontFamily: 'avenir',
                      //                   fontWeight: FontWeight.w800,
                      //                   color: Colors.black),
                      //               overflow: TextOverflow.ellipsis,
                      //             ),
                      //           ),
                      //           if (ciber != null)
                      //             new Center(
                      //               child: Text(
                      //                 "" + ciber.toString(),
                      //                 maxLines: 9,
                      //                 style: TextStyle(
                      //                     fontSize: 20,
                      //                     fontFamily: 'avenir',
                      //                     fontWeight: FontWeight.w800,
                      //                     color: Colors.black),
                      //                 overflow: TextOverflow.ellipsis,
                      //               ),
                      //             ),
                      //           if (ciber == null)
                      //             new Center(
                      //               child: Text(
                      //                 "Corte Actual",
                      //                 maxLines: 5,
                      //                 style: TextStyle(
                      //                     fontSize: 22,
                      //                     fontFamily: 'avenir',
                      //                     fontWeight: FontWeight.w800,
                      //                     color: Colors.black),
                      //                 overflow: TextOverflow.ellipsis,
                      //               ),
                      //             ),
                      //         ]),
                      //   ),

                      //   // child: Text(
                      //   //   "Cibers " + getclients().toString(),
                      //   //   maxLines: 2,
                      //   //   style: TextStyle(
                      //   //       fontSize: 16,
                      //   //       fontFamily: 'avenir',
                      //   //       fontWeight: FontWeight.w800,
                      //   //       color: Colors.black),
                      //   //   overflow: TextOverflow.ellipsis,
                      //   // ),
                      // ),
                    ],
                  ),
                ),
              ]),
        ),
        onWillPop: _onWillPopScope);
  }

  Future<bool> _onWillPopScope() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.WARNING,
      animType: AnimType.BOTTOMSLIDE,
      title: 'Actas al instante',
      desc: user.toString() + ' ¿quieres salir de la aplicación?',
      btnCancelOnPress: () {
        //  Navigator.of(context).pop(true);
      },
      btnOkOnPress: () {
        exit(0);
      },
    )..show();
  }

  getclients() async {
    Map<String, String> mainheader = new Map();
    mainheader["content-type"] = "application/json";
    mainheader['x-access-token'] = getIt<AuthModel>().token;
    Provinces value = _selectedProvince;
    var response = await get(
      Uri.parse(
          'https://actasalinstante.com:3030/api/actas/reg/Corte/Clients/' +
              value.name.toString()),
      headers: mainheader,
    );
    ciber = jsonDecode(response.body);
    print(ciber);
  }

  List<Cibers> parsecibers(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

    return parsed.map<Cibers>((json) => Cibers.fromJson(json)).toList();
  }
}

class Provinces {
  int id;
  String name;

  Provinces({this.id, this.name});

  factory Provinces.fromJson(Map<String, dynamic> json) {
    return Provinces(
      id: json['id'] as int,
      name: json['corte'] as String,
    );
  }
}

class Cibers {
  int id;
  String name;

  Cibers({this.id, this.name});

  factory Cibers.fromJson(Map<String, dynamic> json) {
    return Cibers(
      id: json['id'] as int,
      name: json['nombre'] as String,
    );
  }
}
