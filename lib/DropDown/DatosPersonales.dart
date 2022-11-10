import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:app_actasalinstante/Widgets/carousel_example.dart';
import 'package:http/http.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:intl/intl.dart';
import '../FlatMessage/Message.dart';
import '../RFCDescargas/services/Variables.dart';
import 'package:date_field/date_field.dart';

import 'DatosPersonalesMatrimonio.dart';

enum ViewDialogsAction { yes, no }

class DatosPersonales extends StatefulWidget {
  const DatosPersonales({key}) : super(key: key);
  @override
  _DatosPersonalesState createState() => _DatosPersonalesState();
}
// Puedes pasar cualquier objeto al parámetro `arguments`. En este ejemplo, crea una
// clase que contiene ambos, un título y un mensaje personalizable.

class _DatosPersonalesState extends State<DatosPersonales> {
  TextEditingController ActoController = TextEditingController();
  TextEditingController etadoController = TextEditingController();
  TextEditingController nombresController = TextEditingController();
  TextEditingController apellido1Controller = TextEditingController();
  TextEditingController apellido2Controller = TextEditingController();
  TextEditingController fechaController = TextEditingController();

  bool tappedYes = false;
  onpress() {
    if (fechaController.text.toString().length == 2 ||
        fechaController.text.toString().length == 5) {
      fechaController.text = fechaController.text.toString() + "/";
    }
  }

  void actas(
      String acto, etado, nombres, apellido1, apellido2, sexo, fecha) async {
    Map<String, String> mainheader = new Map();
    mainheader["content-type"] = "application/json";
    mainheader['x-access-token'] = getIt<AuthModel>().token;

    Map<String, dynamic> body = {
      "type": "Datos Personales",
      "metadata": {
        "type": acto,
        "state": etado,
        "nombre": nombres,
        "primerapellido": apellido1,
        "segundoapelido": apellido2,
        "sexo": sexo,
        "fecha": fecha
      },
    };

    try {
      Response response = await post(
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
          title: 'Acta enviada!',
          message: 'Descarga tus Actas!',
          contentType: ContentType.success,
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => super.widget));
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
      } else {
        var snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Acta lista para descargar! ',
            message: '',
            contentType: ContentType.success,
          ),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
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

  String label = "Seleciona el Acto Registral";
  String genero = "Sexo*";
  String Nombres = "Ingresa tu Nombre(s)";
  String PrimerApellido = "Ingresa tu Primer Apellido";
  String SegundoApellido = "Ingresa tu Segundo Apellido";
  String fecha = "Ingresa tu fecha de nacimiento";
  String estado = "Seleciona el Estado";
  var _currentSelectedValue;
  DateTime selectedDate;
  var gen;
  var _estadoselect;
  var _currencies = ["Nacimiento", "Defuncion", "Matrimonio", "Divorcio"];
  var generos = ["Hombre", "Mujer"];
  var estados = [
    "Aguascalientes",
    "Baja California",
    "Baja California Sur",
    "Campeche",
    "Chiapas",
    "Chihuahua",
    "Coahuila",
    "Colima",
    "Distrito Federal",
    "Durango",
    "Guanajuato",
    "Guerrero",
    "Hidalgo",
    "Jalisco",
    "Estado de México",
    "Michoacán",
    "Morelos",
    "Nayarit",
    "Nuevo León",
    "Oaxaca",
    "Puebla",
    "Querétaro",
    "Quintana Roo",
    "San Luis Potosí",
    "Sinaloa",
    "Sonora",
    "Tabasco",
    "Tamaulipas",
    "Tlaxcala",
    "Veracruz",
    "Yucatán",
    "Zacatecas",
  ];
  DateTime fech;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
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
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text(
                      "Datos Personales",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    // Text(
                    //   "Solicitar busqueda por datos personales",
                    //   style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                    // )
                  ],
                ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 70),
                  child: Column(
                    children: <Widget>[
                      FormField<String>(
                        builder: (FormFieldState<String> state) {
                          return InputDecorator(
                            decoration: InputDecoration(
                                label: Text(label.toString()),
                                errorStyle: TextStyle(
                                    color: Colors.redAccent, fontSize: 16.0),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0))),
                            isEmpty: _currentSelectedValue == '',
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _currentSelectedValue,
                                isDense: true,
                                onChanged: (String newValue) {
                                  setState(() {
                                    _currentSelectedValue = newValue;
                                    state.didChange(newValue);
                                    if (_currentSelectedValue.toString() ==
                                            "Matrimonio" ||
                                        _currentSelectedValue.toString() ==
                                            "Divorcio") {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  DatosPersonalesMatrimonio()));
                                      print("Hello");
                                    }
                                  });
                                },
                                items: _currencies.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(
                        //Use of SizedBox
                        height: 25,
                      ),
                      FormField<String>(
                        builder: (FormFieldState<String> state) {
                          return InputDecorator(
                            decoration: InputDecoration(
                                label: Text(estado.toString()),
                                errorStyle: TextStyle(
                                    color: Colors.redAccent, fontSize: 16.0),
                                hintText: 'Please select expense',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0))),
                            isEmpty: _estadoselect == '',
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _estadoselect,
                                isDense: true,
                                onChanged: (String newValue) {
                                  setState(() {
                                    _estadoselect = newValue;
                                    state.didChange(newValue);
                                  });
                                },
                                items: estados.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(
                        //Use of SizedBox
                        height: 5,
                      ),
                      TextFormField(
                        controller: nombresController,
                        decoration: InputDecoration(
                            label: Text(Nombres.toString()),
                            hintText: 'Nombre(s)'.toUpperCase()),

                        //  obscureText: true,
                      ),
                      SizedBox(
                        //Use of SizedBox
                        height: 20,
                      ),
                      TextFormField(
                        controller: apellido1Controller,
                        decoration: InputDecoration(
                            label: Text(PrimerApellido.toString()),
                            hintText: 'Primer Apellido'.toUpperCase()),

                        //  obscureText: true,
                      ),
                      SizedBox(
                        //Use of SizedBox
                        height: 20,
                      ),
                      TextFormField(
                        controller: apellido2Controller,
                        decoration: InputDecoration(
                            label: Text(SegundoApellido.toString()),
                            hintText: 'Segundo Apellido'.toUpperCase()),

                        //  obscureText: true,
                      ),
                      SizedBox(
                        //Use of SizedBox
                        height: 15,
                      ),
                      FormField<String>(
                        builder: (FormFieldState<String> state) {
                          return InputDecorator(
                            decoration: InputDecoration(
                                label: Text(genero.toString()),
                                errorStyle: TextStyle(
                                    color: Colors.redAccent, fontSize: 16.0),
                                hintText: 'Please select expense',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0))),
                            isEmpty: gen == '',
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: gen,
                                isDense: true,
                                onChanged: (String newValue) {
                                  setState(() {
                                    gen = newValue;
                                    state.didChange(newValue);
                                  });
                                },
                                items: generos.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(
                        //Use of SizedBox
                        height: 5,
                      ),
                      TextField(
                        controller:
                            fechaController, //editing controller of this TextField
                        decoration: InputDecoration(
                            icon:
                                Icon(Icons.calendar_today), //icon of text field
                            labelText:
                                "Fecha de nacimiento" //label text of field
                            ),
                        readOnly:
                            true, //set it true, so that user will not able to edit text
                        onTap: () async {
                          DateTime pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(
                                  1900), //DateTime.now() - not to allow to choose before today.
                              lastDate: DateTime(2101));

                          if (pickedDate != null) {
                            print(
                                pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                            String formattedDate =
                                DateFormat('yyyy-MM-dd').format(pickedDate);
                            print(
                                formattedDate); //formatted date output using intl package =>  2021-03-16
                            //you can implement different kind of Date Format here according to your requirement

                            setState(() {
                              fechaController.text =
                                  formattedDate; //set output date to TextField value.
                            });
                          } else {
                            var snackBar = SnackBar(
                              elevation: 0,
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.transparent,
                              content: AwesomeSnackbarContent(
                                title: 'Te faltan tu fecha de nacimiento',
                                message: '',
                                contentType: ContentType.failure,
                              ),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                        },
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 60),
                  child: Container(
                    padding: EdgeInsets.only(top: 5, left: 5),
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
                        if (nombresController.text.toString() == "") {
                          var snackBar = SnackBar(
                            elevation: 0,
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.transparent,
                            content: AwesomeSnackbarContent(
                              title: 'Te faltan tu nombre',
                              message: '',
                              contentType: ContentType.failure,
                            ),
                          );

                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          print("te fatan difgitos");
                        }
                        if (apellido1Controller.text.toString() == "" ||
                            apellido2Controller.text.toString() == "") {
                          var snackBar = SnackBar(
                            elevation: 0,
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.transparent,
                            content: AwesomeSnackbarContent(
                              title: 'Te faltan tus apellidos',
                              message: '',
                              contentType: ContentType.failure,
                            ),
                          );

                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        } else {
                          actas(
                              _currentSelectedValue.toString().toUpperCase(),
                              _estadoselect.toString().toUpperCase(),
                              nombresController.text.toString().toUpperCase(),
                              apellido1Controller.text.toString().toUpperCase(),
                              apellido2Controller.text.toString().toUpperCase(),
                              gen.toString().toUpperCase(),
                              fechaController.text.toString().toUpperCase());

                          print(_currentSelectedValue.toString().toUpperCase() +
                              _estadoselect.toString().toUpperCase() +
                              nombresController.text.toString().toUpperCase() +
                              apellido1Controller.text
                                  .toString()
                                  .toUpperCase() +
                              apellido2Controller.text
                                  .toString()
                                  .toUpperCase() +
                              gen.toString().toUpperCase() +
                              fechaController.text.toString().toUpperCase());
                        }
                      },
                      color: Color.fromARGB(255, 103, 231, 141),
                      elevation: 8,
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
            ))
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
