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
  }

  Welcome() {
    _speak('Hola,' + user + ', Bienvenido, al apartado de robots');
  }

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

  instructions(String instruction, String robot) {
    switch (instruction) {
      case 'off':
        setState(() {
          instructionse = [instruction, robot.toString()];
          send(instructionse);
          //print(instructionse);
        });

        break;
      case 'on':
        setState(() {
          instructionse = [instruction, robot.toString()];
          send(instructionse);
        });
        break;
      default:
    }
  }

  static const duration = Duration(milliseconds: 300);
  PostRobot(instruction, name) async {
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
            'https://actasalinstante.com:3030/api/robots/controller/instruction/new/'),
        body: body,
        headers: mainheader,
      );
      var datas = json.decode(req.body);

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
      _speak(e.toString());
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
        print(robot_instruction[0] + robot_instruction[1]);

        break;
      default:
    }
  }

  var now = new DateTime.now();
  var isFavorite = false.obs;
  int index;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          backgroundColor: Color.fromARGB(255, 127, 137, 146),
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
                        'Robots',
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
                          Card(
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
                                  if ('${data[index].data}' == 'Apagado')
                                    Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          child: Center(
// Image radius
                                            child: Image.asset(
                                                'assets/ststus_close.gif',
                                                alignment: Alignment.center,
                                                width: 200,
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
                                  if ('${data[index].data}' != 'Apagado')
                                    Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          child: Center(
// Image radius
                                            child: Image.asset(
                                                'assets/ststus_ok.gif',
                                                alignment: Alignment.center,
                                                width: 200,
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
                                  Text(
                                    "Estatus: " + '${data[index].data}',
                                    maxLines: 2,
                                    style: TextStyle(
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
                                  SizedBox(height: 8),
                                  if ('${data[index].data}' == 'Apagado')
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
                                  if ('${data[index].data}' != 'Apagado')
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
