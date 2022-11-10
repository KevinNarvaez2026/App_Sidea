import 'dart:math';

import 'package:app_actasalinstante/Inicio/ColorFilters.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:app_actasalinstante/Widgets/carousel_example.dart';
import 'package:http/http.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class MyApp extends StatelessWidget {
  static final String title = 'Card Example';

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: title,
        theme: ThemeData(primarySwatch: Colors.deepOrange),
      );
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  void showmodaldescargado(){
    var snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Acta descargada! ',
          message: 'Enjoy!',
          contentType: ContentType.success,
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);

  }
    void showmodalactare(){
    var snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Acta Reasignada! ',
          message: 'Enjoy!',
          contentType: ContentType.success,
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);

  }
  //METODO API GET REST
  void actas2() async {
    var requests = [];
    Map<String, String> mainheader = new Map();
    mainheader["content-type"] = "application/json";
    mainheader['x-access-token'] =
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6IlBydWViYXMiLCJyb2wiOiJTdXBlcnZpc29yIiwiaWQiOjk4MywiaWF0IjoxNjU2NTM1ODQ5LCJleHAiOjE2NTY2MjIyNDl9.T_Few8MObxi3T1wpJX1VJC57krdWnY_RM9VqqXAXrUU';

    try {
      Response response = await get(
        Uri.parse(
            'https://actasalinstante.com:3030/api/actas/requests/obtainAll/'),
        headers: mainheader,
      );
      List<dynamic> data = jsonDecode(response.body);

      for (var i =1; i < data.length; i++) {
        var metadata = "";
        data[i].toString();
        return showDialog(
          
          context: context,
          
          builder: (ctx) => AlertDialog(
            
            title: Text("Actas""\n"
             +"Tipo de busqueda: "+ data[i][metadata = 'type'].toString()+"\n""\n"
            +  "Tipo: " + data[i][metadata = 'metadata']['type'].toString()+"\n"
             
              + "Creado: " + data[i][metadata = 'createdAt'].toString()+"\n"
              + "Estado: " + data[i][metadata = 'metadata']['state'].toString()+"\n"
                 + "" + data[i][metadata = 'url'].toString()+"\n"
                ),
            content: Text(""),
            actions: <Widget>[
              MaterialButton(
                    minWidth: double.infinity,
                    height: 60,
                    onPressed: (){
                   
                      showmodaldescargado();
                       Navigator.pushReplacement(
                       context,
                       MaterialPageRoute(
                       builder: (BuildContext context) => super.widget));
                    },
                    color: Color.fromARGB(255, 11, 156, 59),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)
                    ),
                    child: Text(
                      "⬇️ Descargar",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 18
                      ),
                    ),
                  ),
                  
                  Visibility(
                    
              child: Image.asset(
                'assets/NAC.png',
                height: 200.0,
                width: 1300.0,
               // fit: BoxFit.cover,
                alignment: Alignment.center,
                
              ),
            )
            ],
          ),
        );
      }

      //   Navigator.pushReplacement(
      // context,
      // MaterialPageRoute(
      //     builder: (BuildContext context) => super.widget));

      //  print(data);

    } catch (e) {
      var snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Acta No enviado! ',
          message: 'Contacte al equipo de software!',
          contentType: ContentType.failure,
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      print(e);
    }
    // return "";
  }
//METODO API GET REST
  void actas() async {
    var requests = [];
    Map<String, String> mainheader = new Map();
    mainheader["content-type"] = "application/json";
    mainheader['x-access-token'] =
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6IlBydWViYXMiLCJyb2wiOiJTdXBlcnZpc29yIiwiaWQiOjk4MywiaWF0IjoxNjU2NDI0NTMwLCJleHAiOjE2NTY1MTA5MzB9.iZFKmLBjFuvW0W4hUb8RvONAayue2MGcF8a6gBnThOU';

    try {
      Response response = await get(
        Uri.parse(
            'https://actasalinstante.com:3030/api/actas/requests/obtainAll/'),
        headers: mainheader,
      );
      List<dynamic> data = jsonDecode(response.body);

      for (var i = 0; i < data.length; i++) {
        var metadata = "";
        data[i].toString();
        return showDialog(
          
          context: context,
          
          builder: (ctx) => AlertDialog(
            
            title: Text("Actas""\n"
             +"Tipo de busqueda: "+ data[i][metadata = 'type'].toString()+"\n""\n"
            +  "Tipo: " + data[i][metadata = 'metadata']['type'].toString()+"\n"
             + "Curp: " + data[i][metadata = 'metadata']['curp'].toString()+"\n"
              + "Creado: " + data[i][metadata = 'createdAt'].toString()+"\n"
              + "Estado: " + data[i][metadata = 'metadata']['state'].toString()+"\n"
                 + "" + data[i][metadata = 'url'].toString()+"\n"
                ),
            content: Text(""),
            actions: <Widget>[
              MaterialButton(
                    minWidth: double.infinity,
                    height: 60,
                    onPressed: (){
                   
                      showmodaldescargado();
                       Navigator.pushReplacement(
                       context,
                       MaterialPageRoute(
                       builder: (BuildContext context) => super.widget));
                    },
                    color: Color.fromARGB(255, 11, 156, 59),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)
                    ),
                    child: Text(
                      "⬇️ Descargar",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 18
                      ),
                    ),
                  ),
                    
                  Visibility(
                    
              child: Image.asset(
                'assets/NAC.png',
                height: 200.0,
                width: 1300.0,
               // fit: BoxFit.cover,
                alignment: Alignment.center,
                
              ),
            )
            ],
          ),
        );
      }

      //   Navigator.pushReplacement(
      // context,
      // MaterialPageRoute(
      //     builder: (BuildContext context) => super.widget));

      //  print(data);

    } catch (e) {
      var snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Acta No enviado! ',
          message: 'Contacte al equipo de software!',
          contentType: ContentType.failure,
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      print(e);
    }
    // return "";
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        elevation: 0,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.black,
          ),
        ),
      ),
        body: ListView(
          padding: EdgeInsets.all(16),
          children: [
            buildColoredCard(),
            buildImageCard(),
            buildImageCard2()
          ],
        ),
      );

  Widget buildColoredCard() => Card(
    
        shadowColor: Colors.green,
        elevation: 8,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green, Colors.green],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Acta de Nacimiento',
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

  Widget buildImageCard() => Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Visibility(
              child: Image.asset(
                'assets/NAC.png',
                height: 190.0,
                width: 190.0,
              ),
            ),
            Ink.image(
              image: NetworkImage(
                '',
              ),
              colorFilter: ColorFilters.greyscale,
              child: InkWell(
                onTap: () {
                  actas();
                },
              ),
              height: 240,
              fit: BoxFit.cover,
            ),
          ],
        ),
      );

      
  Widget buildImageCard2() => Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Visibility(
              child: Image.asset(
                'assets/NAC.png',
                height: 190.0,
                width: 190.0,
              ),
            ),
            Ink.image(
              image: NetworkImage(
                '',
              ),
              colorFilter: ColorFilters.greyscale,
              child: InkWell(
                onTap: () {
                  actas2();
                },
              ),
              height: 240,
              fit: BoxFit.cover,
            ),
          ],
        ),
      );
}
