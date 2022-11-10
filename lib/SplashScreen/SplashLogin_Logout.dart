import 'dart:convert';
import 'dart:io';

import 'package:app_actasalinstante/NavBar.dart';
import 'package:app_actasalinstante/SplashScreen/Splashscreen1.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:im_animations/im_animations.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'dart:typed_data';

class SplashScreen2 extends StatefulWidget {
  const SplashScreen2({Key key}) : super(key: key);

  @override
  _SplashScreen2State createState() => _SplashScreen2State();
}

class _SplashScreen2State extends State<SplashScreen2> {
  @override
  void initState() {
    super.initState();
    GetImages();
    GetNames();
    getToken();
    // Welcomebakc();
  }

  String user = "";
  GetNames() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      user = prefs.getString('username');
    });
    print(user);
  }

  String Token = "";
  getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      Token = prefs.getString('token');
    });
  }

  var imagen;
//YA CASI SIRVE :/
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

    if (response.statusCode == 200) {
      print(bytes);
      setState(() {
        imagen = bytes;
      });

      print("Hola");
    }

    if (response.statusCode == 401) {
      // AnimationsError();

      prefs.remove('token');
      prefs.remove('username');
      await Future.delayed(Duration(seconds: 2));
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext ctx) => SplashScreen()));
    }

    return (bytes != null ? base64Encode(bytes) : null);
  }

  static const duration = Duration(milliseconds: 1000);
 
  double _containerHeight = double.infinity;
  Color _containerColor = Colors.blue;
  final ImagePicker _picker = ImagePicker();
  PickedFile _imageFile;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: const BoxDecoration(color: Colors.grey),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ColorSonar(
                      // wavesDisabled: true,
                      // waveMotion: WaveMotion.synced,
                      contentAreaRadius: 58.0,
                      waveFall: 15.0,
                      //  waveMotionEffect: Curves.fastLinearToSlowEaseIn,
                      waveMotion: WaveMotion.synced,
                      // duration: Duration(seconds: 5),

                      child: InkWell(
                          onTap: () {
                            final snackBar = SnackBar(
                              elevation: 0,
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.black,
                              content: Text(
                                "Bienvenido " + user.toString(),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                                textAlign: TextAlign.center,
                              ),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => NavBar()));
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(55.0),
                            child: CircleAvatar(
                              radius: 55.0,
                              child: imagen != null
                                  ? Image.memory(
                                      imagen,
                                      height: 100.0,
                                      width: 100.0,
                                      fit: BoxFit.fill,
                                    )
                                  : Image.asset(
                                      'assets/loginuser.png',
                                      height: 100.0,
                                      width: 100.0,
                                      fit: BoxFit.fill,
                                    ),
                            ),
                          )),
                    ),
                    Padding(padding: EdgeInsets.only(top: 10.0)),
                    SizedBox(
                      height: 40,
                    ),
                    Text(
                      "" + user.toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 29.0,
                          color: Colors.black),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            final snackBar = SnackBar(
                              elevation: 0,
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.black,
                              content: Text(
                                "Bienvenido " + user.toString(),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                                textAlign: TextAlign.center,
                              ),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
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
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 40, vertical: 15),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                color: Colors.black),
                            child: Text(
                              "Continuar",
                              style: GoogleFonts.lato(
                                textStyle:
                                    Theme.of(context).textTheme.headline4,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                fontStyle: FontStyle.italic,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () async {
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.QUESTION,
                              animType: AnimType.BOTTOMSLIDE,
                              title: 'Actas al instante',
                              desc:
                                  user.toString() + ' ¿quieres cerrar sesion?',
                              btnCancelOnPress: () {
                                //  Navigator.of(context).pop(true);
                              },
                              btnOkOnPress: () async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.remove('username');
                                prefs.remove('token');
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
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 40, vertical: 15),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                color: Colors.black),
                            child: Text(
                              "Cerrar Sesion",
                              style: GoogleFonts.lato(
                                textStyle:
                                    Theme.of(context).textTheme.headline4,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                fontStyle: FontStyle.italic,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    // SizedBox(
                    //   height: 10,
                    // ),
                    // new Center(
                    //   child: Card(
                    //     child: new Container(
                    //       child: Text(
                    //         "",
                    //         style: GoogleFonts.lato(
                    //           textStyle: Theme.of(context).textTheme.headline4,
                    //           fontSize: 16,
                    //           fontWeight: FontWeight.w700,
                    //           fontStyle: FontStyle.italic,
                    //           color: Colors.grey,
                    //         ),
                    //         textAlign: TextAlign.center,
                    //       ),
                    //       height: MediaQuery.of(context).size.width * 0.43,
                    //       width: MediaQuery.of(context).size.width * 0.43,
                    //       decoration: new BoxDecoration(
                    //         color: Colors.grey,
                    //         image: new DecorationImage(
                    //           fit: BoxFit.cover,
                    //           colorFilter: new ColorFilter.mode(
                    //               Colors.grey.withOpacity(0.2),
                    //               BlendMode.dstATop),
                    //           image: AssetImage('assets/Principal.gif'),
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
              // Expanded(
              //   flex: 1,
              // child: Column(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     CircularProgressIndicator.adaptive(value: 3.0,),
              //     Padding(padding: const EdgeInsets.only(top: 20.0))
              //   ],
              // ),)

              new Center(
                child: Text(
                  "Actas al instante",
                  style: GoogleFonts.lato(
                    textStyle: Theme.of(context).textTheme.headline4,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.italic,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
