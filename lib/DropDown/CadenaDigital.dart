import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:app_actasalinstante/Widgets/carousel_example.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../FlatMessage/Message.dart';
import '../NavBar.dart';
import '../RFCDescargas/services/Variables.dart';
import '../views/controller/controller.dart';

enum ViewDialogsAction { yes, no }

class CadenaDigital extends StatefulWidget {
  const CadenaDigital({key}) : super(key: key);
  @override
  _CadenaDigitalState createState() => _CadenaDigitalState();
}
// Puedes pasar cualquier objeto al parámetro `arguments`. En este ejemplo, crea una
// clase que contiene ambos, un título y un mensaje personalizable.

class _CadenaDigitalState extends State<CadenaDigital> {
  TextEditingController cadenadController = TextEditingController();

  bool tappedYes = false;
String Token = "";
  void actas(cadenad) async {
     SharedPreferences prefs = await SharedPreferences.getInstance();
  
  

 Token= prefs.getString('token');
    Map<String, String> mainheader = new Map();
    mainheader["content-type"] = "application/json";
    mainheader['x-access-token'] =Token;

    Map<String, dynamic> body = {
      "type": "Cadena Digital",
      "metadata": {"cadena": cadenad},
    };

    try {
      var response = await post(
          Uri.parse(
              'https://actasalinstante.com:3030/api/actas/requests/createOne/'),
          headers: mainheader,
          body: json.encode(body));
      Map<String, dynamic> output = jsonDecode(response.body);
      ;
      print(output);

      var snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Cadena digital enviada!',
          message: 'Revisa la vista de actas',
          contentType: ContentType.success,
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => NavBar()));
      //  return showDialog(

      //   context: context,
      //   builder: (ctx) => AlertDialog(
      //     title: Text("Acta de nacimiento enviado!!"),
      //     content: Text(""),
      //     actions: <Widget>[
      //       MaterialButton(
      //         onPressed: () {
      //           Navigator.push(
      //               context,
      //               MaterialPageRoute(
      //                   builder: (context) => Body()));
      //         },
      //         child: Text("Aceptar"),
      //       ),
      //     ],
      //   ),
      // );
      if (output["status"] == 200) {
        //  return "success";
        print('Actas Update');
      } else {}
    } catch (e) {
      // var snackBar = SnackBar(
      //     elevation: 0,
      //     behavior: SnackBarBehavior.floating,
      //     backgroundColor: Colors.transparent,
      //     content: AwesomeSnackbarContent(
      //       title: 'El robot esta apagado! ',
      //       message:
      //           'Contacte al equipo de software!',
      //       contentType: ContentType.failure,
      //     ),
      //   );

      //   ScaffoldMessenger.of(context).showSnackBar(snackBar);

    }
    // return "";
  }

  String curp = "Ingresa la Cadena Digital";

  var _currentSelectedValue;
  var _estadoselect;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey,
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
        backgroundColor: Colors.grey,
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
                            "Cadena digital",
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Solicitar Cadena Digital",
                            style: TextStyle(
                                fontSize: 15, color: Colors.grey[700]),
                          )
                        ],
                      ),

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40),
                        child: Column(
                          children: <Widget>[
                            // TextFormField(

                            //   controller: ActoController,

                            //   decoration: InputDecoration(hintText: 'Acto registral'.toUpperCase() ),
                            // ),
                            SizedBox(
                              //Use of SizedBox
                              height: 5,
                            ),
                            TextFormField(
                              keyboardType: TextInputType.number,
                              controller: cadenadController,
                              validator: (input) => input == ''
                                  ? "Cadena Digital Incorrecta"
                                  : null,
                              decoration: InputDecoration(
                                  label: Text(curp.toString()),
                                  hintText: 'Cadeda Digital'.toUpperCase()),
                              maxLength: 20,

                              //  obscureText: true,
                            ),
                            // TextFormField(
                            //   controller: cadenadController,
                            //   decoration: InputDecoration(
                            //       label: Text(curp.toString()),
                            //       hintText: 'cadena digital'.toUpperCase()),

                            //   //  obscureText: true,
                            // ),
                            SizedBox(
                              //Use of SizedBox
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40),
                        child: Container(
                          padding: EdgeInsets.only(top: 3, left: 3),
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
                              if (cadenadController.text.toString() == null ||
                                  cadenadController.text.toString() == "") {
                                var snackBar = SnackBar(
                                  elevation: 0,
                                  width: 400,
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: Colors.transparent,
                                  content: AwesomeSnackbarContent(
                                    title: 'Error',
                                    message: 'No escribiste la Cadena Digital!',
                                    contentType: ContentType.failure,
                                  ),
                                );

                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);

                                print('Text is empty');
                              } else if (cadenadController.text
                                      .toString()
                                      .length <
                                  20) {
                                final _controller = Get.find<Controller>();

                                _controller.errorCadenaDigital();
                                var digit =
                                    cadenadController.text.toString().length;

                                var snackBar = SnackBar(
                                  elevation: 10,
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: Colors.transparent,
                                  width: 500,
                                  content: AwesomeSnackbarContent(
                                    title: 'Error en la Cadena',
                                    message: 'Te faltan ${(20 - (digit))}' +
                                        ' Digitos En la La Cadena ',
                                    contentType: ContentType.failure,
                                  ),
                                );

                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              } else {
                                actas(
                                  cadenadController.text
                                      .toString()
                                      .toUpperCase(),
                                );

                                print(cadenadController.text
                                    .toString()
                                    .toUpperCase());
                              }

                              //       actas(
                              // _currentSelectedValue.toString().toUpperCase(),
                              // curpController.text.toString().toUpperCase(),
                              // _estadoselect.toString().toUpperCase());

                              //                     Navigator.pushReplacement(
                              // context,
                              // MaterialPageRoute(
                              //     builder: (BuildContext context) => super.widget));
                              // Navigator.push(context, MaterialPageRoute(builder: (context)=> CarouselExample()));
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

var entidadValue = 0;
var entidad;
var bdEstado;
String curp = '';
var nose;
onChangeCurp(String curp) {
  if (curp.length == 18) {
    curp = curp;
    var res = curp;
    switch (res.toUpperCase()) {
      case 'AS':
        {
          entidadValue = 1;
          entidad = 'AGUASCALIENTES';
          bdEstado = 'n0';
          nose = "1";
          break;
        }
      case 'BC':
        {
          entidadValue = 2;
          entidad = 'BAJA CALIFORNIA';
          bdEstado = 'n1';
          nose = "2";
          break;
        }
      case 'BS':
        {
          entidadValue = 3;
          entidad = 'BAJA CALIFORNIA SUR';
          bdEstado = 'n2';
          nose = "3";
          break;
        }
      case 'CC':
        {
          entidadValue = 4;
          entidad = 'CAMPECHE';
          bdEstado = 'n3';
          nose = "4";
          break;
        }
      case "CS":
        {
          entidadValue = 7;
          entidad = 'CHIAPAS';
          bdEstado = 'n4';
          nose = "5";
          break;
        }
      case 'CH':
        {
          entidadValue = 8;
          entidad = 'CHIHUAHUA';
          bdEstado = 'n5';
          nose = "6";
          break;
        }
      case 'DF':
        {
          entidadValue = 9;
          entidad = 'DISTRITO FEDERAL';
          bdEstado = 'n6';
          nose = "7";
          break;
        }
      case 'CL':
        {
          entidadValue = 5;
          entidad = 'COAHUILA DE ZARAGOZA';
          bdEstado = 'n7';
          nose = "8";
          break;
        }
      case 'CM':
        {
          entidadValue = 6;
          entidad = 'COLIMA';
          bdEstado = 'n8';
          nose = "9";
          break;
        }
      case 'DG':
        {
          entidadValue = 10;
          entidad = 'DURANGO';
          bdEstado = 'n9';
          nose = "10";
          break;
        }
      case 'GT':
        {
          entidadValue = 11;
          entidad = 'GUANAJUATO';
          bdEstado = 'n10';
          nose = "11";
          break;
        }
      case 'GR':
        {
          entidadValue = 12;
          entidad = 'GUERRERO';
          bdEstado = 'n11';
          nose = "12";
          break;
        }
      case 'HG':
        {
          entidadValue = 13;
          entidad = 'HIDALGO';
          bdEstado = 'n12';
          nose = "13";
          break;
        }
      case 'JC':
        {
          entidadValue = 14;
          entidad = 'JALISCO';
          bdEstado = 'n13';
          nose = "14";
          break;
        }
      case 'MC':
        {
          entidadValue = 15;
          entidad = 'MEXICO';
          bdEstado = 'n14';
          nose = "15";
          break;
        }
      case 'MN':
        {
          entidadValue = 16;
          entidad = 'MICHOACAN';
          bdEstado = 'n15';
          nose = "16";
          break;
        }
      case 'MS':
        {
          entidadValue = 17;
          entidad = 'MORELOS';
          bdEstado = 'n16';
          nose = "17";
          break;
        }
      case 'NT':
        {
          entidadValue = 18;
          entidad = 'NAYARIT';
          bdEstado = 'n17';
          nose = "18";
          break;
        }
      case 'NL':
        {
          entidadValue = 19;
          entidad = 'NUEVO LEON';
          bdEstado = 'n18';
          nose = "19";
          break;
        }
      case 'OC':
        {
          entidadValue = 20;
          entidad = 'OAXACA';
          bdEstado = 'n19';
          nose = "20";
          break;
        }
      case 'PL':
        {
          entidadValue = 21;
          entidad = 'PUEBLA';
          bdEstado = 'n20';
          nose = "21";
          break;
        }
      case 'QT':
        {
          entidadValue = 22;
          entidad = 'QUERETARO';
          bdEstado = 'n21';
          nose = "22";
          break;
        }
      case 'QR':
        {
          entidadValue = 23;
          entidad = 'QUINTANA ROO';
          bdEstado = 'n22';
          nose = "23";
          break;
        }
      case 'SP':
        {
          entidadValue = 24;
          entidad = 'SAN LUIS POTOSI';
          bdEstado = 'n23';
          nose = "24";
          break;
        }
      case 'SL':
        {
          entidadValue = 25;
          entidad = 'SINALOA';
          bdEstado = 'n24';
          nose = "25";
          break;
        }
      case 'SR':
        {
          entidadValue = 26;
          entidad = 'SONORA';
          bdEstado = 'n25';
          nose = "26";
          break;
        }
      case 'TC':
        {
          entidadValue = 27;
          entidad = 'TABASCO';
          bdEstado = 'n26';
          nose = "27";
          break;
        }

      case 'TS':
        {
          entidadValue = 28;
          entidad = 'Entidad no disponible';
          bdEstado = 'n27';
          nose = "28";
          break;
        }
      case 'TL':
        {
          entidadValue = 29;
          entidad = 'TLAXCALA';
          bdEstado = 'n28';
          nose = "29";
          break;
        }
      case 'VZ':
        {
          entidadValue = 30;
          entidad = 'Entidad no disponibles';
          bdEstado = 'n29';
          nose = "30";
          break;
        }
      case 'YN':
        {
          entidadValue = 31;
          entidad = 'YUCATAN';
          bdEstado = 'n30';
          nose = "31";
          break;
        }
      case 'ZS':
        {
          entidadValue = 32;
          entidad = 'ZACATECAS';
          bdEstado = 'n31';
          nose = "32";
          break;
        }
      default:
        {
          entidadValue = 39;
          entidad = 'NACIDO EN EL EXTRANJERO';
          bdEstado = 'n32';
          nose = "33";
          break;
        }
    }
  } else {
    entidad = 'Entidad de registro';
  }
}
