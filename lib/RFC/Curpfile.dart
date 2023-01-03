import 'dart:convert';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:app_actasalinstante/Widgets/carousel_example.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../NavBar.dart';
import '../RFCDescargas/services/Variables.dart';
import '../views/controller/controller.dart';

enum ViewDialogsAction { yes, no }

class CurpRfcBody extends StatefulWidget {
  const CurpRfcBody({key}) : super(key: key);
  @override
  _CurpRfcBodyState createState() => _CurpRfcBodyState();
}
// Puedes pasar cualquier objeto al parámetro `arguments`. En este ejemplo, crea una
// clase que contiene ambos, un título y un mensaje personalizable.

class _CurpRfcBodyState extends State<CurpRfcBody> {
  TextEditingController curpController = TextEditingController();
  TextEditingController etadoController = TextEditingController();
  Send_RFC_CURP(String curp) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Token = prefs.getString('token');
    var headers = {'x-access-token': Token, 'Content-Type': 'application/json'};
    var request = http.Request('POST',
        Uri.parse('https://actasalinstante.com:3030/api/robots/services/new/'));
    request.body = json.encode({
      "data": {"data": curp, "search": "RFC", "clasification": "FISICA"},
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
      desc:
          'No tienes habilitado el servicio de RFC \n Contacta al Administrador',
      btnCancelOnPress: () {
        //  Navigator.of(context).pop(true);
      },
      btnOkOnPress: () {},
    )..show();
  }

  bool tappedYes = false;
  String Token = "";
  // void actas(String curp) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();

  //   Token = prefs.getString('token');
  //   Map<String, String> mainheader = new Map();
  //   mainheader["content-type"] = "application/json";
  //   mainheader['x-access-token'] = Token;
  //   Map<String, dynamic> body = {
  //     "search": "RFC",
  //     "data": curp,
  //     "clasification": "FISICA",
  //     "source": "rfcs",
  //   };

  //   try {
  //     var response = await post(
  //         Uri.parse(
  //             'https://actasalinstante.com:3030/api/robots/services/new/'),
  //         headers: mainheader,
  //         body: json.encode(body));
  //     Map<String, dynamic> output = jsonDecode(response.body);
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
  //     // var snackBar = SnackBar(
  //     //     elevation: 0,
  //     //     behavior: SnackBarBehavior.floating,
  //     //     backgroundColor: Colors.transparent,
  //     //     content: AwesomeSnackbarContent(
  //     //       title: 'RFC No enviado! ',
  //     //       message:
  //     //           'Contacte al equipo de software!',
  //     //       contentType: ContentType.failure,
  //     //     ),
  //     //   );

  //     //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
  //     print(e);
  //   }
  //   // return "";
  // }

  showcurp() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 20,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(64),
          ),
          insetPadding: EdgeInsets.zero,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          backgroundColor: Colors.white,
          contentPadding: EdgeInsets.all(90.0),
          alignment: Alignment.center,
          title: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Material(
              child: InkWell(
                onTap: () {},
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Image.asset('assets/NACIMIENTO.jpg',
                      width: 312.0, height: 150.0),
                ),
              ),
            ),
          ]),
          actions: <Widget>[
            SizedBox(height: 8),
            new Center(
                child: Text(
              '😡Error de formato!😡\n' +
                  curpController.text.toString().toUpperCase(),
              style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'avenir',
                  fontWeight: FontWeight.w800,
                  color: Colors.red),
              overflow: TextOverflow.ellipsis,
            )),
            SizedBox(height: 8),
            new Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.purple,
                  borderRadius: BorderRadius.circular(82),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    MaterialButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                        var snackBar = SnackBar(
                          elevation: 0,
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.transparent,
                          content: AwesomeSnackbarContent(
                            title: '😡Error de formato!😡',
                            message: 'Revise su RFC: ' +
                                curpController.text.toString().toUpperCase(),
                            contentType: ContentType.failure,
                          ),
                        );

                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      },
                      child: Text("Ok"),
                      textColor: Colors.white,
                    ),
                    // Icon(
                    //   Icons.amp_stories_outlined,
                    //   size: 19,
                    //   color: Colors.white,
                    // ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  RFC(String rfcs) {
    final _controller = Get.find<Controller>();
    // " ^([A-ZÑ\x26]{3,4}([0-9]{2})(0[1-9]|1[0-2])(0[1-9]|1[0-9]|2[0-9]|3[0-1])[A-Z|\d]{3})\$"
    const String rfcRegexPattern =
        "^(([A-ZÑ&]{4})([0-9]{2})([0][13578]|[1][02])(([0][1-9]|[12][\\d])|[3][01])([A-Z0-9]{3}))|" +
            "(([A-ZÑ&]{4})([0-9]{2})([0][13456789]|[1][012])(([0][1-9]|[12][\\d])|[3][0])([A-Z0-9]{3}))|" +
            "(([A-ZÑ&]{4})([02468][048]|[13579][26])[0][2]([0][1-9]|[12][\\d])([A-Z0-9]{3}))|" +
            "(([A-ZÑ&]{4})([0-9]{2})[0][2]([0][1-9]|[1][0-9]|[2][0-8])([A-Z0-9]{3}))\$";
    // String curpARevisar = "estodaerror";
    // String curpARevisar2 = "SIHC400128HDFLLR01";
    RegExp regExp = new RegExp(
      rfcRegexPattern,
      caseSensitive: false,
      multiLine: false,
    );
    String resultado = "";
    if (regExp.hasMatch(rfcs)) {
      resultado = "El RFC es válido";
      Send_RFC_CURP(curpController.text.toString().toUpperCase());
    } else {
      _controller.errorRFC();
      showcurp();

      resultado = "RFC inválido";
    }
    print(resultado);
    print(rfcs);
  }

  final Color color = HexColor('#D61C4E');
  final dropvalue = ValueNotifier('');
  final dropOpcoes = ['Nacimiento', 'Defuncion', 'Matrimonio', 'Divorcio'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: color,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Actas Al Instante ',
          style: TextStyle(
            fontSize: 20,
            fontFamily: 'RobotoMono',
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        elevation: 0,
        brightness: Brightness.light,
        backgroundColor: color,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.white,
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
                            "Solicitar RFC",
                            style: TextStyle(
                              fontSize: 15,
                              color: Color.fromARGB(255, 127, 137, 146),
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40),
                        child: Column(
                          children: <Widget>[
                            //              ValueListenableBuilder(
                            // valueListenable: dropvalue,
                            // builder: (BuildContext context, String value, _) {
                            //   return DropdownButton<String>(
                            //     icon: const Icon(Icons.document_scanner),
                            //     hint: const Text('Seleciona el tipo de acta'),
                            //     value: (value.isEmpty) ? null : value,
                            //     onChanged:(escolha) => dropvalue.value = escolha.toString(),
                            //     items: dropOpcoes
                            //     .map((op) => DropdownMenuItem(
                            //       value: op,
                            //       child: Text(op),
                            //       ))

                            //       .toList(),

                            //   );

                            // }),
                            TextFormField(
                              controller: curpController,
                              decoration: InputDecoration(
                                  hintText: 'rfc'.toUpperCase()),
                              maxLength: 13,

                              //  obscureText: true,
                            ),

                            // inputFile(label: "Correo"),
                            // inputFile(label: "Contraseña", obscureText: true)
                          ],
                        ),
                      ),

                      new Center(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(52),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 8),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              MaterialButton(
                                onPressed: () {
                                  if (curpController.text.toString() == null ||
                                      curpController.text.toString() == "") {
                                    var snackBar = SnackBar(
                                      elevation: 0,
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor: Colors.transparent,
                                      content: AwesomeSnackbarContent(
                                        title: 'No escribiste el RFC! ',
                                        message: '',
                                        contentType: ContentType.failure,
                                      ),
                                    );

                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);

                                    print('Text is empty');
                                  } else if (curpController.text
                                          .toString()
                                          .length <
                                      13) {
                                    var digit =
                                        curpController.text.toString().length;

                                    var snackBar = SnackBar(
                                      elevation: 10,
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor: Colors.transparent,
                                      width: 500,
                                      content: AwesomeSnackbarContent(
                                        title: 'Error en el RFC',
                                        message: 'Te faltan ${(13 - (digit))}' +
                                            ' digitos en el RFC ',
                                        contentType: ContentType.failure,
                                      ),
                                    );

                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  } else {
                                    RFC(curpController.text
                                        .toString()
                                        .toUpperCase());
                                    //  actas(curpController.text.toString().toUpperCase());

                                    print(curpController.text
                                            .toString()
                                            .toUpperCase() +
                                        etadoController.text
                                            .toString()
                                            .toUpperCase());
                                  }
                                },
                                child: Text("Enviar"),
                                textColor: Colors.white,
                              ),
                              Icon(
                                Icons.send,
                                size: 19,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                      new Center(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(52),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 8),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              MaterialButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text("Cancelar"),
                                textColor: Colors.white,
                              ),
                              Icon(
                                Icons.warning_amber,
                                size: 19,
                                color: Colors.white,
                              ),
                            ],
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
