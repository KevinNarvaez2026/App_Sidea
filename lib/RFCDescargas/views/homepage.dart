import 'dart:convert';
import 'dart:io';

import 'package:app_actasalinstante/NavBar.dart';
import 'package:app_actasalinstante/RFCDescargas/SearchapiRFC/search.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:app_actasalinstante/RFCDescargas/controllers/product_controller.dart';
import 'package:app_actasalinstante/RFCDescargas/views/product_tile.dart';
import 'package:http/http.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../Search/constants.dart';
import '../../Search/serach.dart';
import '../../models/product.dart';
import '../services/Variables.dart';

class RFCPAGE extends StatefulWidget {
  @override
  _RFCPAGEState createState() => _RFCPAGEState();
}

class _RFCPAGEState extends State<RFCPAGE> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  
  }

  @override
  void dispose() {
    // TODO: implement dispose
 
    super.dispose();
  }

  final ProductControllers productController = Get.put(ProductControllers());
  Widget buildColoredCard() => Card(
        shadowColor: Color.fromARGB(255, 27, 98, 156),
        elevation: 8,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 27, 98, 156),
                Color.fromARGB(255, 27, 98, 156)
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'RFC',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );

  GetDates() async {
    Map<String, String> mainheader = new Map();
    mainheader["content-type"] = "application/json";
    mainheader['x-access-token'] = getIt<AuthModel>().token;

    try {
      var response = await get(
        Uri.parse(
            'https://actasalinstante.com:3030/api/actas/requests/myDates/'),
        headers: mainheader,
      );

      if (response.statusCode == 200) {
        var jsonString = response.body;
        print(response);
        return productFromJson(jsonString);
      } else {
        //show error message
        return null;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  var _currentSelectedValue;
  var _currencies = [
    "Actual",
  ];
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
              "RFC de " + getIt<AuthModel>().usuario,
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
              //       fontSize: 20,
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

              //  const Padding(
              //   padding: EdgeInsets.symmetric(vertical: defaultPadding),
              //   child: SearchForm(),
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
