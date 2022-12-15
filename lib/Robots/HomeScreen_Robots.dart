import 'dart:convert';

import 'package:app_actasalinstante/DropDown/Descargar_actas/animation/FadeAnimation.dart';
import 'package:app_actasalinstante/NavBar.dart';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:android_intent/android_intent.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../SplashScreen/Splashscreen1.dart';
import '../../views/controller/controller.dart';
import 'package:permission_handler/permission_handler.dart';

import 'Api_service.dart';
import 'Robots_Model.dart';

class Robots extends StatefulWidget {
  @override
  _RobotsState createState() => _RobotsState();
}

class _RobotsState extends State<Robots> {
  Robots_get _userList = Robots_get();
  @override
  void initState() {
    GetNames();
    Lenguaje();
    // TODO: implement initState
    super.initState();
    get_robots();
  }

  TextEditingController etadoController = TextEditingController();
  String estado = "Cambiar Token\n";
  Welcome() {
    _speak('Hola,' +
        user +
        ', Toque la parte blanca, para cambiar los limites, de los robots');
  }

  //VOICE
  Lenguaje() async {
    languages = List<String>.from(await flutterTts.getLanguages);
    setState(() {});
  }

  FlutterTts flutterTts = FlutterTts();

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
    // print(langCode);
  }

  void _speak(voice) async {
    initSetting();
    await flutterTts.speak(voice);
  }

  String user = "";
  GetNames() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      user = prefs.getString('username');
    });
    Welcome();
    //  print(user);
  }

  String Token = "";

  List data = List();
  var instructionse = [];

  var Bochil;
  var Bochil_contador;
  var Villaflores;
  var Villaflores_contador;
  var descargas;
  var Descargadas;
  var Restantes;
  var bochild_name;
  var Toluca_Santos;
  var Toluca_Santos_Contador;
  var RegistroCivil1;
  var RegistroCivil1_contador;
  bool isApiCallProcess = false;
  get_robots() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Token = prefs.getString('token');
    Map<String, String> mainheader = new Map();
    mainheader["content-type"] = "application/json";
    mainheader['x-access-token'] = Token;
    var response = await get(
      Uri.parse('https://actasalinstante.com:3030/api/robotsUsage/get/all/'),
      headers: mainheader,
    );
    var GetRobots = json.decode(response.body.toString());
    if (response.statusCode == 200) {
      setState(() {
        isApiCallProcess = false;
      });

      for (var i = 0; i < GetRobots.length; i++) {
        //   GetRobots[i];

        print(GetRobots[i]);
        if (GetRobots[i]['name'] == 'HospitalBochil') {
          setState(() {
            Bochil = GetRobots[i]['limit'];
            Bochil_contador = GetRobots[i]['current'];
          });
          print('Bochil');
        } else if (GetRobots[i]['name'] == 'HospitalVillaFlores') {
          setState(() {
            Villaflores = GetRobots[i]['limit'];
            Villaflores_contador = GetRobots[i]['current'];
            print(Villaflores);
          });
        } else if (GetRobots[i]['name'] == 'Toluca-Santos') {
          setState(() {
            Toluca_Santos = GetRobots[i]['limit'];
            Toluca_Santos_Contador = GetRobots[i]['current'];
            print(Villaflores);
          });
        } else if (GetRobots[i]['name'] == 'Registro Civil 1') {
          setState(() {
            RegistroCivil1 = GetRobots[i]['limit'];
            RegistroCivil1_contador = GetRobots[i]['current'];
            print(Villaflores);
          });
        }
      }

      //  print(GetRobots['[]'].toString());
      // print(GetRobots['Robots']['1']);
      // print(GetRobots['Robots']['2']);
      // print(GetRobots['DescargasDisponibles']);
      // print(GetRobots['Descargadas']);

      // print(Bochil);
      setState(() {
        // Bochil = GetRobots['Robots']['1'];
        // Villaflores = GetRobots['Robots']['2'];
        // descargas = GetRobots['DescargasDisponibles'];
        // Descargadas = GetRobots['Descargadas'];
        // Restantes = GetRobots['Restantes'];
      });
    }
  }

  instructions(String instruction, String robot) {
    switch (instruction) {
      case 'off':
        setState(() {
          instructionse = [instruction, robot.toString()];
          send(instructionse);
          print(instructionse);
        });

        break;
      case 'on':
        setState(() {
          instructionse = [instruction, robot.toString()];
          send(instructionse);
        });
        break;
      case 'changeAccessToken':
        setState(() {
          instructionse = [instruction, robot.toString()];
          print(instructionse);
          send(instructionse);
        });
        break;
      default:
    }
  }

  static const duration = Duration(milliseconds: 300);
  PostRobot(instruction, name) async {
    print(name);
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      Token = prefs.getString('token');
      Map<String, String> mainheader = new Map();
      mainheader["content-type"] = "application/json";
      mainheader['x-access-token'] = Token;

      var body = jsonEncode({
        "name": name,
        "instruction": instruction,
      });
      //  print(body);
      var req = await post(
        Uri.parse(
            'https://actasalinstante.com:3030/api/robotsUsage/controller/instruction/new/'),
        body: body,
        headers: mainheader,
      );
      var datas = json.decode(req.body);
      print(datas);

      if (req.statusCode == 200) {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, _) {
              return FadeTransition(
                opacity: animation,
                child: NavBar(),
              );
            },
            transitionDuration: duration,
            reverseTransitionDuration: duration,
          ),
        );
        // print(datas);
      }
    } catch (e) {
      print(e);
      //  _speak(e.toString());
    }
  }

 

  send(robot_instruction) {
    switch (robot_instruction[0]) {
      case 'off':
        PostRobot(robot_instruction[0], robot_instruction[1]);
        _speak("Apagando el robot," + robot_instruction[1]);
        print(robot_instruction[0] + robot_instruction[1]);

        break;
      case 'on':
        PostRobot(robot_instruction[0], robot_instruction[1]);
        _speak("Encendiendo el robot," + robot_instruction[1]);

        break;
      case 'changeAccessToken':
        PostRobot('${robot_instruction[0]}=${etadoController.text} ',
            robot_instruction[1]);
        // print(robot_instruction[0]);
        _speak("Se cambió el Token");
        break;

      default:
    }
  }

  Set_robots(name, numero) async {
    try {
      Map<String, String> mainheader = new Map();
      mainheader["content-type"] = "application/json";
      mainheader['x-access-token'] = Token;
//  var bod = numero;
      var Body = jsonEncode({"name": name, "limit": numero});
      print(Body);
      var response = await put(
        Uri.parse(
            'https://actasalinstante.com:3030/api/robotsUsage/change/limit/'),
        headers: mainheader,
        body: Body,
      );
      var GetRobots = json.encode(response.body.toString());
      print(GetRobots);
      if (response.statusCode == 200) {
        setState(() {
          isApiCallProcess = false;
        });
        Set_limitChange();
        print("Se cambio el limite del robot: " +
            name +
            " a " +
            numero.toString());

        //  print(GetRobots['[]'].toString());
        // print(GetRobots['Robots']['1']);
        // print(GetRobots['Robots']['2']);
        // print(GetRobots['DescargasDisponibles']);
        // print(GetRobots['Descargadas']);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Off_Robot(name) async {
    try {
      Map<String, String> mainheader = new Map();
      mainheader["content-type"] = "application/json";
      mainheader['x-access-token'] = Token;
//  var bod = numero;

      var response = await put(
        Uri.parse(
            'https://actasalinstante.com:3030/api/robotsUsage/change/status/off/' +
                name),
        headers: mainheader,
      );
      var GetRobots = json.encode(response.body.toString());
      print(GetRobots);
      if (response.statusCode == 200) {
        setState(() {
          isApiCallProcess = false;
        });
        Set_limitChange();
        print(
            "Se cambio el limite del robot: " + name + " a " + name.toString());

        //  print(GetRobots['[]'].toString());
        // print(GetRobots['Robots']['1']);
        // print(GetRobots['Robots']['2']);
        // print(GetRobots['DescargasDisponibles']);
        // print(GetRobots['Descargadas']);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Set_limitChange() {
    var snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title:
            ' Se Cambio el limite del robot: ' + " a " + Count.text.toString(),
        message: 'Con exito',
        contentType: ContentType.help,
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    Navigator.push(context, MaterialPageRoute(builder: (context) => NavBar()));
  }

  // Image Name List Here
  var imgList = [
    "assets/NAC.png",
    "assets/DEFUNCION.jpg",
    "assets/matrimonio.png",
  ];

  TextEditingController Count = TextEditingController();

  showDialogFunc(context, data, curp, username, comments) {
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
              width: MediaQuery.of(context).size.width * 0.9,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  if (username == 'HospitalBochil')
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Center(
// Image radius
                        child: Image.asset('assets/BOCHIL.png',
                            alignment: Alignment.center, fit: BoxFit.cover),
                      ),
                    ),
                  if (username == 'HospitalVillaFlores')
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Center(
// Image radius
                        child: Image.asset('assets/Villaflores.png',
                            alignment: Alignment.center, fit: BoxFit.cover),
                      ),
                    ),

                  if (username == 'Toluca-Santos')
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Center(
// Image radius
                        child: Image.asset('assets/Toluca.jpeg',
                            alignment: Alignment.center, fit: BoxFit.cover),
                      ),
                    ),
                  if (username == 'Registro Civil 1')
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Center(
// Image radius
                        child: Image.asset('assets/Civil.jpeg',
                            alignment: Alignment.center, fit: BoxFit.cover),
                      ),
                    ),
                  // ClipRRect(
                  //   borderRadius: BorderRadius.circular(5),
                  //   child: Image.asset(
                  //     image,
                  //     width:10,
                  //     height: 10,
                  //   ),
                  // ),

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
                        username.toString().toUpperCase(),
                        maxLines: 3,
                        style: TextStyle(fontSize: 20, color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),

                  Container(
                    // width: 200,
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Tipo: " + curp?.toString(),
                        maxLines: 3,
                        style: TextStyle(fontSize: 15, color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Container(
                    // width: 200,
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Estatus: " + data?.toString(),
                        maxLines: 3,
                        style: TextStyle(fontSize: 15, color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),

                  //BOCHIL
                  if (username == 'HospitalBochil')
                    Container(
                      // width: 200,
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Limite: " + Bochil.toString(),
                          maxLines: 3,
                          style: TextStyle(fontSize: 15, color: Colors.black),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),

                  if (username == 'HospitalBochil')
                    Container(
                      // width: 200,
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Contador: " + Bochil_contador.toString(),
                          maxLines: 3,
                          style: TextStyle(fontSize: 15, color: Colors.black),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),

                  if (username == 'HospitalBochil')
                    TextFormField(
                      keyboardType: TextInputType.number,
                      controller: Count,
                      decoration: InputDecoration(
                          hintText: 'Limite de Actas: ' + Bochil.toString()),
                      maxLength: 4,

                      //  obscureText: true,
                    ),
                  //BOCHIL
                  //HospitalVillaFlores
                  if (username == 'HospitalVillaFlores')
                    Container(
                      // width: 200,
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Limite: " + Villaflores.toString(),
                          maxLines: 3,
                          style: TextStyle(fontSize: 15, color: Colors.black),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),

                  if (username == 'HospitalVillaFlores')
                    Container(
                      // width: 200,
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Contador: " + Villaflores_contador.toString(),
                          maxLines: 3,
                          style: TextStyle(fontSize: 15, color: Colors.black),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),

                  if (username == 'HospitalVillaFlores')
                    TextFormField(
                      keyboardType: TextInputType.number,
                      controller: Count,
                      decoration: InputDecoration(
                          hintText: 'Limite de Actas: ' +
                              Villaflores_contador.toString()),
                      maxLength: 4,

                      //  obscureText: true,
                    ),
                  //VILLAFLORES

                  //HospitalVillaFlores
                  if (username == 'Toluca-Santos')
                    Container(
                      // width: 200,
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Limite: " + Toluca_Santos.toString(),
                          maxLines: 3,
                          style: TextStyle(fontSize: 15, color: Colors.black),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),

                  if (username == 'Toluca-Santos')
                    Container(
                      // width: 200,
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Contador: " + Toluca_Santos_Contador.toString(),
                          maxLines: 3,
                          style: TextStyle(fontSize: 15, color: Colors.black),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),

                  if (username == 'Toluca-Santos')
                    TextFormField(
                      keyboardType: TextInputType.number,
                      controller: Count,
                      decoration: InputDecoration(
                          hintText: 'Limite de Actas: ' +
                              Toluca_Santos_Contador.toString()),
                      maxLength: 4,

                      //  obscureText: true,
                    ),

                  if (username == 'Registro Civil 1')
                    Container(
                      // width: 200,
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Contador: " + RegistroCivil1.toString(),
                          maxLines: 3,
                          style: TextStyle(fontSize: 15, color: Colors.black),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),

                  if (username == 'Registro Civil 1')
                    TextFormField(
                      keyboardType: TextInputType.number,
                      controller: Count,
                      decoration: InputDecoration(
                          hintText: 'Limite de Actas: ' +
                              RegistroCivil1_contador.toString()),
                      maxLength: 4,

                      //  obscureText: true,
                    ),

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
                            onPressed: () {
                              Set_robots(username, Count.text.toString());

                              setState(() {
                                isApiCallProcess = true;
                              });
                              print(
                                  username.toString() + Count.text.toString());
                              //  _speak('abriendo pdf');
                            },
                            child: Text("Enviar"),
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

  final Color color = HexColor('#D61C4E');
  var now = new DateTime.now();
  var isFavorite = false.obs;
  int index;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          backgroundColor: color,
          appBar: AppBar(
            actions: [
              // new Center(
              //   child: new DropdownButton(
              //     hint: Text(
              //       "Selecciona el Corte",
              //       style: GoogleFonts.lato(
              //         textStyle: Theme.of(context).textTheme.headline4,
              //         fontSize: 13,
              //         fontWeight: FontWeight.w700,
              //         fontStyle: FontStyle.italic,
              //         color: Colors.black,
              //       ),
              //     ),
              //     dropdownColor: Colors.white,
              //     items: data.map((item) {
              //       return new DropdownMenuItem(
              //         child: new Text(item['corte'].toString()),
              //         value: item['corte'].toString(),
              //       );
              //     }).toList(),
              //     onChanged: (newVal) {
              //       setState(() {
              //         _userList.datesforuserrfc = newVal;
              //       });
              //     },
              //     value: _userList.datesforuserrfc,
              //   ),
              // ),
              new IconButton(
                icon: new Icon(Icons.info),
                iconSize: 30.0,
                highlightColor: Colors.white,
                color: Colors.black,
                onPressed: () {
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.SUCCES,
                    animType: AnimType.BOTTOMSLIDE,
                    title: '' + user.toString(),
                    desc: 'Tienes: ' +
                        _userList.data.length.toString() +
                        ' Robots',
                    btnOkOnPress: () {
                      // exit(0);
                    },
                  )..show();
                  //   print(_userList.data.length.toString());
                  // _userList.data.length.toString();
                },
              ),
              // IconButton(
              //   onPressed: () {
              //     showSearch(context: context, delegate: SearchUser());
              //   },
              //   icon: Icon(Icons.search_sharp),
              //   color: Colors.black,
              //   iconSize: 30.0,
              // )
            ],
            automaticallyImplyLeading: false,
            elevation: 0,
            backgroundColor: Colors.transparent,
            centerTitle: false,
            title: Text(
              "" + user.toString(),
              style: GoogleFonts.lato(
                textStyle: Theme.of(context).textTheme.headline4,
                fontSize: 19,
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.italic,
                color: Colors.black,
              ),
            ),
          ),
          body: Container(
            padding: EdgeInsets.all(10),
            child: FutureBuilder<List<Robots_model>>(
                future: _userList.get_robots(),
                builder: (context, snapshot) {
                  var data = snapshot.data;
                  return ListView.builder(
                      itemCount: data?.length,
                      itemBuilder: (context, index) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.black,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.greenAccent),
                            ),
                          );
                        }

                        final _controller = Get.find<Controller>();

                        return FadeAnimation(
                          1.3,
                          GestureDetector(
                            onTap: () {
                              // This Will Call When User Click On ListView Item

                              showDialogFunc(
                                context,
                                data[index].data,
                                data[index].email,
                                data[index].username,
                                data[index].comments,
                              );
                              //_speak( data[index].username);
                            },
                            child: Card(
                              elevation: 10,
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(40),
                                  topLeft: Radius.circular(40),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    new Center(
                                      child: Text(
                                        (index + 1).toString(),
                                        maxLines: 5,
                                        style: TextStyle(
                                            fontSize: 22,
                                            fontFamily: 'avenir',
                                            fontWeight: FontWeight.w800,
                                            color: Colors.greenAccent),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    new Center(
                                      child: Text(
                                        '${data[index].username}',
                                        maxLines: 2,
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontFamily: 'avenir',
                                            fontWeight: FontWeight.w800),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),

                                    //HospitalBochil

                                    if ('${data[index].data}' == 'Off' &&
                                        '${data[index].username}' ==
                                            'HospitalBochil')
                                      Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child: Center(
// Image radius
                                              child: Image.asset(
                                                  'assets/BOCHIL.png',
                                                  alignment: Alignment.center,
                                                  fit: BoxFit.cover),
                                            ),
                                          ),
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child: Center(
// Image radius
                                              child: Image.asset(
                                                  'assets/ststus_close.gif',
                                                  alignment: Alignment.center,
                                                  width: 100,
                                                  fit: BoxFit.cover),
                                            ),
                                          ),
                                          Container(
                                            height: 10,
                                            width: double.infinity,
                                            clipBehavior: Clip.antiAlias,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(54),
                                            ),
                                          ),
                                        ],
                                      ),
                                    if ('${data[index].data}' != 'Off' &&
                                        '${data[index].username}' ==
                                            'HospitalBochil')
                                      Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child: Center(
// Image radius
                                              child: Image.asset(
                                                  'assets/BOCHIL.png',
                                                  alignment: Alignment.center,
                                                  fit: BoxFit.cover),
                                            ),
                                          ),
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child: Center(
// Image radius
                                              child: Image.asset(
                                                  'assets/ststus_ok.gif',
                                                  alignment: Alignment.center,
                                                  width: 100,
                                                  fit: BoxFit.cover),
                                            ),
                                          ),
                                          Container(
                                            height: 10,
                                            width: double.infinity,
                                            clipBehavior: Clip.antiAlias,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(54),
                                            ),
                                          ),
                                        ],
                                      ),
                                    //HospitalBochil

                                    //VILLAFLORES

                                    if ('${data[index].data}' == 'Off' &&
                                        '${data[index].username}' ==
                                            'HospitalVillaFlores')
                                      Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child: Center(
// Image radius
                                              child: Image.asset(
                                                  'assets/Villaflores.png',
                                                  alignment: Alignment.center,
                                                  fit: BoxFit.cover),
                                            ),
                                          ),
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child: Center(
// Image radius
                                              child: Image.asset(
                                                  'assets/ststus_close.gif',
                                                  alignment: Alignment.center,
                                                  width: 100,
                                                  fit: BoxFit.cover),
                                            ),
                                          ),
                                          Container(
                                            height: 10,
                                            width: double.infinity,
                                            clipBehavior: Clip.antiAlias,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(54),
                                            ),
                                          ),
                                        ],
                                      ),
                                    if ('${data[index].data}' != 'Off' &&
                                        '${data[index].username}' ==
                                            'HospitalVillaFlores')
                                      Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child: Center(
// Image radius
                                              child: Image.asset(
                                                  'assets/Villaflores.png',
                                                  alignment: Alignment.center,
                                                  fit: BoxFit.cover),
                                            ),
                                          ),
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child: Center(
// Image radius
                                              child: Image.asset(
                                                  'assets/ststus_ok.gif',
                                                  alignment: Alignment.center,
                                                  width: 100,
                                                  fit: BoxFit.cover),
                                            ),
                                          ),
                                          Container(
                                            height: 10,
                                            width: double.infinity,
                                            clipBehavior: Clip.antiAlias,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(54),
                                            ),
                                          ),
                                        ],
                                      ),
                                    //VILLAFLORES
                                    if ('${data[index].data}' != 'Off' &&
                                        '${data[index].username}' == 'RFCPOAM')
                                      Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child: Center(
// Image radius
                                              child: Image.asset(
                                                  'assets/rfc.png',
                                                  width: 200,
                                                  alignment: Alignment.center,
                                                  fit: BoxFit.cover),
                                            ),
                                          ),
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child: Center(
// Image radius
                                              child: Image.asset(
                                                  'assets/ststus_ok.gif',
                                                  alignment: Alignment.center,
                                                  width: 100,
                                                  fit: BoxFit.cover),
                                            ),
                                          ),
                                          Container(
                                            height: 10,
                                            width: double.infinity,
                                            clipBehavior: Clip.antiAlias,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(54),
                                            ),
                                          ),
                                        ],
                                      ),

                                    if ('${data[index].data}' == 'Off' &&
                                        '${data[index].username}' == 'RFCPOAM')
                                      Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child: Center(
// Image radius
                                              child: Image.asset(
                                                  'assets/rfc.png',
                                                  width: 200,
                                                  alignment: Alignment.center,
                                                  fit: BoxFit.cover),
                                            ),
                                          ),
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child: Center(
// Image radius
                                              child: Image.asset(
                                                  'assets/ststus_close.gif',
                                                  alignment: Alignment.center,
                                                  width: 100,
                                                  fit: BoxFit.cover),
                                            ),
                                          ),
                                          Container(
                                            height: 10,
                                            width: double.infinity,
                                            clipBehavior: Clip.antiAlias,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(54),
                                            ),
                                          ),
                                        ],
                                      ),

                                    if ('${data[index].data}' == 'Off' &&
                                        '${data[index].username}' ==
                                            'Toluca-Santos')
                                      Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child: Center(
// Image radius
                                              child: Image.asset(
                                                  'assets/Toluca.jpeg',
                                                  alignment: Alignment.center,
                                                  fit: BoxFit.cover),
                                            ),
                                          ),
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child: Center(
// Image radius
                                              child: Image.asset(
                                                  'assets/ststus_close.gif',
                                                  alignment: Alignment.center,
                                                  width: 100,
                                                  fit: BoxFit.cover),
                                            ),
                                          ),
                                          Container(
                                            height: 10,
                                            width: double.infinity,
                                            clipBehavior: Clip.antiAlias,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(54),
                                            ),
                                          ),
                                        ],
                                      ),
                                    if ('${data[index].data}' != 'Off' &&
                                        '${data[index].username}' ==
                                            'Toluca-Santos')
                                      Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child: Center(
// Image radius
                                              child: Image.asset(
                                                  'assets/Toluca.jpeg',
                                                  alignment: Alignment.center,
                                                  fit: BoxFit.cover),
                                            ),
                                          ),
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child: Center(
// Image radius
                                              child: Image.asset(
                                                  'assets/ststus_ok.gif',
                                                  alignment: Alignment.center,
                                                  width: 100,
                                                  fit: BoxFit.cover),
                                            ),
                                          ),
                                          Container(
                                            height: 10,
                                            width: double.infinity,
                                            clipBehavior: Clip.antiAlias,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(54),
                                            ),
                                          ),
                                        ],
                                      ),
                                    //TOLUCA

                                    //CIVIL
                                    if ('${data[index].data}' == 'Off' &&
                                        '${data[index].username}' ==
                                            'Registro Civil 1')
                                      Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child: Center(
// Image radius
                                              child: Image.asset(
                                                  'assets/Civil.jpeg',
                                                  alignment: Alignment.center,
                                                  fit: BoxFit.cover),
                                            ),
                                          ),
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child: Center(
// Image radius
                                              child: Image.asset(
                                                  'assets/ststus_close.gif',
                                                  alignment: Alignment.center,
                                                  width: 100,
                                                  fit: BoxFit.cover),
                                            ),
                                          ),
                                          Container(
                                            height: 10,
                                            width: double.infinity,
                                            clipBehavior: Clip.antiAlias,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(54),
                                            ),
                                          ),
                                        ],
                                      ),
                                    if ('${data[index].data}' != 'Off' &&
                                        '${data[index].username}' ==
                                            'Registro Civil 1')
                                      Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child: Center(
// Image radius
                                              child: Image.asset(
                                                  'assets/Civil.jpeg',
                                                  alignment: Alignment.center,
                                                  fit: BoxFit.cover),
                                            ),
                                          ),
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child: Center(
// Image radius
                                              child: Image.asset(
                                                  'assets/ststus_ok.gif',
                                                  alignment: Alignment.center,
                                                  width: 100,
                                                  fit: BoxFit.cover),
                                            ),
                                          ),
                                          Container(
                                            height: 10,
                                            width: double.infinity,
                                            clipBehavior: Clip.antiAlias,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(54),
                                            ),
                                          ),
                                        ],
                                      ),
                                    //CIVIL
                                    Text(
                                      "Robots",
                                      maxLines: 2,
                                      style: TextStyle(
                                          fontSize: 19,
                                          fontFamily: 'avenir',
                                          fontWeight: FontWeight.w800,
                                          color: Colors.blueAccent),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      "Robot: " + '${data[index].username}',
                                      maxLines: 2,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'avenir',
                                          fontWeight: FontWeight.w800),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    if (Bochil != null &&
                                        '${data[index].username}' ==
                                            'HospitalBochil')
                                      Text(
                                        "Limite: " + Bochil.toString(),
                                        maxLines: 2,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'avenir',
                                            fontWeight: FontWeight.w800),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    if (Bochil != null &&
                                        '${data[index].username}' ==
                                            'HospitalBochil')
                                      Text(
                                        "Contador: " +
                                            Bochil_contador.toString(),
                                        maxLines: 2,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'avenir',
                                            fontWeight: FontWeight.w800),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    if (Bochil == null &&
                                        '${data[index].username}' ==
                                            'HospitalBochil')
                                      Text(
                                        "Current: " + 'Robot apagado',
                                        maxLines: 2,
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 16,
                                            fontFamily: 'avenir',
                                            fontWeight: FontWeight.w800),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    if (Villaflores != null &&
                                        '${data[index].username}' ==
                                            'HospitalVillaFlores')
                                      Text(
                                        "Limite: " + Villaflores.toString(),
                                        maxLines: 2,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'avenir',
                                            fontWeight: FontWeight.w800),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    if (Villaflores != null &&
                                        '${data[index].username}' ==
                                            'HospitalVillaFlores')
                                      Text(
                                        "Contador: " +
                                            Villaflores_contador.toString(),
                                        maxLines: 2,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'avenir',
                                            fontWeight: FontWeight.w800),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    if (Villaflores == null &&
                                        '${data[index].username}' ==
                                            'HospitalVillaFlores')
                                      Text(
                                        "Current: " + 'Robot apagado',
                                        maxLines: 2,
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 16,
                                            fontFamily: 'avenir',
                                            fontWeight: FontWeight.w800),
                                        overflow: TextOverflow.ellipsis,
                                      ),

                                    if (Toluca_Santos != null &&
                                        '${data[index].username}' ==
                                            'Toluca-Santos')
                                      Text(
                                        "Limite: " + Toluca_Santos.toString(),
                                        maxLines: 2,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'avenir',
                                            fontWeight: FontWeight.w800),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    if (Toluca_Santos != null &&
                                        '${data[index].username}' ==
                                            'Toluca-Santos')
                                      Text(
                                        "Contador: " +
                                            Toluca_Santos_Contador.toString(),
                                        maxLines: 2,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'avenir',
                                            fontWeight: FontWeight.w800),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    if (Toluca_Santos == null &&
                                        '${data[index].username}' ==
                                            'Toluca-Santos')
                                      Text(
                                        "Current: " + 'Robot apagado',
                                        maxLines: 2,
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 16,
                                            fontFamily: 'avenir',
                                            fontWeight: FontWeight.w800),
                                        overflow: TextOverflow.ellipsis,
                                      ),

//REGISTRO CIVIL

                                    if (RegistroCivil1 != null &&
                                        '${data[index].username}' ==
                                            'Registro Civil 1')
                                      Text(
                                        "Limite: " + RegistroCivil1.toString(),
                                        maxLines: 2,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'avenir',
                                            fontWeight: FontWeight.w800),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    if (RegistroCivil1 != null &&
                                        '${data[index].username}' ==
                                            'Registro Civil 1')
                                      Text(
                                        "Contador: " +
                                            RegistroCivil1_contador.toString(),
                                        maxLines: 2,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'avenir',
                                            fontWeight: FontWeight.w800),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    if (RegistroCivil1 == null &&
                                        '${data[index].username}' ==
                                            'Registro Civil 1')
                                      Text(
                                        "Current: " + 'Robot apagado',
                                        maxLines: 2,
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 16,
                                            fontFamily: 'avenir',
                                            fontWeight: FontWeight.w800),
                                        overflow: TextOverflow.ellipsis,
                                      ),

                                    if ('${data[index].data}' != 'Ok')
                                      Text(
                                        "Estatus: " + '${data[index].data}',
                                        maxLines: 2,
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 16,
                                            fontFamily: 'avenir',
                                            fontWeight: FontWeight.w800),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    if ('${data[index].data}' == 'Ok')
                                      Text(
                                        "Estatus: " + '${data[index].data}',
                                        maxLines: 2,
                                        style: TextStyle(
                                            color: Colors.green,
                                            fontSize: 16,
                                            fontFamily: 'avenir',
                                            fontWeight: FontWeight.w800),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    Text(
                                      "Sistema: " + '${data[index].comments}',
                                      maxLines: 2,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'avenir',
                                          fontWeight: FontWeight.w800),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      "Tipo: " + '${data[index].email}',
                                      maxLines: 2,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'avenir',
                                          fontWeight: FontWeight.w800),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 18),
                                    if ('${data[index].comments}' == 'SID' &&
                                        '${data[index].data}' != 'Apagado' &&
                                        '${data[index].data}' != 'Apagando')
                                      TextFormField(
                                        controller: etadoController,
                                        decoration: InputDecoration(
                                            hintText: '' + estado.toString(),
                                            contentPadding:
                                                const EdgeInsets.all(10),
                                            fillColor: Colors.green,
                                            filled:
                                                true, // dont forget this line
                                            hintStyle:
                                                TextStyle(color: Colors.white)),
                                        readOnly: false,

                                        // obscureText: true,
                                      ),
                                    SizedBox(height: 8),
                                    if ('${data[index].data}' != 'Apagado' &&
                                        '${data[index].data}' != 'Apagando')
                                      new Center(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius:
                                                BorderRadius.circular(82),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 4, vertical: 2),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              MaterialButton(
                                                onPressed: () {
                                                  AwesomeDialog(
                                                    context: context,
                                                    dialogType:
                                                        DialogType.QUESTION,
                                                    animType:
                                                        AnimType.BOTTOMSLIDE,
                                                    title: 'Actas al instante',
                                                    desc: user.toString() +
                                                        ' ¿quieres camiar el token del robot? ' +
                                                        '${data[index].username}',
                                                    btnCancelOnPress: () {
                                                      //  Navigator.of(context).pop(true);
                                                    },
                                                    btnOkOnPress: () {
                                                      print(etadoController.text
                                                          .toString());
                                                      if (etadoController
                                                              .text ==
                                                          '') {
                                                        _speak(
                                                            "Debes de proporcionar, un nuevo Token");
                                                      } else {
                                                        instructions(
                                                            'changeAccessToken',
                                                            '${data[index].username}');
                                                      }
                                                    },
                                                  )..show();
                                                },
                                                child: Text("Cambiar Token "),
                                                textColor: Colors.white,
                                              ),
                                              Icon(
                                                Icons.download_done,
                                                size: 15,
                                                color: Colors.white,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    SizedBox(height: 8),
                                    if ('${data[index].data}' == 'Off')
                                      new Center(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.green,
                                            borderRadius:
                                                BorderRadius.circular(82),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 4, vertical: 2),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              MaterialButton(
                                                onPressed: () {
                                                  AwesomeDialog(
                                                    context: context,
                                                    dialogType:
                                                        DialogType.QUESTION,
                                                    animType:
                                                        AnimType.BOTTOMSLIDE,
                                                    title: 'Actas al instante',
                                                    desc: user.toString() +
                                                        ' ¿quieres encender el robot? ' +
                                                        '${data[index].username}',
                                                    btnCancelOnPress: () {
                                                      //  Navigator.of(context).pop(true);
                                                    },
                                                    btnOkOnPress: () {
                                                      instructions('on',
                                                          '${data[index].username}');
                                                      // EncenderRobot(
                                                      //     '${data[index].username}');
                                                    },
                                                  )..show();
                                                },
                                                child: Text("Encender"),
                                                textColor: Colors.white,
                                              ),
                                              Icon(
                                                Icons.download_done,
                                                size: 15,
                                                color: Colors.white,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    if ('${data[index].data}' != 'Off')
                                      new Center(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius:
                                                BorderRadius.circular(82),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 4, vertical: 2),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              MaterialButton(
                                                onPressed: () {
                                                  AwesomeDialog(
                                                    context: context,
                                                    dialogType:
                                                        DialogType.QUESTION,
                                                    animType:
                                                        AnimType.BOTTOMSLIDE,
                                                    title: 'Actas al instante',
                                                    desc: user.toString() +
                                                        ' ¿quieres apagar el robot? ' +
                                                        '${data[index].username}',
                                                    btnCancelOnPress: () {
                                                      //  Navigator.of(context).pop(true);
                                                    },
                                                    btnOkOnPress: () {
                                                      instructions('off',
                                                          ('${data[index].username}'));
                                                      // Off_Robot(
                                                      //     '${data[index].username}');
                                                    },
                                                  )..show();
                                                },
                                                child: Text("Apagar"),
                                                textColor: Colors.white,
                                              ),
                                              Icon(
                                                Icons.close,
                                                size: 15,
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
                          ),
                        );
                      });
                }),
          ),
        ),
        onWillPop: _onWillPopScope);
  }

  Future<bool> _onWillPopScope() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.WARNING,
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
