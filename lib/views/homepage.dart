import 'dart:convert';
import 'dart:io';

import 'package:app_actasalinstante/NavBar.dart';
import 'package:app_actasalinstante/models/product.dart';
import 'package:app_actasalinstante/services/SearchapiACTAS/search.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:app_actasalinstante/controllers/product_controller.dart';
import 'package:app_actasalinstante/views/product_tile.dart';
import 'package:http/http.dart';
import 'package:table_calendar/table_calendar.dart';

import '../ColorScheme.dart';
import '../RFCDescargas/services/Variables.dart';
import '../Search/constants.dart';
import '../Search/serach.dart';
import '../services/remote_services.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ProductController productController = Get.put(ProductController());

  Future refresh() async {
    Map<String, String> mainheader = new Map();
    mainheader["content-type"] = "application/json";
    mainheader['x-access-token'] = getIt<AuthModel>().token;
    // print( Variables().Token);

    try {
      var response = await get(
        Uri.parse(
            'https://actasalinstante.com:3030/api/actas/requests/obtainAll/'),
        headers: mainheader,
      );
      List<dynamic> data = jsonDecode(response.body);

      setState(() {
        data.clear();
      });
      if (response.statusCode == 200) {
        setState(() {
          List<Product> productFromJson(String str) => List<Product>.from(
              json.decode(response.body).map((x) => Product.fromJson(x)));
          var jsonString = response.body;
          return productFromJson(jsonString);
        });
      } else {
        //show error message
        return null;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Product _product = new Product();
  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    _product = Product();
   
  }

  @override
  void dispose() {
    // TODO: implement dispose
   

    super.dispose();
  }

  String estado = "Corte";

  var _estadoselect;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          backgroundColor: Colors.redAccent,
          appBar: AppBar(
            actions: [
              IconButton(
                onPressed: () {
                  showSearch(context: context, delegate: SearchUser());
                },
                icon: Icon(Icons.search_sharp),
              )
            ],
            automaticallyImplyLeading: false,
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: Text(
              "Actas de " + getIt<AuthModel>().usuario,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // appBar: AppBar(

          //   title: Text('😀 Bienvenido(a), '+ getIt<AuthModel>().usuario , style: TextStyle(
          //     color: Colors.white,
          //     fontWeight: FontWeight.w700
          //   ),

          //   ),
          //   elevation: 0,
          //   backgroundColor: Colors.indigo,
          // ),

          //  appBar: AppBar(
          //     elevation: 0,
          //     brightness: Brightness.light,
          //     backgroundColor: Colors.white,
          //     leading: IconButton(
          //       onPressed: () {

          //  Navigator.pop(context);
          //       },
          //       icon: Icon(
          //         Icons.arrow_back_ios,
          //         size: 20,
          //         color: Colors.black,
          //       ),
          //     ),
          //   ),

          body: Column(
            children: [
              // FormField<String>(
              //   builder: (FormFieldState<String> state) {
              //     return InputDecorator(
              //       decoration: InputDecoration(
              //           label: Text(estado.toString()),
              //           errorStyle:
              //               TextStyle(color: Colors.redAccent, fontSize: 16.0),
              //           hintText: 'Please select expense',
              //           border: OutlineInputBorder(
              //               borderRadius: BorderRadius.circular(5.0))),
              //       isEmpty: _estadoselect == '',
              //       child: DropdownButtonHideUnderline(
              //         child: DropdownButton<String>(
              //           value: _estadoselect,
              //           isDense: true,
              //           onChanged: (String newValue) {
              //             setState(() {
              //               _estadoselect = newValue;
              //               state.didChange(newValue);
              //             });
              //           },
              //           items: estados.map((String value) {
              //             return DropdownMenuItem<String>(
              //               value: value,
              //               child: Text(value),
              //             );
              //           }).toList(),
              //         ),
              //       ),
              //     );
              //   },
              // ),
              // TableCalendar(

              //   calendarController: _calendarController,
              //   initialCalendarFormat: CalendarFormat.week,
              //   startingDayOfWeek: StartingDayOfWeek.monday,
              //   formatAnimation: FormatAnimation.slide,

              //   headerStyle: HeaderStyle(
              //     centerHeaderTitle: true,
              //     formatButtonVisible: false,

              //     titleTextStyle: TextStyle(
              //       color: Colors.black,
              //       fontSize: 25,
              //       fontWeight: FontWeight. bold,
              //     ),
              //     leftChevronIcon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 20,),
              //     rightChevronIcon: Icon(Icons.arrow_forward_ios, color: Colors.black, size: 20,),
              //     leftChevronMargin: EdgeInsets.only(left: 20),
              //     rightChevronMargin: EdgeInsets.only(right: 20),
              //   ),
              //   calendarStyle: CalendarStyle(
              //     weekendStyle: TextStyle(
              //       color: Colors.black,
              //       fontWeight: FontWeight. bold,
              //     ),
              //     weekdayStyle: TextStyle(
              //       color: Colors.black,
              //        fontWeight: FontWeight. bold,
              //     )
              //   ),
              //   daysOfWeekStyle: DaysOfWeekStyle(
              //     weekendStyle: TextStyle(
              //       color: Colors.black,
              //        fontWeight: FontWeight. bold,
              //     ),
              //     weekdayStyle: TextStyle(
              //       color: Colors.black,
              //        fontWeight: FontWeight. bold,
              //     )
              //   ),
              // ),
              // SizedBox(height: 1,),
// IconButton(
// 	onPressed: ()  {
//       refresh();

//     },
//     icon: const Icon(Icons.refresh),
// ),

//  Container(
//                 decoration: BoxDecoration(
//                   color: Colors.blue,
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,

//                   children: [
//                       MaterialButton(
//                       onPressed: () {

//                       },
//                       child: Text("Descargar"),
//                       textColor: Colors.white,
//                     ),

//                     Icon(
//                       Icons.download,
//                       size: 15,
//                       color: Colors.white,
//                     ),

//                   ],

//                 ),
//               ),

             
            ],
          ),
        ),
        onWillPop: _onWillPopScope);
  }

  Future<bool> _onWillPopScope() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.WARNING,
      animType: AnimType.BOTTOMSLIDE,
      title: 'Actas al instante',
      desc: getIt<AuthModel>().usuario + ' ¿quieres salir de la aplicación?',
      btnCancelOnPress: () {
        //  Navigator.of(context).pop(true);
      },
      btnOkOnPress: () {
        exit(0);
      },
    )..show();
  }
}
