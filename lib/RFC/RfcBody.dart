import 'dart:convert';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:app_actasalinstante/Widgets/carousel_example.dart';
import 'package:http/http.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../NavBar.dart';
import '../RFCDescargas/services/Variables.dart';

enum ViewDialogsAction { yes, no }

class RfcBody extends StatefulWidget {
  const RfcBody({key}) : super(key: key);
  @override
  _RfcBodyState createState() => _RfcBodyState();
}
// Puedes pasar cualquier objeto al parámetro `arguments`. En este ejemplo, crea una
// clase que contiene ambos, un título y un mensaje personalizable.

class _RfcBodyState extends State<RfcBody> {
  TextEditingController curpController = TextEditingController();
  TextEditingController etadoController = TextEditingController();

  bool tappedYes = false;
  String Token = "";
  Send_RFC_CURP(String curp) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Token = prefs.getString('token');
    var headers = {'x-access-token': Token, 'Content-Type': 'application/json'};
    var request = http.Request('POST',
        Uri.parse('https://actasalinstante.com:3030/api/robots/services/new/'));
    request.body = json.encode({
      "data": {"data": curp, "search": "CURP", "clasification": "FISICA"},
      "source": "rfcs"
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      var snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'RFC enviado!',
          message: 'Revisa la vista de RFC',
          contentType: ContentType.success,
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => NavBar()));
    } else if (response.statusCode == 403) {
      ShowServiceActaOrRFC();
    } else {
      print(response.reasonPhrase);
    }
  }

  ShowServiceActaOrRFC() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.ERROR,
      animType: AnimType.BOTTOMSLIDE,
      title: 'Actas al instante',
      desc: 'No tienes habilitado el servicio de RFC \n Contacta al Administrador',
      btnCancelOnPress: () {
        //  Navigator.of(context).pop(true);
      },
      btnOkOnPress: () {},
    )..show();
  }
  // void actas(String curp) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();

  //   Token = prefs.getString('token');
  //   Map<String, String> mainheader = new Map();
  //   mainheader["content-type"] = "application/json";
  //   mainheader['x-access-token'] = Token;

  //   var body = jsonEncode({
  //     {
  //       "data": {
  //         "data": curp,
  //         "search": "CURP",
  //         "clasification": "FISICA",
  //       },
  //       "source": "rfcs"
  //     }
  //   });
  //   // Map<String, dynamic> body = {
  //   //   "search": "CURP",
  //   //   "data": curp,
  //   //   "clasification": "FISICA",
  //   //   "source": "rfcs",
  //   // };

  //   try {
  //     Response response = await post(
  //         Uri.parse(
  //             'https://actasalinstante.com:3030/api/robots/services/new/'),
  //         headers: mainheader,
  //         body: json.encode(body));
  //     Map<String, dynamic> output = jsonDecode(response.body);
  //     if (response.statusCode == 400) {
  //       print(output);
  //     }
  //     var snackBar = SnackBar(
  //       elevation: 0,
  //       behavior: SnackBarBehavior.floating,
  //       backgroundColor: Colors.transparent,
  //       content: AwesomeSnackbarContent(
  //         title: 'RFC enviado!',
  //         message: 'Revisa la vista de RFC',
  //         contentType: ContentType.success,
  //       ),
  //     );

  //     ScaffoldMessenger.of(context).showSnackBar(snackBar);
  //     Navigator.pushReplacement(context,
  //         MaterialPageRoute(builder: (BuildContext context) => NavBar()));

  //     print(output);
  //   } catch (e) {
  //     print(e);
  //   }
  //   // return "";
  // }

  CURP(String curps) {
    const String curpRegexPattern = "[A-Z]{1}[AEIOU]{1}[A-Z]{2}[0-9]{2}" +
        "(0[1-9]|1[0-2])(0[1-9]|1[0-9]|2[0-9]|3[0-1])" +
        "[HM]{1}" +
        "(AS|BC|BS|CC|CS|CH|CL|CM|DF|DG|GT|GR|HG|JC|MC|MN|MS|NT|NL|OC|PL|QT|QR|SP|SL|SR|TC|TS|TL|VZ|YN|ZS|NE)" +
        "[B-DF-HJ-NP-TV-Z]{3}" +
        "[0-9A-Z]{1}[0-9]{1}\$";
    // String curpARevisar = "estodaerror";
    // String curpARevisar2 = "SIHC400128HDFLLR01";
    RegExp regExp = new RegExp(
      curpRegexPattern,
      caseSensitive: false,
      multiLine: false,
    );
    String resultado = "";
    if (regExp.hasMatch(curps)) {
      resultado = "El curp es válido";
      Send_RFC_CURP(curpController.text.toString().toUpperCase());
    } else {
      var snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: '😡Error de formato!😡',
          message: 'Revise su curp: ' + curps,
          contentType: ContentType.failure,
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      resultado = "curp inválido";
    }
    print(resultado);
    print(curps);
  }

  String curp = "Ingresa tu Curp";
  final dropvalue = ValueNotifier('');
  final dropOpcoes = ['Nacimiento', 'Defuncion', 'Matrimonio', 'Divorcio'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color.fromARGB(255, 127,137,146),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Actas Al Instante ',
          style: TextStyle(
            fontSize: 20,
            fontFamily: 'RobotoMono',
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
        ),
        elevation: 0,
        brightness: Brightness.light,
        backgroundColor: Color.fromARGB(255, 127,137,146),
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
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40)),
                      color: Colors.white),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Text(
                            "RFC",
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Solicitar RFC por Curp",
                            style: TextStyle(
                                fontSize: 15, color: Color.fromARGB(255, 127,137,146),),
                          )
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40),
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              controller: curpController,
                              validator: (input) =>
                                  input == '' ? "Ingresa un usuario" : null,
                              decoration: InputDecoration(
                                  label: Text(curp.toString()),
                                  hintText: 'curp'.toUpperCase()),
                              maxLength: 18,

                              //  obscureText: true,
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 50),
                        child: Container(
                          padding: EdgeInsets.only(top: 1, left: 1),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              border: Border(
                                bottom: BorderSide(color: Colors.black),
                                top: BorderSide(color: Colors.black),
                                left: BorderSide(color: Colors.black),
                                right: BorderSide(color: Colors.black),
                              )),
                          child: MaterialButton(
                            minWidth: double.infinity,
                            height: 60,
                            onPressed: () {
                              if (curpController.text.toString() == null ||
                                  curpController.text.toString() == "") {
                                var snackBar = SnackBar(
                                  elevation: 0,
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: Colors.transparent,
                                  content: AwesomeSnackbarContent(
                                    title: 'No escribiste la Curp! ',
                                    message: '',
                                    contentType: ContentType.failure,
                                  ),
                                );

                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);

                                print('Text is empty');
                              } else if (curpController.text.toString().length <
                                  18) {
                                var digit =
                                    curpController.text.toString().length;

                                var snackBar = SnackBar(
                                  elevation: 10,
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: Colors.transparent,
                                  width: 500,
                                  content: AwesomeSnackbarContent(
                                    title: 'Error en la curp',
                                    message: 'Te faltan ${(18 - (digit))}' +
                                        ' digitos en la curp ',
                                    contentType: ContentType.failure,
                                  ),
                                );

                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              } else {
                                CURP(curpController.text
                                    .toString()
                                    .toUpperCase());

                                print(curpController.text
                                        .toString()
                                        .toUpperCase() +
                                    etadoController.text
                                        .toString()
                                        .toUpperCase());
                              }
                            },
                            color: Colors.black,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Text(
                              "Enviar",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Container(
                      //   padding: EdgeInsets.only(top: 100),
                      //   height: 200,
                      //   decoration: BoxDecoration(
                      //     image: DecorationImage(
                      //         image: AssetImage("assets/background.png"),
                      //         fit: BoxFit.fitHeight),
                      //   ),
                      // )
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }
}

validateRFC(var rfc) {
  var patternPM = "^(([A-ZÑ&]{3})([0-9]{2})([0][13578]|[1][02])(([0][1-9]|[12][\\d])|[3][01])([A-Z0-9]{3}))|" +
      "(([A-ZÑ&]{3})([0-9]{2})([0][13456789]|[1][012])(([0][1-9]|[12][\\d])|[3][0])([A-Z0-9]{3}))|" +
      "(([A-ZÑ&]{3})([02468][048]|[13579][26])[0][2]([0][1-9]|[12][\\d])([A-Z0-9]{3}))|" +
      "(([A-ZÑ&]{3})([0-9]{2})[0][2]([0][1-9]|[1][0-9]|[2][0-8])([A-Z0-9]{3}))";
  var patternPF = "^(([A-ZÑ&]{4})([0-9]{2})([0][13578]|[1][02])(([0][1-9]|[12][\\d])|[3][01])([A-Z0-9]{3}))|" +
      "(([A-ZÑ&]{4})([0-9]{2})([0][13456789]|[1][012])(([0][1-9]|[12][\\d])|[3][0])([A-Z0-9]{3}))|" +
      "(([A-ZÑ&]{4})([02468][048]|[13579][26])[0][2]([0][1-9]|[12][\\d])([A-Z0-9]{3}))|" +
      "(([A-ZÑ&]{4})([0-9]{2})[0][2]([0][1-9]|[1][0-9]|[2][0-8])([A-Z0-9]{3}))";

  if (rfc.match(patternPM) || rfc.match(patternPF)) {
    return true;
  } else {
    print("La estructura de la clave de RFC es incorrecta.");
    return false;
  }
}

// we will be creating a widget for text field
Widget inputFile({label, obscureText = false}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        label,
        style: TextStyle(
            fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black87),
      ),
      SizedBox(
        height: 5,
      ),
      TextField(
        obscureText: obscureText,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black12),
            ),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black12))),
      ),
      SizedBox(
        height: 10,
      )
    ],
  );
}
