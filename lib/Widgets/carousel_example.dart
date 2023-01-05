import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;
import 'package:app_actasalinstante/Detalles/profile_page.dart';
import 'package:app_actasalinstante/DropDown/Body.dart';
import 'package:app_actasalinstante/DropDown/TransicionActas.dart';
import 'package:app_actasalinstante/RFCDescargas/views/homepage.dart';
import 'package:app_actasalinstante/SplashScreen/Splashscreen1.dart';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

import 'package:check_vpn_connection/check_vpn_connection.dart';

import 'package:flutter/material.dart';
import 'package:flutter_dropdown_alert/alert_controller.dart';
import 'package:flutter_dropdown_alert/model/data_alert.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart';
import 'package:http/io_client.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../ColorScheme.dart';
import '../DropDown/Descargar_actas/animation/FadeAnimation.dart';
import '../DropDown/DropDown.dart';
import '../Inicio/InicioActas.dart';
import '../LoginView/api/ProgressHUD.dart';
import '../LoginView/api/model/login_model.dart';
import '../Merry/snow-animation.dart';
import '../NavBar.dart';
import '../New_Home/theme/colors/light_colors.dart';
import '../New_Home/widgets/active_project_card.dart';
import '../RFC/RfcBody.dart';
import '../RFC/Transicion.dart';
import '../RFCDescargas/services/Variables.dart';
import '../Search/serach.dart';
import '../SplashScreen/SplashLogin.dart';
import '../UserProfile/Profile.dart';
import '../services/SearchapiACTAS/Api_service.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/SearchapiACTAS/user_model.dart';
import '../views/controller/controller.dart';
import '../views/homepage.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'dart:typed_data';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:pie_chart/pie_chart.dart';

class CarouselExample extends StatefulWidget {
  const CarouselExample({Key key}) : super(key: key);
  @override
  _CarouselExampleState createState() => _CarouselExampleState();
}

LoginRequestModel loginRequestModel;

enum LegendShape { circle, rectangle }

class _CarouselExampleState extends State<CarouselExample>
    with SingleTickerProviderStateMixin {
  List<Contact> _contacts;

  IO.Socket socket;
  @override
  void initState() {
    super.initState();
    Inicial_pORCENTAJE();
    Check_uPDATE();
    Lenguaje();
AlertController.onTabListener(
        (Map<String, dynamic> payload, TypeAlert type) {
      print("$payload - $type");
    });
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
  }

  Map<String, double> dataMap = {
    "Actas limite": 5,
    "Actas actual": 5,
    "Almacenamiento": 3,
  };
  Inicial_pORCENTAJE() {
    setState(() {
      limite = 0.0;
      current = 0.0;
    });
  }

  var ids_user;
  var nombre;
  var limite;
  var current;

  Find_User(user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, String> mainheader = new Map();
    mainheader["content-type"] = "application/json";
    mainheader['private-key'] =
        'SgVkYp2s5v8y/B?E(H+MbQeThWmZq4t6w9z\$C&F)J@NcRfUjXn2r5u8x!A%D*G-KaPdSgVkYp3s6v9y\$B?E(H+MbQeThWmZq4t7w!z%C*F)J@NcRfUjXn2r5u8x/A?D(';
    var response = await get(
      Uri.parse('https://actasalinstante.com:3030/api/user/limits/search/' +
          user.toString()),
      headers: mainheader,
    );
    var GetRobots = json.decode(response.body.toString());
    print("hola");

    //vista = true;
    if (response.statusCode == 200) {
      setState(() {
        isApiCallProcess = false;
      });

      for (var i = 0; i < GetRobots.length; i++) {
        print(GetRobots[i]);
        setState(() {
          ids_user = GetRobots[i]['id'];
          nombre = GetRobots[i]['username'];
          limite = GetRobots[i]['actas_limit'] / 100000;
          current = GetRobots[i]['actas_current'] / 100000;
        });
      }
    } else if (response.statusCode == 401) {
      Error_401();
      prefs.remove('token');
      prefs.remove('username');
      print("401");
      await Future.delayed(Duration(seconds: 4));
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext ctx) => SplashScreen()));
    }
  }

//FUNCION PARA CHECAR EL BUILD DE LA APP
  Check_uPDATE() {
    setState(() {
      isApiCallProcess = true;
    });
    json_version();
  }

  var version;
//CHECADOR DE VERSION DE LA APP POR MEDIO DE UNA ARCHIVO JSON
  bool isApiCallProcess = false;
  json_version() async {
    print("Token: " + Token);
    try {
      var json_Ver = jsonEncode({"version": "0.20.0"});
      print(json_Ver.toString());
      SharedPreferences prefs = await SharedPreferences.getInstance();

      setState(() {
        Token = prefs.getString('token');
      });
      Map<String, String> mainheader = new Map();
      mainheader["content-type"] = "application/json";
      mainheader['x-access-token'] = Token;

      var response = await get(
          Uri.parse('https://actasalinstante.com:3030/api/app/version/'),
          headers: mainheader);
      var datas = json.decode(response.body);
  
      if (response.statusCode == 200) {
        setState(() {
          isApiCallProcess = false;
        });

        datas['version'];
        print(datas['version']);
        if (datas['version'] != '0.20.0') {
          print("Debe actualizar su version");

          AwesomeDialog(
            context: context,
            dialogType: DialogType.WARNING,
            animType: AnimType.BOTTOMSLIDE,
            title: 'Actas al instante',
            desc: user.toString() +
                ' Tienes una versión desactualizada\n Presione Ok para descargar la nueva version',
            btnCancelOnPress: () {
              exit(0);
            },
            btnOkOnPress: () {
              _launchURL();
            },
          )..show();
          version = datas['version'];
        } else {
          setState(() {
            isApiCallProcess = false;
          });
          version = datas['version'];
          print(version);
             
          _runAnimation();
          GetImages();
          GetNames();
          getToken();
          Check_VPN();
          _getCurrentLocation();
        }
      }
    } catch (e) {
      print(e);
    }
  }

//LINK PARA DESCARGAR UNA NUEVA VERIOSN DE LA APP
  _launchURL() async {
    const url = 'https://actasalinstante.com:3030/api/app/download/';
    if (await launch(url)) {
      await canLaunch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Check_VPN() async {
    if (await CheckVpnConnection.isVpnActive()) {
      // do some action if VPN connection status is true

      var snackBar = SnackBar(
        elevation: 0,
        width: 400,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Desactive su VPN',
          message: 'Porfavor!',
          contentType: ContentType.failure,
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      await Future.delayed(Duration(seconds: 4));
      exit(0);
    } else {}
  }

//GPS
  Position _position;
  var _latitude = "";
  var _longitud = "";
//PUT_GPS
  Put_GPS(String latitude, String longitude) async {
    Map<String, String> mainheader = new Map();
    mainheader["content-type"] = "application/json";
    mainheader['x-access-token'] = Token;
    Map<String, dynamic> body = {
      'latitud': latitude,
      'longitud': longitude,
    };

    var response = await post(
        Uri.parse('https://actasalinstante.com:3030/api/user/place/'),
        headers: mainheader,
        body: json.encode(body));
    var datas = json.decode(response.body);

    // setState(() {
    //   data = resBody;

    // });

    if (response.statusCode == 200) {
      //_controller.sendNotification();
      datas = jsonDecode(response.body);

      // } else if (response.statusCode == 401) {
      //   SharedPreferences prefs = await SharedPreferences.getInstance();
      //   prefs.remove('token');
      //   prefs.remove('username');
      //   await Future.delayed(Duration(seconds: 10));

      //   exit(0);
      // } else {
    }

    // return results;
  }

//GPS
  _getCurrentLocation() async {
    Position position = await _determinePosition();

    _latitude = position.latitude.toString();
    _longitud = position.longitude.toString();
    print(_latitude + _longitud);
    Put_GPS(_latitude, _longitud);
  }

  Future<Position> _determinePosition() async {
    LocationPermission permission;

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      gps();
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        gps();
        return Future.error('Location Permissions are denied');
      }
    }

    return await Geolocator.getCurrentPosition();
  }

  gps() async {
    // _speak(user.toString() +
    //     ",Es muy importante, dar en permitir, a todos los permisos que le solicite la app ");
    await Future.delayed(Duration(seconds: 10));
    exit(0);
  }

//NOTIFICAIONES
  Notification() {
    socket = IO.io("https://actasalinstante.com:3030/");
    socket.connect();
    connectAndListen();
  }

  int index;
  void connectAndListen() {
    socket.onConnect((data) => print(data.toString()));
    socket.onDisconnect((data) => print("Descontectado " + data.toString()));
    socket.onError((data) => print("Error " + data.toString()));
    socket.onConnecting((data) => print(data.toString()));
    socket
        .onConnectError((data) => print("Conectado Error " + data.toString()));
    socket.onConnectTimeout(
        (data) => print("El tiempo se acaba Bob Esponja " + data.toString()));

    socket.on('notification', (value) {
      print('notification ${value.toString()}');
    });
  }

  String user = "";
  GetNames() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      user = prefs.getString('username');
    });
    Find_User(user);
  }

  String Token = "";
  getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      Token = prefs.getString('token');
    });
  }

//GALERIA
  UploadGallery() async {
    final pickedFile = await _picker.getImage(
      source: ImageSource.gallery,
    );

    setState(() {
      _imageFile = pickedFile;
    });

    var headers = {'x-access-token': Token};
    var request = http.MultipartRequest('POST',
        Uri.parse('https://actasalinstante.com:3030/api/user/avatar/up/'));

    request.files.add(await http.MultipartFile.fromPath(
        'avatar', _imageFile.path.toString()));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }

//CAMARA
  UploadCamera() async {
    final pickedFile = await _picker.getImage(
      source: ImageSource.camera,
    );

    setState(() {
      _imageFile = pickedFile;
    });
    var headers = {'x-access-token': Token};
    var request = http.MultipartRequest('POST',
        Uri.parse('https://actasalinstante.com:3030/api/user/avatar/up/'));
    request.files.add(await http.MultipartFile.fromPath(
        'avatar', _imageFile.path.toString()));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }

  var imagen;
//YA SIRVE :/
  Future<String> GetImages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Token = prefs.getString('token');
    Map<String, String> mainheader = new Map();
    //mainheader["content-type"] = 'image/jpeg';
    mainheader['x-access-token'] = Token;
    var response = await get(
      Uri.parse('https://actasalinstante.com:3030/api/user/avatar/'),
      headers: mainheader,
    );
    final bytes = response.bodyBytes;

    print(response.statusCode);
    if (response.statusCode == 200) {
      setState(() {
        imagen = bytes;
      });
    }

    if (response.statusCode == 401) {
      Error_401();
      prefs.remove('token');
      prefs.remove('username');

      await Future.delayed(Duration(seconds: 4));
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext ctx) => SplashScreen()));
    }
    return (bytes != null ? base64Encode(bytes) : null);
  }

  Error_401() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            scrollable: true,
            title: Center(
                child: Text(
              'Caduco tu Sesion ' + user.toString(),
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            )),
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                child: Column(
                  children: <Widget>[
                    Material(
                      child: InkWell(
                        onTap: () {},
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: Image.asset('assets/ERROR_404.gif',
                              width: 300.0, height: 300.0),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            actions: [
              // RaisedButton(
              //     child: Text("Submit"),
              //     onPressed: () {
              //       // your code
              //     })
            ],
          );
        });
  }

//Voice
//VOICE
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
  String langCode = "es-US";
  //VOICE INICIO
  void initSetting() async {
    // await flutterTts.setVolume(volume);
    // await flutterTts.setPitch(pitch);
    // await flutterTts.setSpeechRate(speechRate);
    await flutterTts.setLanguage(langCode);
    print(langCode);
  }

  void _speak(voice) async {
    initSetting();
    await flutterTts.speak(voice);
  }

  // Image Name List Here
  var imgList = [
    "assets/NAC.png",
    "assets/DEFUNCION.jpg",
    "assets/matrimonio.png",
  ];
  // final f = new DateFormat('yyyy-MM-dd hh:mm');
// type=${result.type}
  var isFavorite = false.obs;
  int selectedIndex;
  int count;

  showDialogFunc(context, image, data, curp, estado, username, apellidos,
      comments, descarga) {
    return showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: Material(
            type: MaterialType.transparency,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              padding: EdgeInsets.all(15),
              height: 490,
              width: MediaQuery.of(context).size.width * 0.7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.asset(
                      image,
                      width: 200,
                      height: 200,
                    ),
                  ),

                  // Text(
                  //   title,
                  //   style: TextStyle(
                  //     fontSize: 25,
                  //     color: Colors.grey,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  // ),

                  Container(
                    // width: 200,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        data.toString().toUpperCase(),
                        maxLines: 3,
                        style: TextStyle(fontSize: 15, color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    // width: 200,
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Curp: " + curp?.toString(),
                        maxLines: 3,
                        style: TextStyle(fontSize: 15, color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    // width: 200,
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Nombres: " + username?.toString(),
                        maxLines: 3,
                        style: TextStyle(fontSize: 15, color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    // width: 200,
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Apellidos: " + apellidos?.toString(),
                        maxLines: 3,
                        style: TextStyle(fontSize: 15, color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    // width: 200,
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Estado: " + estado?.toString(),
                        maxLines: 3,
                        style: TextStyle(fontSize: 15, color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  if (comments == 'Descargado' && descarga == true)
                    new Center(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(82),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 2),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            MaterialButton(
                              onPressed: () {},
                              child: Text("Abrir"),
                              textColor: Colors.white,
                            ),
                            Icon(
                              Icons.download_done,
                              size: 20,
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
        );
      },
    );
  }

//CUERPO DEL PROGRAMA
  static const duration = Duration(milliseconds: 300);
  String selectedType = "initial";
  String selectedFrequency = "monthly";

  final ImagePicker _picker = ImagePicker();
  PickedFile _imageFile;

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: Carr(context),
      inAsyncCall: isApiCallProcess,
      opacity: 0.4,
      key: Key(isApiCallProcess.toString()),
      valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
    );
  }

  final Color color = HexColor('#D61C4E');
  final Color color_Card = HexColor('#01081f');

  ShowDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            scrollable: true,
            title: Center(
                child: Text(
              'Bienvenido ' + user.toString(),
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            )),
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: 'Sube una foto de perfil'.toString(),
                          icon: Icon(Icons.photo_camera),
                          enabled: false),
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: 'Descarga tus Actas',
                          icon: Icon(Ionicons.documents),
                          enabled: false),
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: 'Descarga tus RFC',
                          icon: Icon(Ionicons.document),
                          enabled: false),
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: 'Descarga tu Corte',
                          icon: Icon(Icons.monetization_on),
                          enabled: false),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              // RaisedButton(
              //     child: Text("Submit"),
              //     onPressed: () {
              //       // your code
              //     })
            ],
          );
        });
  }

  AnimationController _animationController;

  void _runAnimation() async {
    for (int i = 0; i < 3; i++) {
      await _animationController.forward();
      await _animationController.reverse();
    }
  }

  Widget Carr(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          backgroundColor: color,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: Text('Actas Al Instante',
                style: GoogleFonts.lato(
                  textStyle: Theme.of(context).textTheme.headlineMedium,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.italic,
                  color: Colors.white,
                )),
            elevation: 0,
            backgroundColor: color,
          ),
          floatingActionButton: RotationTransition(
            turns: Tween(begin: 0.0, end: -.1)
                .chain(CurveTween(curve: Curves.elasticIn))
                .animate(_animationController),
            child: FloatingActionButton(
              onPressed: () {
                ShowDialog();
                _runAnimation();
                
              },
              child: Icon(
                Icons.notifications_active_rounded,
                color: Colors.white,
                size: 29,
              ),
              backgroundColor: Colors.black,
              tooltip: 'Más Informacion',
              elevation: 5,
              splashColor: Colors.grey,
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // if (_permissionDenied) Center(child: Text('Permiso denegado')),
              // if (_contacts == null) Center(child: CircularProgressIndicator()),
              //IMAGEN D EPERFIL
              imageProfile(),

              new Center(
                child: Text("" + user.toString(),
                    style: GoogleFonts.lato(
                      textStyle: Theme.of(context).textTheme.headlineMedium,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.italic,
                      color: Colors.white,
                    )),
              ),
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40)),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 4,
                        offset: Offset(4, 8), // Shadow position
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (version != '0.20.0')
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 40, vertical: 15),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  color: Colors.redAccent,
                                ),
                                child: Text(
                                  "debe de actualizar la app".toUpperCase(),
                                  style: GoogleFonts.lato(
                                    textStyle:
                                        Theme.of(context).textTheme.headline4,
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      if (version == '0.20.0')
                        Container(
                          color: Colors.transparent,
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              //   subheading('Active Projects'),
                              SizedBox(height: 5.0),
                              Row(
                                children: <Widget>[
                                  ActiveProjectsCard(
                                    cardColor: color_Card,
                                    loadingPercent: limite,
                                    title: 'Actas Limite',
                                    subtitle: '',
                                  ),
                                  SizedBox(width: 20.0),
                                  ActiveProjectsCard(
                                    cardColor: color_Card,
                                    loadingPercent: current,
                                    title: 'Actas descargadas',
                                    subtitle: '',
                                  ),
                                ],
                              ),

                              SizedBox(
                                height: 30,
                              ),

                              Row(
                                children: <Widget>[
                                  Container(
                                      decoration: BoxDecoration(
                                        color: color_Card,
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                      ),
                                      margin: EdgeInsets.only(top: 10),
                                      child: SingleChildScrollView(
                                          child: Padding(
                                              padding: EdgeInsets.all(17.0),
                                              child: Column(children: [
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      PageRouteBuilder(
                                                        pageBuilder: (context,
                                                            animation, _) {
                                                          return FadeTransition(
                                                            opacity: animation,
                                                            child: transactas(),
                                                          );
                                                        },
                                                        transitionDuration:
                                                            duration,
                                                        reverseTransitionDuration:
                                                            duration,
                                                      ),
                                                    );
                                                  },
                                                  child: Container(
                                                    margin: EdgeInsets.only(
                                                        bottom: 8),
                                                    height: 100,
                                                    child: Card(
                                                      color: color_Card,
                                                      semanticContainer: true,
                                                      clipBehavior: Clip
                                                          .antiAliasWithSaveLayer,
                                                      child: Image.asset(
                                                        'assets/NEW_Acta.png',
                                                        fit: BoxFit.fill,
                                                      ),
                                                      //shadowColor: Colors.white,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                      ),
                                                      elevation: 0,
                                                      margin:
                                                          EdgeInsets.all(10.0),
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  "Actas",
                                                  style: GoogleFonts.lato(
                                                    textStyle: Theme.of(context)
                                                        .textTheme
                                                        .headlineMedium,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w700,
                                                    fontStyle: FontStyle.italic,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ])))),
                                  SizedBox(width: 25.0),
                                  Container(
                                      decoration: BoxDecoration(
                                        color: color_Card,
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                      ),
                                      margin: EdgeInsets.only(top: 10),
                                      child: SingleChildScrollView(
                                          child: Padding(
                                              padding: EdgeInsets.all(17.0),
                                              child: Column(children: [
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      PageRouteBuilder(
                                                        pageBuilder: (context,
                                                            animation, _) {
                                                          return FadeTransition(
                                                            opacity: animation,
                                                            child: trans(),
                                                          );
                                                        },
                                                        transitionDuration:
                                                            duration,
                                                        reverseTransitionDuration:
                                                            duration,
                                                      ),
                                                    );
                                                  },
                                                  child: Container(
                                                    margin: EdgeInsets.only(
                                                        bottom: 8),
                                                    height: 100,
                                                    child: Card(
                                                      color: color_Card,
                                                      semanticContainer: true,
                                                      clipBehavior: Clip
                                                          .antiAliasWithSaveLayer,
                                                      child: Image.asset(
                                                        'assets/NEW_RFC.png',
                                                        fit: BoxFit.fill,
                                                      ),
                                                      //shadowColor: Colors.white,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                      ),
                                                      elevation: 0,
                                                      margin:
                                                          EdgeInsets.all(10.0),
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  "RFC",
                                                  style: GoogleFonts.lato(
                                                    textStyle: Theme.of(context)
                                                        .textTheme
                                                        .headlineMedium,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w700,
                                                    fontStyle: FontStyle.italic,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ])))),
                                ],
                              ),
                            ],
                          ),
                        ),
                      //                 RotationTransition(
                      //         turns: Tween(begin: 0.0, end: -.1)
                      //             .chain(CurveTween(curve: Curves.elasticIn))
                      //             .animate(_animationController),
                      //         child: FloatingActionButton(
                      //     onPressed: () {
                      //       _runAnimation();
                      //       ShowDialog();
                      //     },

                      //     child: Icon(
                      //       Icons.notifications_active_rounded,
                      //       color: Colors.white,
                      //       size: 29,
                      //     ),
                      //     backgroundColor: Colors.black,
                      //     tooltip: 'Más Informacion',
                      //     elevation: 5,
                      //     splashColor: Colors.grey,
                      //   ),

                      // ),
                      //ESPACIO ENTRE FUNCIONES DE FRONT
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        onWillPop: _onWillPopScope);
  }

  void changeCleaningType(String type) {
    selectedType = type;

    if (selectedType == "RFC") {
      setState(() {
        final snackBar = SnackBar(
          elevation: 6.0,
          backgroundColor: Colors.blueAccent,
          behavior: SnackBarBehavior.floating,
          content: Text(
            "" + selectedType.toString(),
            style: TextStyle(color: Colors.white, fontSize: 18),
            textAlign: TextAlign.center,
          ),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
    }
    if (selectedType == "Actas") {
      setState(() {
        final snackBar = SnackBar(
          elevation: 6.0,
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          content: Text(
            "" + selectedType.toString(),
            style: TextStyle(color: Colors.white, fontSize: 18),
            textAlign: TextAlign.center,
          ),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
    }
  }

//CAMBIO DE ACTAS O RFC
  void changeFrequency(String frequency) {
    selectedFrequency = frequency;
    setState(() {});
  }

  Column extraWidget(String img, String name, bool isSelected) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(shape: BoxShape.circle, color: purple),
              child: Container(
                margin: EdgeInsets.all(17),
                decoration: BoxDecoration(
                    // image: DecorationImage(
                    //   image: AssetImage('asset/image/icons/$img.png'),
                    //   fit: BoxFit.contain
                    // )
                    ),
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: (isSelected == true)
                  ? Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.white),
                      child: Center(
                        child: Icon(
                          Icons.check_circle,
                          color: pink,
                        ),
                      ),
                    )
                  : Container(),
            ),
          ],
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          name,
          style: TextStyle(fontWeight: FontWeight.w500),
        )
      ],
    );
  }

//FUCNION PARA SABER SI ESTA EN ACTAS O RFC
  void OnchangeActas() {
    if (selectedType == "Actas") {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, _) {
            return FadeTransition(
              opacity: animation,
              child: transactas(),
            );
          },
          transitionDuration: duration,
          reverseTransitionDuration: duration,
        ),
      );
    } else if (selectedType == "RFC") {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, _) {
            return FadeTransition(
              opacity: animation,
              child: trans(),
            );
          },
          transitionDuration: duration,
          reverseTransitionDuration: duration,
        ),
      );
    } else {
      var snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Selecciona un servicio!',
          message: 'Actas o RFC!',
          contentType: ContentType.failure,
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

//FUNCION PARA IMAGEN DE PERFIL
  Widget imageProfile() {
    return Center(
      child: Stack(
        children: <Widget>[
          //Image.network("https://actasalinstante.com:3030/api/user/avatar/"),
          if (_imageFile != null)
            CircleAvatar(
              radius: 48.0,
              backgroundImage: _imageFile == null
                  ? AssetImage("assets/loginuser.png")
                  : FileImage(File(_imageFile.path)),
            ),
          if (_imageFile == null)
            ClipRRect(
              borderRadius: BorderRadius.circular(40.0),
              child: CircleAvatar(
                radius: 40.0,
                child: imagen != null
                    ? Image.memory(
                        imagen,
                        height: 150.0,
                        width: 150.0,
                        fit: BoxFit.fill,
                      )
                    : Image.asset(
                        'assets/loginuser.png',
                        height: 100.0,
                        width: 100.0,
                        fit: BoxFit.fill,
                      ),
              ),
            ),

          Positioned(
            bottom: 1.0,
            right: 1.0,
            child: InkWell(
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            leading: new Icon(Icons.camera_alt),
                            title: new Text('Tomar Foto'),
                            onTap: () {
                              UploadCamera();
                              // takePhoto(ImageSource.camera);
                            },
                          ),
                          ListTile(
                            leading: new Icon(Icons.photo),
                            title: new Text('Galeria'),
                            onTap: () {
                              UploadGallery();
                              //takePhoto(ImageSource.gallery);
                            },
                          ),
                          ListTile(
                            leading: new Icon(Icons.person),
                            title: new Text('Cerrar sesion'),
                            onTap: () {
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.QUESTION,
                                animType: AnimType.BOTTOMSLIDE,
                                title: 'Actas al instante',
                                desc: user.toString() +
                                    ' ¿quieres salir de la aplicación?',
                                btnCancelOnPress: () {
                                  //  Navigator.of(context).pop(true);
                                },
                                btnOkOnPress: () async {
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  prefs.remove('token');
                                  prefs.remove('username');
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext ctx) =>
                                              SplashScreen()));

                                  // Navigator.of(context).pushAndRemoveUntil(
                                  //     MaterialPageRoute(
                                  //         builder: (context) => SplashLogin()),
                                  //     (Route<dynamic> route) => false);
                                },
                              )..show();
                            },
                          ),
                        ],
                      );
                    });
                // showModalBottomSheet(
                //   context: context,
                //   builder: ((builder) => bottomSheet()),
                // );
              },
              child: Icon(
                Icons.settings,
                color: Colors.yellowAccent,
                size: 35.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 280.0,
      width: MediaQuery.of(context).size.width,
      //color: Colors.black,
      margin: EdgeInsets.symmetric(
        horizontal: 50,
        vertical: 50,
      ),
      child: Column(
        children: <Widget>[
          new Center(
            child: Text(
              user.toString() + "",
              style: TextStyle(
                  fontSize: 24,
                  fontFamily: 'avenir',
                  fontWeight: FontWeight.w800,
                  color: Colors.redAccent),
            ),
          ),

          new Center(
            child: Text(
              "Elige tu foto de perfil o Cierra sesion",
              style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'avenir',
                  fontWeight: FontWeight.w800,
                  color: Colors.black),
            ),
          ),

          SizedBox(height: 8),
          new Center(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(82),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  MaterialButton(
                    onPressed: () {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.QUESTION,
                        animType: AnimType.BOTTOMSLIDE,
                        title: 'Actas al instante',
                        desc: user.toString() +
                            ' ¿quieres salir de la aplicación?',
                        btnCancelOnPress: () {
                          //  Navigator.of(context).pop(true);
                        },
                        btnOkOnPress: () {
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => SplashLogin()),
                              (Route<dynamic> route) => false);
                        },
                      )..show();
                    },
                    child: Text("Cerrar sesion",
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold)),
                    textColor: Colors.white,
                  ),
                  Icon(
                    Icons.logout,
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
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  MaterialButton(
                    onPressed: () {
                      takePhoto(ImageSource.camera);
                    },
                    child: Text("Tomar foto",
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold)),
                    textColor: Colors.white,
                  ),
                  Icon(
                    Icons.camera_alt,
                    size: 19,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
          // new Center(
          //   child: MaterialButton(
          //     child: Text("Tomar foto"),
          //     textColor: Colors.white,
          //     onPressed: () {
          //       takePhoto(ImageSource.camera);
          //     },
          //     color: Colors.black,
          //   ),
          // ),
          SizedBox(height: 8),
          new Center(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(82),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  MaterialButton(
                    onPressed: () {
                      takePhoto(ImageSource.gallery);
                    },
                    child: Text("Galeria",
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold)),
                    textColor: Colors.white,
                  ),
                  Icon(
                    Icons.photo,
                    size: 19,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
          // new Center(
          //   child: MaterialButton(
          //     child: Text("Seleccionar de galeria"),
          //     textColor: Colors.white,
          //     onPressed: () {
          //       takePhoto(ImageSource.gallery);
          //     },
          //     color: Colors.black,
          //   ),
          // ),
        ],
      ),
    );
  }

//FUNCION PARA TOMAR FOTO
  void takePhoto(ImageSource source) async {
    final pickedFile = await _picker.getImage(
      source: source,
    );
    setState(() {
      _imageFile = pickedFile;
    });
  }

//FUNCION PARA EL BOTON DE RETROCESO
  Future<bool> _onWillPopScope() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.QUESTION,
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
}

class Provinces {
  int id;
  String data;
  String username;
  String apellido1;
  String apellido2;
  String susername;
  String sapellido1;
  String sapellido2;
  String email;
  Object type;
  bool descarga;
  Object metadatatype;
  Object metadata;
  Object metadatacadena;
  Object metadataestado;
  String phone;
  String website;
  DateTime fecha;
  String comments;

  Provinces({
    this.id,
    this.metadatatype,
    this.metadatacadena,
    this.username,
    this.descarga,
    this.apellido1,
    this.apellido2,
    this.susername,
    this.sapellido1,
    this.sapellido2,
    this.email,
    this.comments,
    this.metadataestado,
    this.phone,
    this.website,
    this.fecha,
    this.type,
  });

  Provinces.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    // data = json['metadata']["curp"];
    type = json['type'];
    metadatatype = json['metadata']["type"];
    metadata = json['metadata']["curp"];
    metadatacadena = json['metadata']["cadena"];
    username = json['metadata']['nombre'];
    apellido1 = json['metadata']['primerapellido'];
    apellido2 = json['metadata']['segundoapelido'];
    susername = json['metadata']['snombre'];
    sapellido1 = json['metadata']['sprimerapellido'];
    sapellido2 = json['metadata']['ssegundoapellido'];
    email = json['namefile'];
    fecha = DateTime.parse(json["createdAt"]);

    metadataestado = json['metadata']["state"];
    website = json['url'];
    comments = json['comments'];
    descarga = json['downloaded'] as bool;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['metadata']["type"] = this.metadatatype;
    data['metadata']["curp"] = this.metadata;
    data['metadata']["state"] = this.metadataestado;
    data['metadata']["nombre"] = this.username;
    data['createdAt'] = this.fecha;

    return data;
  }
}
