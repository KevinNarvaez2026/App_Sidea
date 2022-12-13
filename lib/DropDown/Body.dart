import 'dart:convert';
import 'dart:io';
import 'package:app_actasalinstante/Detalles/profile_page.dart';
import 'package:app_actasalinstante/NavBar.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:app_actasalinstante/Widgets/carousel_example.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../FlatMessage/Message.dart';
import '../LoginView/api/ProgressHUD.dart';
import '../RFCDescargas/services/Variables.dart';
import '../SplashScreen/Splashscreen1.dart';
import '../views/controller/controller.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_html/flutter_html.dart';

import '../views/homepage.dart';
import 'Descargar_actas/Descargar_acta.dart';

enum ViewDialogsAction { yes, no }

class Body extends StatefulWidget {
  const Body({key}) : super(key: key);
  @override
  _BodyState createState() => _BodyState();
}
// Puedes pasar cualquier objeto al parámetro `arguments`. En este ejemplo, crea una
// clase que contiene ambos, un título y un mensaje personalizable.

class _BodyState extends State<Body> {
  String title;
  TextEditingController ActoController = TextEditingController();
  TextEditingController curpController = TextEditingController();
  TextEditingController etadoController = TextEditingController();
  //TextEditingController prefereneController = TextEditingController();
  var Limite;
  Send_RFC_CURP(String acto, curp, etado, preferences) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Token = prefs.getString('token');
    var headers = {'x-access-token': Token, 'Content-Type': 'application/json'};
    var request = http.Request('POST',
        Uri.parse('https://actasalinstante.com:3030/api/robots/services/new/'));
    request.body = json.encode({
      "data": {
        "type": "CURP",
        "metadata": {"type": acto, "state": etado, "curp": curp},
        "preferences": preferences
      },
      "source": "actas"
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    print(await response.stream.bytesToString());
    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());

      var snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Acta enviada!',
          message: 'Revisa la vista de actas',
          contentType: ContentType.success,
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => NavBar()));
    } else if (response.statusCode == 401) {
      print(await response.stream.bytesToString());

      ShowLimitUser();
    } else if (response.statusCode == 500) {
      print(await response.stream.bytesToString());
      ShowNotSistema();
    } else if (response.statusCode == 403) {
      print(await response.stream.bytesToString());
      ShowServiceActaOrRFC();
    } else {
      print(response.reasonPhrase);
    }
  }

  @override
  void initState() {
    super.initState();
    GetNames();
    Lenguaje();
  }

  String user = "";
  GetNames() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      user = prefs.getString('username');
    });
  }

  Lenguaje() async {
    languages = List<String>.from(await flutterTts.getLanguages);
    setState(() {});
  }

  FlutterTts flutterTts = FlutterTts();
  TextEditingController controller = TextEditingController();

  double volume = 1.0;
  double pitch = 1.0;
  double speechRate = 0.5;
  List<String> languages;
  String langCode = "es-AR";
  //VOICE INICIO
  void initSetting() async {
    // await flutterTts.setVolume(volume);
    // await flutterTts.setPitch(pitch);
    // await flutterTts.setSpeechRate(speechRate);
    await flutterTts.setLanguage(langCode);
  }

  void _speak(voice) async {
    initSetting();
    await flutterTts.speak(voice);
  }

  void _stop() async {
    await flutterTts.stop();
  }

  Send_FOLIO(String type, String data, String estado, int preferencess) async {
    if (preferencess == 2 && estado == 'NACIDO EN EL EXTRANJERO' ||
        preferencess == 3 && estado == 'NACIDO EN EL EXTRANJERO') {
      _speak(
          'Las actas de, NACIDO EN EL EXTRANJERO solo se pueden solicitar de forma simple');
      AwesomeDialog(
        context: context,
        dialogType: DialogType.ERROR,
        animType: AnimType.BOTTOMSLIDE,
        title: 'Actas al instante',
        desc: 'NO APLICA PARA ACTAS DEL EXTRANJERO',
        btnCancelOnPress: () {},
        btnOkOnPress: () {},
      )..show();
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      Token = prefs.getString('token');

      var headers = {
        'Content-Type': 'application/json',
        'x-access-token': Token
      };
      var Body = jsonEncode({
        "type": type,
        "search": "CURP",
        "data": data,
        "estado": estado,
        "preferences": preferencess.toInt()
      });

      var response = await post(
          Uri.parse('https://actasalinstante.com:3030/api/services/actas/new/'),
          body: Body,
          headers: headers);
      //  Show_cargando();
      var Req = jsonDecode(response.body.toString());
      print(Req);
      if (response.statusCode == 200) {
        var Req = jsonDecode(response.body.toString());
        print(Req);

        if (Req['error'] == 'Contactar al administrador') {
          ShowNotSistema();
          print('error');
        } else if (Req['error'] != 'Contactar al administrador') {
          SharedPreferences set_acta = await SharedPreferences.getInstance();

          if (Req['tipo'] == 'Matrimonio' || Req['tipo'] == 'MAmTRIMONIO') {
            set_acta.setString('curp', Req['curp']);

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => D_Actas(),
              ),
            );
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => D_Actas(),
              ),
            );
          } else {
            set_acta.setString('id', Req['id']);
            set_acta.setString('tipo', Req['tipo']);
            set_acta.setString('busqueda', Req['busqueda']);
            set_acta.setString('cadena', Req['cadena']);
            set_acta.setString('curp', Req['curp']);
            set_acta.setString('nombres', Req['nombres']);
            set_acta.setString('apellidos', Req['apellidos']);
            set_acta.setString('estado', Req['estado']);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => D_Actas(),
              ),
            );
          }

          setState(() {
            isApiCallProcess = false;
          });
        }

        // var snackBar = SnackBar(
        //   elevation: 0,
        //   behavior: SnackBarBehavior.floating,
        //   backgroundColor: Colors.transparent,
        //   content: AwesomeSnackbarContent(
        //     title: 'Acta enviada!',
        //     message: 'Revisa la vista de actas',
        //     contentType: ContentType.success,
        //   ),
        // );

        // ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else if (response.statusCode == 404) {
        show_acta_NotFound();
        _speak('Tu acta solicitada, no se encuentra en el sistema');
        print(response.statusCode);
      } else if (response.statusCode == 401) {
        print(Req['message']);
        if (Req['message'] == 'Session Closed!') {
          _speak('Parece que a ocurrido un error,' +
              ',Cierra y abre sesion nuevamente,, si el problema persiste, contacta al administrador');
        } else {
          ShowServiceActaOrRFC();
        }

        //
        //  ShowLimitUser();
      } else if (response.statusCode == 500) {
        _speak('No hay sistema');
        ShowNotSistema();
      } else if (response.statusCode == 403) {
        ShowLimitUser();
        _speak('Llegaste al limite de solicitudes, contacta al administrador');
      } else {
        print(response.reasonPhrase);
      }
    }
  }

  show_acta_NotFound() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.ERROR,
      animType: AnimType.BOTTOMSLIDE,
      title: 'Actas al instante',
      desc: 'Acta no encontrada',
      btnCancelOnPress: () {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) => Body()));
      },
      btnOkOnPress: () {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) => Body()));
      },
    )..show();
  }

  Show_cargando() {
    setState(() {
      isApiCallProcess = true;
    });
    // _speak('Solicitando acta, espere un momento');
    var snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: 'Solicitando Acta',
        message: 'Espere un momento',
        contentType: ContentType.help,
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  // Send_FOLIO(String type, String data, String estado, int preferencess) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   Token = prefs.getString('token');
  //   var headers = {'x-access-token': Token, 'Content-Type': 'application/json'};
  //   var request = http.Request('POST',
  //       Uri.parse('https://actasalinstante.com:3030/api/services/actas/new/'));
  //   request.body = json.encode({
  //     "type": type,
  //     "search": "CURP",
  //     "data": data,
  //     "estado": estado,
  //     "preferences": preferencess.toInt()
  //   });
  //   request.headers.addAll(headers);

  //   http.StreamedResponse response = await request.send();

  //   if (response.statusCode == 200) {

  //        SharedPreferences set_acta = await SharedPreferences.getInstance();

  //          set_acta.setString('token', data['token']);
  //       set_acta.setString('username', data['username']);

  //     print(await response.stream.bytesToString());

  //     // Navigator.pushReplacement(context,
  //     //     MaterialPageRoute(builder: (BuildContext context) => NavBar()));
  //   } else if (response.statusCode == 401) {
  //     print(await response.stream.bytesToString());

  //     ShowLimitUser();
  //   } else if (response.statusCode == 500) {
  //     print(await response.stream.bytesToString());
  //     ShowNotSistema();
  //   } else if (response.statusCode == 403) {
  //     print(await response.stream.bytesToString());
  //     ShowServiceActaOrRFC();
  //   } else {
  //     print(response.reasonPhrase);
  //   }
  // }

  bool tappedYes = false;
  String Token = "";

  ShowServiceActaOrRFC() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.ERROR,
      animType: AnimType.BOTTOMSLIDE,
      title: 'Actas al instante',
      desc:
          'No tienes habilitado el servicio de Actas \n Contacta al Administrador',
      btnCancelOnPress: () {
        //  Navigator.of(context).pop(true);
      },
      btnOkOnPress: () {},
    )..show();
  }

  ShowLimitUser() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.ERROR,
      animType: AnimType.BOTTOMSLIDE,
      title: 'Actas al instante',
      desc: 'Llegaste al limite de solicitudes \n Contacta al Administrador',
      btnCancelOnPress: () {
        //  Navigator.of(context).pop(true);
      },
      btnOkOnPress: () {},
    )..show();
  }

  ShowNotSistema() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    prefs.remove('username');
    await Future.delayed(Duration(seconds: 2));
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext ctx) => SplashScreen()));

    AwesomeDialog(
      context: context,
      dialogType: DialogType.ERROR,
      animType: AnimType.BOTTOMSLIDE,
      title: 'Actas al instante',
      desc: 'No hay sistema ',
      btnCancelOnPress: () {
        //  Navigator.of(context).pop(true);
      },
      btnOkOnPress: () {},
    )..show();
  }

  bool isApiCallProcess = false;
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
                  child: Image.asset('assets/MATRIMONIO.jpg',
                      width: 312.0, height: 150.0),
                ),
              ),
            ),
          ]),
          actions: <Widget>[
            SizedBox(height: 8),
            new Center(
                child: Text(
              '😡Error de Formato!😡\n' +
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
                            message: 'Revise su curp: ' +
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

  CURP(String curps) {
    final _controller = Get.find<Controller>();
    var re = new RegExp(
      r"^([A-Z][AEIOUX][A-Z]{2}\d{2}(?:0[1-9]|1[0-2])(?:0[1-9]|[12]\d|3[01])[HM](?:AS|B[CS]|C[CLMSH]|D[FG]|G[TR]|HG|JC|M[CNS]|N[ETL]|OC|PL|Q[TR]|S[PLR]|T[CSL]|VZ|YN|ZS)[B-DF-HJ-NP-TV-Z]{3}[A-Z\d])(\d)$",
      caseSensitive: false,
      multiLine: false,
    );
    const String curpRegexPattern = "[A-Z]{1}[AEIOU]{1}[A-Z]{2}[0-9]{2}" +
        "(0[1-9]|1[0-2])(0[1-9]|1[0-9]|2[0-9]|3[0-1])" +
        "[HM]{1}" +
        "(AS|BC|BS|CC|CS|CH|CL|CM|DF|DG|GT|GR|HG|JC|MC|MN|MS|NT|NL|OC|PL|QT|QR|SP|SL|SR|TC|TS|TL|VZ|YN|ZS|NE)" +
        "[B-DF-HJ-NP-TV-Z]{3}" +
        "[0-9A-Z]{1}[0-9]{1}\$";
    // String curpARevisar = "estodaerror";
    // String curpARevisar2 = "SIHC400128HDFLLR01";

    String resultado = "";
    if (re.hasMatch(curps)) {
      resultado = "La curp es válido";

      /* SHOW HTML*/

      showAlert();
    } else {
      _controller.error();
      showcurp();

      // var snackBar = SnackBar(
      //   elevation: 0,
      //   behavior: SnackBarBehavior.floating,
      //   backgroundColor: Colors.transparent,
      //   content: AwesomeSnackbarContent(
      //     title: '😡Error de formato!😡',
      //     message: 'Revise su curp: ' + curps,
      //     contentType: ContentType.failure,
      //   ),
      // );

      // ScaffoldMessenger.of(context).showSnackBar(snackBar);

      resultado = "curp inválido";
    }
    print(resultado);
    print(curps);
  }
  // curpValida( String curp) {

  //   var re =
  //           "/^([A-Z][AEIOUX][A-Z]{2}\d{2}(?:0[1-9]|1[0-2])(?:0[1-9]|[12]\d|3[01])[HM](?:AS|B[CS]|C[CLMSH]|D[FG]|G[TR]|HG|JC|M[CNS]|N[ETL]|OC|PL|Q[TR]|S[PLR]|T[CSL]|VZ|YN|ZS)[B-DF-HJ-NP-TV-Z]{3}[A-Z\d])(\d)/",
  //       validado = curp.match(re);

  //   if (!validado) //Coincide con el formato general?
  //     return false;

  //   //Validar que coincida el dígito verificador
  //   digitoVerificador(String curp17) {
  //     //Fuente https://consultas.curp.gob.mx/CurpSP/
  //     var diccionario = "0123456789ABCDEFGHIJKLMNÑOPQRSTUVWXYZ",
  //         lngSuma = 0.0,
  //         lngDigito = 0.0;
  //     for (var i = 0; i < 17; i++)
  //       lngSuma = lngSuma + diccionario.indexOf(curp17[i]) * (18 - i);
  //     lngDigito = 10 - lngSuma % 10;
  //     if (lngDigito == 10) return 0;
  //     return lngDigito;
  //   }

  //   if (validado[2] != digitoVerificador(validado[1])) return false;

  //   return true; //Validado
  // }

  int simple = 1;
  int ConReverso = 2;
  int ConReversoyFolio = 3;
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
          contentPadding: EdgeInsets.all(90.0),
          alignment: Alignment.center,

          title: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Material(
              child: InkWell(
                onTap: () {
                  Send_FOLIO(
                      _currentSelectedValue.toString().toUpperCase(),
                      curpController.text.toString(),
                      entidad.toString(),
                      simple);
                  Show_cargando();

                  // Send_RFC_CURP(
                  //     _currentSelectedValue.toString().toUpperCase(),
                  //     curpController.text.toString().toUpperCase(),
                  //     entidad.toString(),
                  //     simple.toString());
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Image.asset('assets/background.png',
                      width: 100.0, height: 150.0),
                ),
              ),
            ),
            Expanded(child: SizedBox.shrink()),
            Material(
              child: InkWell(
                onTap: () {
                  Send_FOLIO(
                      _currentSelectedValue.toString().toUpperCase(),
                      curpController.text.toString(),
                      entidad.toString(),
                      ConReverso);
                  Show_cargando();

                  // Send_RFC_CURP(
                  //     _currentSelectedValue.toString().toUpperCase(),
                  //     curpController.text.toString().toUpperCase(),
                  //     entidad.toString(),
                  //     ConReverso.toString());
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Image.asset('assets/welcome.png',
                      width: 100.0, height: 150.0),
                ),
              ),
            ),
            Expanded(child: SizedBox.shrink()),
            Material(
              child: InkWell(
                onTap: () {
                  Send_FOLIO(
                      _currentSelectedValue.toString().toUpperCase(),
                      curpController.text.toString(),
                      entidad.toString(),
                      ConReversoyFolio);
                  Show_cargando();
                  // Send_RFC_CURP(
                  //     _currentSelectedValue.toString().toUpperCase(),
                  //     curpController.text.toString().toUpperCase(),
                  //     entidad.toString(),
                  //     ConReversoyFolio.toString());
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Image.asset('assets/logo.png',
                      width: 100.0, height: 150.0),
                ),
              ),
            ),
          ]),
          //content: Text("Are You Sure Want To Proceed?"),

          actions: <Widget>[
            new Center(
                child: Text(
              'SELECCIONA LA FORMA DEL ACTA',
              style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'avenir',
                  fontWeight: FontWeight.w800,
                  color: Colors.black),
              overflow: TextOverflow.ellipsis,
            )),
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
                        Send_FOLIO(
                            _currentSelectedValue.toString().toUpperCase(),
                            curpController.text.toString(),
                            entidad.toString(),
                            simple);
                        Show_cargando();

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
                        Send_FOLIO(
                            _currentSelectedValue.toString().toUpperCase(),
                            curpController.text.toString(),
                            entidad.toString(),
                            ConReverso);
                        Show_cargando();

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
                        Send_FOLIO(
                            _currentSelectedValue.toString().toUpperCase(),
                            curpController.text.toString(),
                            entidad.toString(),
                            ConReversoyFolio);
                        Show_cargando();
                      },
                      child: Text("Con Reverso y Folio"),
                      textColor: Colors.white,
                    ),
                    Icon(
                      Icons.amp_stories_sharp,
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

  String label = "Seleciona el Acto Registral";
  String curp = "Ingresa tu Curp";
  String estado = "Seleciona el Estado\n";
  var _currentSelectedValue;
  var _estadoselect;

  var _currencies = ["Nacimiento", "Defuncion", "Matrimonio", "Divorcio"];
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

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: _provinceContainers(context),
      inAsyncCall: isApiCallProcess,
      opacity: 0.3,
      key: Key(isApiCallProcess.toString()),
      valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
    );
  }

  final Color color = HexColor('#D61C4E');
  @override
  Widget _provinceContainers(BuildContext context) {
    var crupestado;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: color,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          '' + user.toString(),
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
                            "Actas",
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Solicitar acta",
                            style: TextStyle(
                                fontSize: 15, color: Colors.grey[700]),
                          )
                        ],
                      ),

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40),
                        child: Column(
                          children: <Widget>[
                            FormField<String>(
                              builder: (FormFieldState<String> state) {
                                return InputDecorator(
                                  decoration: InputDecoration(
                                      label: Text(label.toString()),
                                      errorStyle: TextStyle(
                                          color: Colors.redAccent,
                                          fontSize: 16.0),
                                      hintText: 'Please select expense',
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0))),
                                  isEmpty: _currentSelectedValue == '',
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: _currentSelectedValue,
                                      isDense: true,
                                      onChanged: (String newValue) {
                                        setState(() {
                                          _currentSelectedValue = newValue;
                                          state.didChange(newValue);
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
                            // TextFormField(

                            //   controller: ActoController,

                            //   pohjhjhhdecoration: InputDecoration(hintText: 'Acto registral'.toUpperCase() ),
                            // ),
                            SizedBox(
                              //Use of SizedBox
                              height: 5,
                            ),

                            TextFormField(
                              controller: curpController,
                              validator: (input) =>
                                  input == '' ? "Ingresa un usuario" : null,
                              decoration: InputDecoration(
                                  label: Text(curp.toString()),
                                  hintText: 'curp'.toUpperCase()),
                              maxLength: 18,
                              onSaved: onChangeCurp(
                                  curpController.text.toString().toUpperCase()),

                              //  obscureText: true,
                            ),
                            // ),
                            SizedBox(
                              //Use of SizedBox
                              height: 10,
                            ),

                            // FormField<String>(
                            //   builder: (FormFieldState<String> state) {
                            //     return InputDecorator(
                            //       decoration: InputDecoration(
                            //           label: Text(
                            //               estado.toString() + entidad.toString()),
                            //           errorStyle: TextStyle(
                            //               color: Colors.redAccent, fontSize: 16.0),
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
                            //               entidad = newValue;
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
                            // T
                            if (entidad.toString() != "Entidad de registro")
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
                            if (entidad.toString() == "Entidad de registro")
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

                            // inputFile(label: "Correo"),
                            // inputFile(label: "Contraseña", obscureText: true)
                          ],
                        ),
                      ),
                      if (entidad.toString() == "Entidad de registro")
                        new Center(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(82),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 21, vertical: 8),
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
                      if (entidad.toString() != "Entidad de registro")
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
                                } else if (_currentSelectedValue == null) {
                                  var snackBar = SnackBar(
                                    elevation: 10,
                                    behavior: SnackBarBehavior.floating,
                                    backgroundColor: Colors.transparent,
                                    width: 500,
                                    content: AwesomeSnackbarContent(
                                      title: 'Te Falta El Acto Registral',
                                      message: '' + 'Error ',
                                      contentType: ContentType.failure,
                                    ),
                                  );

                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                } else {
                                  //   CURP(curpController.text.toString().toUpperCase());
                                  //print(curpController.text.toString().toUpperCase());
                                  CURP(curpController.text
                                      .toString()
                                      .toUpperCase());
                                  print(_currentSelectedValue
                                          .toString()
                                          .toUpperCase() +
                                      curpController.text
                                          .toString()
                                          .toUpperCase() +
                                      entidad.toString());
                                  print(entidad.toString());
                                }
                                // String ex1 = "No value selected";
                                //print(_estadoselect.toString());

                                // actas(
                                //     _currentSelectedValue.toString().toUpperCase(),
                                //     curpController.text.toString().toUpperCase(),
                                //     _estadoselect.toString().toUpperCase());

//                           print(_currentSelectedValue.toString().toUpperCase() +
//                               curpController.text.toString().toUpperCase() +
//                               _estadoselect.toString().toUpperCase());
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
      entidad = 'Entidad de registro';
    }
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
