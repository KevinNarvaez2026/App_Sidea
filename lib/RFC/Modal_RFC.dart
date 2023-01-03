import 'dart:convert';

import 'package:app_actasalinstante/DropDown/Body.dart';
import 'package:app_actasalinstante/RFC/RFC_Moral.dart';
import 'package:app_actasalinstante/RFCDescargas/views/homepage.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:animated_background/animated_background.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../ColorScheme.dart';
import '../DropDown/DropDown.dart';
import '../Inicio/InicioActas.dart';
import '../NavBar.dart';
import '../New_Home/widgets/active_project_card.dart';
import '../RFC/RfcBody.dart';
import '../RFC/Transicion.dart';
import '../RFCDescargas/services/Variables.dart';
import '../views/homepage.dart';
import 'Curpfile.dart';

class ModalRfc extends StatefulWidget {
  const ModalRfc({key}) : super(key: key);

  @override
  _ModalRfcState createState() => _ModalRfcState();
}

class _ModalRfcState extends State<ModalRfc>
    with SingleTickerProviderStateMixin {
  // create animation controller
  AnimationController _animationController;

  // initialise animation controller
  @override
  void initState() {
    super.initState();
    GetNames();
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
  }

  String user = "";
  GetNames() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      user = prefs.getString('username');
    });
    print(user);
  }

  // method for when user taps icon
  bool currentlyPlaying = false;
  void _iconTapped() {
    if (currentlyPlaying == false) {
      currentlyPlaying = true;
      _animationController.forward();
    } else {
      currentlyPlaying = false;
      _animationController.reverse();
    }
  }

  static const duration = Duration(milliseconds: 300);
  List imgList = [
    'assets/MATRIMONIO.jpg',
    'assets/DEFUNCION.jpg',
    'assets/NACIMIENTO.jpg',
    'assets/RFC.jpg',
  ];
  showAlert() {
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
          contentPadding: EdgeInsets.all(120.0),
          alignment: Alignment.center,

          title: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              width: 250,
              height: 200,
              child: FormField<String>(
                builder: (FormFieldState<String> state) {
                  return InputDecorator(
                    decoration: InputDecoration(
                        label: Text(label.toString()),
                        errorStyle:
                            TextStyle(color: Colors.redAccent, fontSize: 16.0),
                        hintText: 'Please select expense',
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
                            print(_currentSelectedValue);
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
            ),
            Expanded(child: SizedBox.shrink()),
            Container(
              width: 200,
              height: 200,
              child: FormField<String>(
                builder: (FormFieldState<String> state) {
                  return InputDecorator(
                    decoration: InputDecoration(
                        label: Text(label.toString()),
                        errorStyle:
                            TextStyle(color: Colors.redAccent, fontSize: 16.0),
                        hintText: 'Please select expense',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                    isEmpty: _currentSelectedValueRFC == '',
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _currentSelectedValueRFC,
                        isDense: true,
                        onChanged: (String newValue) {
                          setState(() {
                            _currentSelectedValue = newValue;
                            state.didChange(newValue);
                            print(_currentSelectedValueRFC);
                          });
                        },
                        items: _currencies2.map((String value) {
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
            ),
            if (_currentSelectedValue == "Moral")
              Expanded(child: SizedBox.shrink()),
            if (_currentSelectedValue == "Moral")
              Container(
                width: 200,
                height: 200,
                child: FormField<String>(
                  builder: (FormFieldState<String> state) {
                    return InputDecorator(
                      decoration: InputDecoration(
                          label: Text(label.toString()),
                          errorStyle: TextStyle(
                              color: Colors.redAccent, fontSize: 16.0),
                          hintText: 'Please select expense',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                      isEmpty: _currentSelectedValueRFC == '',
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _currentSelectedValueRFC,
                          isDense: true,
                          onChanged: (String newValue) {
                            setState(() {
                              _currentSelectedValueRFC = newValue;
                              state.didChange(newValue);
                              print(_currentSelectedValueRFC);
                            });
                          },
                          items: Moral.map((String value) {
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
              ),
          ]),
          //content: Text("Are You Sure Want To Proceed?"),

          actions: <Widget>[
            SizedBox(height: 8),
            new Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(82),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    MaterialButton(
                      onPressed: () {
                        // Send_RFC_CURP(
                        //     _currentSelectedValue.toString().toUpperCase(),
                        //     curpController.text.toString().toUpperCase(),
                        //     entidad.toString(),
                        //     simple.toString());
                      },
                      child: Text("Simple"),
                      textColor: Colors.white,
                    ),
                    Icon(
                      Icons.amp_stories_outlined,
                      size: 19,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 8),
            new Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(82),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    MaterialButton(
                      onPressed: () {
                        print(_currentSelectedValue);
                        // Send_RFC_CURP(
                        //     _currentSelectedValue.toString().toUpperCase(),
                        //     curpController.text.toString().toUpperCase(),
                        //     entidad.toString(),
                        //     ConReverso.toString());
                      },
                      child: Text("Con Reverso"),
                      textColor: Colors.white,
                    ),
                    Icon(
                      Icons.amp_stories,
                      size: 19,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  final Color color = HexColor('#D61C4E');

  final Color color_Card = HexColor('#01081f');
  var _currentSelectedValue;
  var _currentSelectedValueRFC;
  var _currentSelectedValueCURP;
  String label = "Persona";
  var _currencies = ["Fisica", "Moral"];
  var _currencies2 = ["CURP", "RFC"];
  var Moral = ["RFC"];
  var cambio;
  String selectedType = "initial";
  String selectedFrequency = "monthly";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  color: Colors.white),
              child: Column(
                children: [
                  FormField<String>(
                    builder: (FormFieldState<String> state) {
                      return InputDecorator(
                        decoration: InputDecoration(
                            label: Text("Tipo de persona".toUpperCase()),
                            errorStyle: TextStyle(
                                color: Colors.redAccent, fontSize: 16.0),
                            hintText: 'Please select expense',
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
                                print(_currentSelectedValue);
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
                  SizedBox(height: 25.0),
                  if (_currentSelectedValue == "Moral")
                    FormField<String>(
                      builder: (FormFieldState<String> state) {
                        return InputDecorator(
                          decoration: InputDecoration(
                              label: Text("Busqueda por".toUpperCase()),
                              errorStyle: TextStyle(
                                  color: Colors.redAccent, fontSize: 16.0),
                              hintText: 'Please select expense',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0))),
                          isEmpty: _currentSelectedValueRFC == '',
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _currentSelectedValueRFC,
                              isDense: true,
                              onChanged: (String newValue) {
                                setState(() {
                                  _currentSelectedValueRFC = newValue;
                                  state.didChange(newValue);
                                  print(_currentSelectedValueRFC);
                                });
                              },
                              items: Moral.map((String value) {
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
                  if (_currentSelectedValue == "Fisica")
                    FormField<String>(
                      builder: (FormFieldState<String> state) {
                        return InputDecorator(
                          decoration: InputDecoration(
                              label: Text("Busqueda por".toUpperCase()),
                              errorStyle: TextStyle(
                                  color: Colors.redAccent, fontSize: 16.0),
                              hintText: 'Please select expense',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0))),
                          isEmpty: _currentSelectedValueCURP == '',
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _currentSelectedValueCURP,
                              isDense: true,
                              onChanged: (String newValue) {
                                setState(() {
                                  _currentSelectedValueCURP = newValue;
                                  state.didChange(newValue);
                                  print(_currentSelectedValueCURP);
                                });
                              },
                              items: _currencies2.map((String value) {
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
                  SizedBox(height: 25.0),
                  if (_currentSelectedValue == "Fisica" &&
                      _currentSelectedValueCURP != "RFC" && _currentSelectedValueCURP == "CURP")
                    TextFormField(
                      cursorColor: Colors.black,
                      style: TextStyle(color: Colors.black),
                      controller: curpController,
                      validator: (input) =>
                          input == '' ? "Ingresa un usuario" : null,
                      decoration: InputDecoration(
                          label: Text("Curp a buscar".toString().toUpperCase()),
                          hintText: 'curp'.toUpperCase()),
                      maxLength: 18,
                      onChanged: (newValue) {
                        print(newValue);
                        setState(() {
                          onChangeCurp(
                              curpController.text.toString().toUpperCase());
                        });
                      },

                      //  obscureText: true,
                    ),
                  if (_currentSelectedValue == "Fisica" &&
                      _currentSelectedValueCURP == "RFC")
                    TextFormField(
                      cursorColor: Colors.black,
                      style: TextStyle(color: Colors.black),
                      controller: curpController,
                      validator: (input) =>
                          input == '' ? "Ingresa un usuario" : null,
                      decoration: InputDecoration(
                          label: Text("RFC a buscar".toString().toUpperCase()),
                          hintText: 'curp'.toUpperCase()),
                      maxLength: 13,
                      onChanged: (newValue) {
                        print(newValue);
                        setState(() {
                          onChangeCurp(
                              curpController.text.toString().toUpperCase());
                        });
                      },

                      //  obscureText: true,
                    ),
                  if (_currentSelectedValue == "Moral")
                    TextFormField(
                      controller: curpController,
                      decoration:
                          InputDecoration(hintText: 'RFC MORAL'.toUpperCase()),
                      maxLength: 12,

                      //  obscureText: true,
                    ),
                  if (entidad.toString() != "Entidad de registro" &&
                      entidad.toString() != "null")
                    TextFormField(
                      controller: etadoController,
                      decoration: InputDecoration(
                          hintText: '' + entidad.toString(),
                          contentPadding: const EdgeInsets.all(10),
                          fillColor: Colors.green,
                          filled: true, // dont forget this line
                          hintStyle: TextStyle(color: Colors.white)),
                      readOnly: true,

                      // obscureText: true,
                    ),
                  if (entidad.toString() == "Entidad de registro" &&
                      entidad.toString() == "null" )
                    TextFormField(
                      controller: etadoController,
                      decoration: InputDecoration(
                          hintText: '' + entidad.toString(),
                          contentPadding: const EdgeInsets.all(20),
                          fillColor: Colors.red,
                          filled: true,
                          hintStyle: TextStyle(color: Colors.white)),

                      readOnly: true,

                      // obscureText: true,
                    ),
                      if (entidad.toString() == "Entidad de registro" ||
                          entidad.toString() == "null" && _currentSelectedValueCURP == "CURP" )
                        new Center(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(82),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 8),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                MaterialButton(
                                  onPressed: null,
                                  onLongPress: null,
                                  child: Text("LLena Los Campos"),
                                  textColor: Colors.white,
                                ),
                                Icon(
                                  Icons.close,
                                  size: 17,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                  SizedBox(height: 25.0),
                  if (_currentSelectedValue == "Moral")
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
                                    12) {
                                  var digit =
                                      curpController.text.toString().length;

                                  var snackBar = SnackBar(
                                    elevation: 10,
                                    behavior: SnackBarBehavior.floating,
                                    backgroundColor: Colors.transparent,
                                    width: 500,
                                    content: AwesomeSnackbarContent(
                                      title: 'Error en el RFC Moral',
                                      message: 'Te faltan ${(12 - (digit))}' +
                                          ' digitos en el RFC Moral',
                                      contentType: ContentType.failure,
                                    ),
                                  );

                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                } else {
                                  RFC_Moral(curpController.text
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
                  if (_currentSelectedValue == "Fisica" &&
                      _currentSelectedValueCURP == "RFC"  && curpController.text.toString() != "" )
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
                  if (_currentSelectedValue == "Fisica" &&
                      _currentSelectedValueCURP != "RFC" && curpController.text.toString() != "" && entidad.toString() != "Entidad de registro" &&
                          entidad.toString() != "null")
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
                                      title: 'No escribiste la Curp! ',
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
                  SizedBox(height: 25.0),
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

                              // Send_RFC_CURP(
                              //     _currentSelectedValue.toString().toUpperCase(),
                              //     curpController.text.toString().toUpperCase(),
                              //     entidad.toString(),
                              //     ConReverso.toString());
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  TextEditingController curpController = TextEditingController();
  TextEditingController etadoController = TextEditingController();

  bool tappedYes = false;
  String Token = "";
  Send_RFC_CURP(String curp, search, clasification) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Token = prefs.getString('token');
    var headers = {'x-access-token': Token, 'Content-Type': 'application/json'};
    var request = http.Request('POST',
        Uri.parse('https://actasalinstante.com:3030/api/robots/services/new/'));
    request.body = json.encode({
      "data": {"data": curp, "search": search, "clasification": clasification},
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
      print(curpController.text.toString().toUpperCase() +
          _currentSelectedValueCURP.toString() +
          _currentSelectedValue);
      Send_RFC_CURP(
          curpController.text.toString().toUpperCase(),
          _currentSelectedValueCURP.toString().toUpperCase(),
          _currentSelectedValue.toString().toUpperCase());
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

  RFC(String rfcs) {
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
      print(curpController.text.toString().toUpperCase() +
          _currentSelectedValueCURP.toString().toUpperCase() +
          _currentSelectedValue.toString().toUpperCase());
      //  Send_RFC_CURP(curpController.text.toString().toUpperCase());
    } else {
      showcurp();

      resultado = "RFC inválido";
    }
    print(resultado);
    print(rfcs);
  }

  RFC_Moral(String rfcs) {
    // " ^([A-ZÑ\x26]{3,4}([0-9]{2})(0[1-9]|1[0-2])(0[1-9]|1[0-9]|2[0-9]|3[0-1])[A-Z|\d]{3})\$"
    const String rfcRegexPattern =
        "^(([A-ZÑ&]{3})([0-9]{2})([0][13578]|[1][02])(([0][1-9]|[12][\\d])|[3][01])([A-Z0-9]{3}))|" +
            "(([A-ZÑ&]{3})([0-9]{2})([0][13456789]|[1][012])(([0][1-9]|[12][\\d])|[3][0])([A-Z0-9]{3}))|" +
            "(([A-ZÑ&]{3})([02468][048]|[13579][26])[0][2]([0][1-9]|[12][\\d])([A-Z0-9]{3}))|" +
            "(([A-ZÑ&]{3})([0-9]{2})[0][2]([0][1-9]|[1][0-9]|[2][0-8])([A-Z0-9]{3}))\$";
    ;
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
      print(curpController.text.toString().toUpperCase() +
          _currentSelectedValueCURP.toString().toUpperCase() +
          _currentSelectedValue.toString().toUpperCase());
      //  Send_RFC_CURP(curpController.text.toString().toUpperCase());
    } else {
      showcurp();

      resultado = "RFC inválido";
    }
    print(resultado);
    print(rfcs);
  }

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

  int entidadValue = 0;
  var entidad;
  String bdEstado;

  var nose;
  onChangeCurp(String curp) {
    if (curp.length == 18) {
      curpController.text = curp;

      var res = curp[11] + curp[12];
      //  print(res.toString().toUpperCase());
      //  print(entidad);
      switch (res.toString().toUpperCase()) {
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
            // print(entidadValue);
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
            entidad = 'VERACRUZ';
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
      setState(() {
        entidad = 'Entidad de registro';
      });
    }
  }
}
