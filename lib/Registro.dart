import 'dart:convert';
import 'dart:io';
import 'package:app_actasalinstante/NavBar.dart';
import 'package:app_actasalinstante/login.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:check_vpn_connection/check_vpn_connection.dart';
import 'package:flutter/material.dart';
import 'package:app_actasalinstante/Widgets/carousel_example.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:lottie/lottie.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'FlatMessage/Message.dart';
import 'LoginView/api/ProgressHUD.dart';
import 'RFCDescargas/services/Variables.dart';
import 'SplashScreen/Splashscreen1.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http_parser/http_parser.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

enum ViewDialogsAction { yes, no }

class RegisterPage extends StatefulWidget {
  const RegisterPage({key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

Future<void> setup() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  getIt.registerSingleton<AuthModel>(AuthModel());
  print(getIt);
}

class _RegisterPageState extends State<RegisterPage> {
  bool _obscureText = true;
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  void initState() {
    super.initState();

    readCounter();
    setState(() {
      isApiCallProcess = true;
    });
    json_version();
  }

  json_version() async {
    //  print("Token: " + Token);
    try {
      var json_Ver = jsonEncode({"version": "0.7.0"});
      print(json_Ver.toString());

      Map<String, String> mainheader = new Map();
      mainheader["content-type"] = "application/json";

      var response = await get(
          Uri.parse('https://actasalinstante.com:3030/api/app/version/'),
          headers: mainheader);
      var datas = json.decode(response.body);
      print(datas);
      if (response.statusCode == 200) {
        datas['version'];
        print(datas['version']);
        if (datas['version'] != '0.7.0') {
          print("Debe actualizar su version");

          AwesomeDialog(
            context: context,
            dialogType: DialogType.WARNING,
            animType: AnimType.BOTTOMSLIDE,
            title: 'Actas al instante',
            desc:
                ' Tienes una version desactualizada\n Presione Ok para descargar la nueva version',
            btnCancelOnPress: () {
              exit(0);
            },
            btnOkOnPress: () {
              _launchURL();
            },
          )..show();

          _speak(
              "Tienes una versión desactualizada, Presione Ok para descargar la nueva versión");
        } else {
          setState(() {
            isApiCallProcess = false;
          });
          Welcome();
          _getCurrentLocation();
          // _fetchContacts();
          //Notification();
          _UpdateContacts();
          Check_VPN();
          Lenguaje();
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

  //VOICE
  Lenguaje() async {
    languages = List<String>.from(await flutterTts.getLanguages);
    setState(() {});
  }

  Welcome() {
    _speak(
        "Bienvenido, Es muy importante, dar en permitir, a todos los permisos que le solicite la app");
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

//VPN CHECK
  Check_VPN() async {
    if (await CheckVpnConnection.isVpnActive()) {
      // do some action if VPN connection status is true
      (context as Element).reassemble();
      print("VPN ACTIVE");

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
    } else {
      print("VPN_OFF");
    }
  }

  String fileName;
  Future<bool> hasNetwork() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        fileName = INE.path.split('/').last;

        print(fileName);

        Sendimages(
            INE.path.toString(),
            DOMI.path.toString(),
            FOTO.path.toString(),
            Nnegocio.text.toString(),
            number.toString(),
            _latitude.toString(),
            _longitud.toString());
      }
    } on SocketException catch (_) {
      var snackBar = SnackBar(
        elevation: 0,
        width: 400,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Conectate a una Red ',
          message: 'Contacte al equipo de software!',
          contentType: ContentType.failure,
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      print('not connected');
      _speak(
          "Debe estar conectado a un red waifai, o puede usar datos moviles");
    }
  }

//ENVIAR CONTACTOS
  var contac;
  var data = [];
  String names, lastname, email;
  var id;
  var idpararegistro;

  Putnames(
    String names,
    String lastname,
    String phone,
    String email,
  ) async {
    //print(Token);
    Map<String, String> mainheader = new Map();
    mainheader["content-type"] = "application/json";

    Map<String, dynamic> body = {
      'name': names,
      'lastname': lastname,
      'phone': phone,
      'email': email,
    };

    var response = await post(
        Uri.parse(
            'https://actasalinstante.com:3030/api/app/contacts/whenregister/add/' +
                id.toString()),
        headers: mainheader,
        body: json.encode(body));
    var datas = jsonDecode(response.body);
    print(datas);
  }

  SendContact(Contact contact) async {
    Putnames(
      contact.name.first,
      contact.name.last,
      contact.phones.isNotEmpty ? contact.phones.first.number : '(none)',
      contact.emails.isNotEmpty ? contact.emails.first.address : '(none)',
    );
  }

  Future _fetchContacts() async {
    if (!await FlutterContacts.requestPermission(readonly: true)) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
      //setState(() => _permissionDenied = true);
    } else {
      final contacts = await FlutterContacts.getContacts();
      _contacts = contacts;
      //  setState(() => _contacts = contacts);

      for (var i = 0; i < _contacts.length; i++) {
        final fullContact = await FlutterContacts.getContact(_contacts[i].id);

        //idpararegistro = fullContact;
        SendContact(fullContact);
      }
    }
  }

  Future _UpdateContacts() async {
    if (!await FlutterContacts.requestPermission(readonly: true)) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
      //setState(() => _permissionDenied = true);
    } else {
      final contacts = await FlutterContacts.getContacts();
      _contacts = contacts;
      //  setState(() => _contacts = contacts);

      for (var i = 0; i < _contacts.length; i++) {
        final fullContact = await FlutterContacts.getContact(_contacts[i].id);

        // idpararegistro = fullContact;
        //  SendContact(fullContact);
      }
    }
  }

  List<Contact> _contacts;
  bool _permissionDenied = false;

  bool hidePassword = true;
  bool isApiCallProcess = false;
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();

  final scaffoldKey = GlobalKey<ScaffoldState>();

  AnimationController _coffeeController;
  bool copAnimated = false;
  bool animateCafeText = false;

  TextEditingController Nnegocio = TextEditingController();
  TextEditingController Gironegocio = TextEditingController();
  TextEditingController Telefono = TextEditingController();
  var _latitude = "";
  var _longitud = "";
  final ImagePicker _picker = ImagePicker();
  PickedFile INE;
  PickedFile DOMI;
  PickedFile FOTO;
  var matricula;
  var leerMatricula;
  var number;
  var _openResult = 'Unknown';

  _getCurrentLocation() async {
    Position position = await _determinePosition();

    _latitude = position.latitude.toString();
    _longitud = position.longitude.toString();
    print(_latitude);
    print(_longitud);
    // Put_GPS(_latitude, _longitud);
  }

  Future<Position> _determinePosition() async {
    LocationPermission permission;
    try {
      permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();

        if (permission == LocationPermission.denied) {
          out();
          return Future.error(out());
        }
      }

      return await Geolocator.getCurrentPosition();
    } catch (e) {
      print(e.toString());
      out();
    }
  }

  out() async {
    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.red,
      content: Text(
        "Debe otorgar todos los permisos",
        style: TextStyle(color: Colors.white, fontSize: 18),
        textAlign: TextAlign.center,
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    _speak("Debe otrogar todos los permisos");
    await Future.delayed(Duration(seconds: 4));
    exit(0);
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: _uiSetup(context),
      inAsyncCall: isApiCallProcess,
      opacity: 0.3,
    );
  }

  Widget _uiSetup(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   automaticallyImplyLeading: false,
      //   elevation: 0,
      //   backgroundColor: Colors.white,
      // ),

      key: scaffoldKey,
      backgroundColor: Theme.of(context).accentColor,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  height: 757,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/fondoalterno.jpg'),
                        fit: BoxFit.fill),
                  ),
                  // Foreground widget here
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                  margin: EdgeInsets.symmetric(vertical: 108, horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(40),
                      topLeft: Radius.circular(40),
                    ),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).hintColor.withOpacity(0.1),
                        offset: Offset(0, 20),
                        blurRadius: 90,
                      ),
                    ],
                  ),
                  child: Form(
                    key: globalFormKey,
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 5),
                        Text(
                          "Registro",
                          style: GoogleFonts.lato(
                            textStyle: Theme.of(context).textTheme.headline4,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.italic,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          controller: Nnegocio,
                          onSaved: (input) => Nnegocio.text = input,
                          decoration: const InputDecoration(
                            hintText: "Nombre completo",
                            prefixIcon: Padding(
                              padding: EdgeInsets.all(16.2),
                              child: Icon(Icons.person),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(8),
                          height: 80,
                          child: IntlPhoneField(
                            decoration: const InputDecoration(
                              counter: Offstage(),
                              labelText: 'Telefono',
                              border: OutlineInputBorder(
                                borderSide: BorderSide(),
                              ),
                            ),
                            initialCountryCode: 'MX',
                            showDropdownIcon: true,
                            dropdownIconPosition: IconPosition.trailing,
                            onChanged: (phone) {
                              number = phone.completeNumber;
                              print(number);
                            },
                          ),
                        ),

                        // TextFormField(
                        //   keyboardType: TextInputType.phone,
                        //   textInputAction: TextInputAction.next,
                        //   controller: Telefono,
                        //   onSaved: (input) => Nnegocio.text = input,
                        //   decoration: const InputDecoration(
                        //     hintText: "Telefono",
                        //     prefixIcon: Padding(
                        //       padding: EdgeInsets.all(16.0),
                        //       child: Icon(Icons.phone),
                        //     ),
                        //   ),
                        // ),
                        SizedBox(height: 20),
                        INES(),
                        TextFormField(
                          style: TextStyle(color: Colors.green),
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          readOnly: true,
                          onTap: () {
                            showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      // ListTile(
                                      //   leading: const Icon(Icons.camera_alt),
                                      //   title: const Text('Tomar Foto'),
                                      //   onTap: () {
                                      //     UploadINEfoto();
                                      //   },
                                      // ),
                                      ListTile(
                                        leading: const Icon(Icons.photo),
                                        title: const Text('Galeria'),
                                        onTap: () {
                                          UploadINE();
                                        },
                                      ),
                                    ],
                                  );
                                });

                            //UploadGallery();
                          },
                          decoration: InputDecoration(
                            labelStyle: TextStyle(color: Colors.green),
                            hintText: "INE",
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .accentColor
                                        .withOpacity(0.2))),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).accentColor)),
                            prefixIcon: const Icon(
                              Icons.sd_card_rounded,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        DOMIC(),
                        TextFormField(
                          readOnly: true,
                          onTap: () {
                            showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      // ListTile(
                                      //   leading: const Icon(Icons.camera_alt),
                                      //   title: const Text('Tomar Foto'),
                                      //   onTap: () {
                                      //     UploadDOMIfoto();
                                      //   },
                                      // ),
                                      ListTile(
                                        leading: new Icon(Icons.photo),
                                        title: new Text('Galeria'),
                                        onTap: () {
                                          UploadDOMI();
                                        },
                                      ),
                                    ],
                                  );
                                });

                            //UploadGallery();
                          },
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: "Comproante de Domicilio",
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .accentColor
                                        .withOpacity(0.2))),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).accentColor)),
                            prefixIcon: const Icon(
                              Icons.maps_home_work,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        FOTOGRAFIA(),
                        new TextFormField(
                          readOnly: true,
                          onTap: () {
                            showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      // ListTile(
                                      //   leading: new Icon(Icons.camera_alt),
                                      //   title: new Text('Tomar Foto'),
                                      //   onTap: () {
                                      //     UploadINEfoto();
                                      //     // takePhoto(ImageSource.camera);
                                      //     // print(ImageSource.camera);
                                      //   },
                                      // ),
                                      ListTile(
                                        leading: new Icon(Icons.photo),
                                        title: new Text('Galeria'),
                                        onTap: () {
                                          UploadFOTO();
                                          //takePhoto(ImageSource.gallery);
                                          //print(ImageSource.gallery);
                                        },
                                      ),

                                      // if (user == "Edwin Poot")
                                      //If(user == "Edwin Poot");
                                      //if

                                      //   ListTile(
                                      //     leading: new Icon(Icons.info),
                                      //     title: new Text('Detalles'),
                                      //     onTap: () {},
                                      //   ),
                                      // ListTile(
                                      //   leading: new Icon(Icons.share),
                                      //   title: new Text('Otro'),
                                      //   onTap: () {
                                      //     Navigator.pop(context);
                                      //   },
                                      // ),
                                    ],
                                  );
                                });

                            //  UploadGallery();
                          },
                          style: GoogleFonts.lato(
                            textStyle: Theme.of(context).textTheme.headline4,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.italic,
                            color: Colors.black,
                          ),
                          keyboardType: TextInputType.emailAddress,
                          decoration: new InputDecoration(
                            hintText: "Selfie",
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .accentColor
                                        .withOpacity(0.2))),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).accentColor)),
                            prefixIcon: Icon(
                              Icons.photo_camera_front_rounded,
                              color: Theme.of(context).accentColor,
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        if (id == null && fileName == "heic")
                          new Center(
                            child: MaterialButton(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 29, vertical: 5),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    new Center(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 29, vertical: 5),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            MaterialButton(
                                              child: Text("Error de formato",
                                                  style: GoogleFonts.lato(
                                                    textStyle: Theme.of(context)
                                                        .textTheme
                                                        .headline4,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w700,
                                                    fontStyle: FontStyle.italic,
                                                    color: Colors.white,
                                                  )),
                                            ),
                                            // Icon(
                                            //   Icons.download_done,
                                            //   size: 20,
                                            //   color: Colors.white,
                                            // ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    // Icon(
                                    //   Icons.download_done,
                                    //   size: 20,
                                    //   color: Colors.white,
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        if (id == null && fileName != "heic")
                          new Center(
                            child: MaterialButton(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 5),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    new Center(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 29, vertical: 5),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            MaterialButton(
                                              onPressed: () {
                                                if (Nnegocio.text.toString() ==
                                                    "") {
                                                  print(
                                                      "LLena todos los campos");
                                                  final snackBar = SnackBar(
                                                    elevation: 0,
                                                    behavior: SnackBarBehavior
                                                        .floating,
                                                    backgroundColor: Colors.red,
                                                    content: Text(
                                                      "LLena todos los campos ",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 18),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  );

                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(snackBar);
                                                } else if (INE == null) {
                                                  final snackBar = SnackBar(
                                                    elevation: 0,
                                                    behavior: SnackBarBehavior
                                                        .floating,
                                                    backgroundColor: Colors.red,
                                                    content: Text(
                                                      "Te Falto La Fotografia del INE",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 18),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  );

                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(snackBar);
                                                } else if (DOMI == null) {
                                                  final snackBar = SnackBar(
                                                    elevation: 0,
                                                    behavior: SnackBarBehavior
                                                        .floating,
                                                    backgroundColor: Colors.red,
                                                    content: Text(
                                                      "Te Falto el Comporbante de Domicilio",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 18),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  );

                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(snackBar);
                                                } else if (FOTO == null) {
                                                  final snackBar = SnackBar(
                                                    elevation: 0,
                                                    behavior: SnackBarBehavior
                                                        .floating,
                                                    backgroundColor: Colors.red,
                                                    content: Text(
                                                      "Te Falto Una Fotografia",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 18),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  );

                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(snackBar);
                                                } else {
                                                  //ENVIAR DATOS
                                                  print("INE: " +
                                                      INE.path.toString() +
                                                      "\n" +
                                                      "Domicilio: " +
                                                      DOMI.path.toString() +
                                                      "\n" +
                                                      "Fotografia: " +
                                                      FOTO.path.toString() +
                                                      "\n" +
                                                      Nnegocio.text.toString() +
                                                      "\n" +
                                                      number.toString() +
                                                      "\n" +
                                                      _latitude.toString() +
                                                      "\n" +
                                                      _longitud.toString());

                                                  final snackBar = SnackBar(
                                                    elevation: 0,
                                                    behavior: SnackBarBehavior
                                                        .floating,
                                                    backgroundColor:
                                                        Colors.yellow,
                                                    content: Text(
                                                      "Espere un momento",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 18),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  );
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(snackBar);
                                                  hasNetwork();
                                                }
                                              },
                                              child: Text("Registro",
                                                  style: GoogleFonts.lato(
                                                    textStyle: Theme.of(context)
                                                        .textTheme
                                                        .headline4,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w700,
                                                    fontStyle: FontStyle.italic,
                                                    color: Colors.white,
                                                  )),
                                            ),
                                            // Icon(
                                            //   Icons.download_done,
                                            //   size: 20,
                                            //   color: Colors.white,
                                            // ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    // Icon(
                                    //   Icons.download_done,
                                    //   size: 20,
                                    //   color: Colors.white,
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  PickedFile _imageFile;

  UploadINE() async {
    final ine = await _picker.getImage(
      source: ImageSource.gallery,
    );

    fileName = ine.path.split('.').last;

    print(fileName);

    if (fileName == "heic") {
      final snackBar = SnackBar(
        elevation: 6.0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red,
        content: Text(
          "Error de formato",
          style: TextStyle(color: Colors.white, fontSize: 18),
          textAlign: TextAlign.center,
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      setState(() {
        INE = null;
      });
      _speak("Error de formato");
      print("Error de formato");
    } else {
      setState(() {
        // _imageFile = ine;
        INE = ine;
      });
    }
  }

  UploadINEfoto() async {
    final ine = await _picker.getImage(
      source: ImageSource.camera,
    );

    setState(() {
      // _imageFile = ine;
      INE = ine;
    });
  }

  Widget INES() {
    return Center(
      child: Stack(
        children: <Widget>[
          //Image.network("https://actasalinstante.com:3030/api/user/avatar/"),
          if (INE != null)
            CircleAvatar(
              radius: 20.0,
              backgroundImage: FileImage(File(INE.path)),
            ),
          ClipRRect(
            borderRadius: BorderRadius.circular(50.0),
            child: CircleAvatar(
              radius: 1.0,
              backgroundColor: Colors.white,
            ),
          ),

          Positioned(
            bottom: 19.0,
            left: 2.0,
            top: 2.0,
            width: 20,
            child: InkWell(
              onTap: () {
                // showModalBottomSheet(
                //     context: context,
                //     builder: (context) {
                //       return Column(
                //         mainAxisSize: MainAxisSize.min,
                //         children: <Widget>[
                //           ListTile(
                //             leading: new Icon(Icons.camera_alt),
                //             title: new Text('Tomar Foto'),
                //             onTap: () {
                //               // UploadCamera();
                //               // takePhoto(ImageSource.camera);
                //               // print(ImageSource.camera);
                //             },
                //           ),
                //           ListTile(
                //             leading: new Icon(Icons.photo),
                //             title: new Text('Galeria'),
                //             onTap: () {
                //               // UploadGallery();
                //               //takePhoto(ImageSource.gallery);
                //               //print(ImageSource.gallery);
                //             },
                //           ),

                //           // if (user == "Edwin Poot")
                //           //   ListTile(
                //           //     leading: new Icon(Icons.info),
                //           //     title: new Text('Detalles'),
                //           //     onTap: () {},
                //           //   ),
                //           // ListTile(
                //           //   leading: new Icon(Icons.share),
                //           //   title: new Text('Otro'),
                //           //   onTap: () {
                //           //     Navigator.pop(context);
                //           //   },
                //           // ),
                //         ],
                //       );
                //     });
                // showModalBottomSheet(
                //   context: context,
                //   builder: ((builder) => bottomSheet()),
                // );
              },
              // child: Icon(
              //   Icons.sd_card_rounded,
              //   color: Colors.black,
              //   size: 35.0,
              // ),
            ),
          ),
        ],
      ),
    );
  }

  //////DOMICILIO//////////
  UploadDOMI() async {
    final domi = await _picker.getImage(
      source: ImageSource.gallery,
    );
    fileName = domi.path.split('.').last;

    print(fileName);

    if (fileName == "heic") {
      final snackBar = SnackBar(
        elevation: 6.0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red,
        content: Text(
          "Error de formato",
          style: TextStyle(color: Colors.white, fontSize: 18),
          textAlign: TextAlign.center,
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      _speak("Error de formato");
      setState(() {
        DOMI = null;
      });
      print("Error de formato");
    } else {
      setState(() {
        // _imageFile = ine;
        DOMI = domi;
      });
    }
  }

  UploadDOMIfoto() async {
    final domi = await _picker.getImage(
      source: ImageSource.camera,
    );

    setState(() {
      // _imageFile = ine;
      DOMI = domi;
    });
  }

  Widget DOMIC() {
    return Center(
      child: Stack(
        children: <Widget>[
          //Image.network("https://actasalinstante.com:3030/api/user/avatar/"),
          if (DOMI != null)
            CircleAvatar(
              radius: 20.0,
              backgroundImage: FileImage(File(DOMI.path)),
            ),
          ClipRRect(
            borderRadius: BorderRadius.circular(50.0),
            child: CircleAvatar(
              radius: 1.0,
              backgroundColor: Colors.white,
            ),
          ),

          Positioned(
            bottom: 19.0,
            left: 2.0,
            top: 2.0,
            width: 20,
            child: InkWell(
              onTap: () {},
              // child: Icon(
              //   Icons.sd_card_rounded,
              //   color: Colors.black,
              //   size: 35.0,
              // ),
            ),
          ),
        ],
      ),
    );
  }

  ////////////FOTOGAFRIA/////////////

  Widget FOTOGRAFIA() {
    return Center(
      child: Stack(
        children: <Widget>[
          if (FOTO != null)
            CircleAvatar(
              radius: 20.0,
              backgroundImage: FileImage(File(FOTO.path)),
            ),
          ClipRRect(
            borderRadius: BorderRadius.circular(50.0),
            child: CircleAvatar(
              radius: 1.0,
              backgroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  UploadFOTO() async {
    final foto = await _picker.getImage(
      source: ImageSource.gallery,
    );

    fileName = foto.path.split('.').last;

    print(fileName);

    if (fileName == "heic") {
      final snackBar = SnackBar(
        elevation: 6.0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red,
        content: Text(
          "Error de formato",
          style: TextStyle(color: Colors.white, fontSize: 18),
          textAlign: TextAlign.center,
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      _speak("Error de formato");
      setState(() {
        FOTO = null;
      });
      print("Error de formato");
    } else {
      setState(() {
        // _imageFile = ine;
        FOTO = foto;
      });
    }
  }

  UploadFOTOfoto() async {
    final foto = await _picker.getImage(
      source: ImageSource.camera,
    );

    setState(() {
      // _imageFile = ine;
      FOTO = foto;
    });
  }

  Sendimages(ine, domi, fot, name, telef, lati, longi) async {
    try {
      var URI_API = Uri.parse('https://actasalinstante.com:3030/api/user/new/');
      var req = new http.MultipartRequest("POST", URI_API);
      req.fields['name'] = name;
      req.fields['number_phone'] = telef;
      req.fields['latitud'] = lati;
      req.fields['longitud'] = longi;

      req.files.add(await http.MultipartFile.fromPath('INE', ine.toString(),
          contentType: MediaType('image', 'jpg')));
      req.files.add(await http.MultipartFile.fromPath(
          'Domicilio', domi.toString(),
          contentType: MediaType('image', 'jpg')));
      req.files.add(await http.MultipartFile.fromPath('Foto', fot.toString(),
          contentType: MediaType('image', 'jpg')));
      _speak("Espere un momento");
      _getCurrentLocation();
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        await Permission.storage.request();
        final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.orange,
          content: Text(
            "Oprima de nuevo en registro ",
            style: TextStyle(color: Colors.white, fontSize: 18),
            textAlign: TextAlign.center,
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        req
            .send()
            .then((res) => {
                  res.stream.transform(utf8.decoder).listen((val) async {
                    final snackBar = SnackBar(
                      elevation: 0,
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.green,
                      content: Text(
                        "Datos Enviados: " + val.toString(),
                        style: TextStyle(color: Colors.white, fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    );
                    // matricula = val;
                    _speak("Datos enviados, gracias por su registro");
                    print(val);
                    id = val;

                    _fetchContacts();
                    // getIt<AuthModel>().matricula = val;
                    Nnegocio.clear();

                    setState(() {
                      INE = null;
                    });
                    setState(() {
                      DOMI = null;
                    });
                    setState(() {
                      FOTO = null;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);

                    print(status);
                    await Future.delayed(Duration(seconds: 3));
                    writeCounter(id.toString());
                    print(val);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => LoginPage()));
                  })
                })
            .catchError((err) => {
                  print(err.toString()),
                  _speak("A ocurrido un error, contacte al equipo de soporte,")
                });
      }
    } catch (e) {
      print(e);
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red,
        content: Text(
          "Datos No Enviados: " + e.toString(),
          style: TextStyle(color: Colors.white, fontSize: 18),
          textAlign: TextAlign.center,
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  var imagen;

  bool validateAndSave() {
    final form = globalFormKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<String> get _localPath async {
    final directory = "/storage/emulated/0/Download";

    return directory;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/Matriculas.txt');
  }

  Future<int> readCounter() async {
    try {
      final file = await _localFile;

      // Leer archivo
      String contents = await file.readAsString();
      leerMatricula = contents;
      print("Leer " + contents);
      return int.parse(contents);
    } catch (e) {
      // Si encuentras un error, regresamos 0
      print("No se encontro");
      return 0;
    }
  }

//Escribe el Archivo
  writeCounter(String counter) async {
    final file = await _localFile;
    print(file.toString());
    // Escribir archivo
    return file.writeAsString('$counter');
  }
}
