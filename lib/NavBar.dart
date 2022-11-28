import 'dart:convert';

import 'package:app_actasalinstante/Cortes/cortes.dart';
import 'package:app_actasalinstante/Cortes/datesCortes.dart';
import 'package:app_actasalinstante/DrawerItem.dart';
import 'package:app_actasalinstante/SplashScreen/Splashscreen1.dart';
import 'package:app_actasalinstante/Widgets/carousel_example.dart';
import 'package:app_actasalinstante/login.dart';
import 'package:app_actasalinstante/services/SearchapiACTAS/Api_service.dart';
import 'package:app_actasalinstante/services/SearchapiACTAS/HomeScreen.dart';

import 'package:app_actasalinstante/views/homepage.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Cortes/Cortes_Usuarios/HomeScreen_Cortes.dart';
import 'DropDown/Body.dart';
import 'DropDown/DropDown.dart';
import 'Inicio/InicioActas.dart';
import 'RFC/RfcBody.dart';
import 'package:ionicons/ionicons.dart';
import 'RFCDescargas/SearchapiRFC/Api_service.dart';
import 'RFCDescargas/SearchapiRFC/HomeScreen.dart';
import 'RFCDescargas/services/Variables.dart';
import 'RFCDescargas/views/homepage.dart';
import 'Robots/HomeScreen_Robots.dart';
import 'profile_pic.dart';
import 'dart:io' show File, Platform, exit;
import 'package:flutter/services.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:unicons/unicons.dart';
import 'package:google_fonts/google_fonts.dart';

class NavBar extends StatefulWidget {
  const NavBar({key}) : super(key: key);

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  logout() {
    // var tokendestroy;
    // tokendestroy = getIt<AuthModel>().token;
    // print(tokendestroy);
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => SplashScreen()),
        (Route<dynamic> route) => false);
    //  exit(0);

    //  child: TuWidget(),
  }

  @override
  void initState() {
    super.initState();
    getToken();
  }

  String Token = "";
  getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      Token = prefs.getString('token');
    });
    get_Rol();
  }

  var rol;
  get_Rol() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      Token = prefs.getString('token');
    });
    Map<String, String> mainheader = new Map();
    mainheader["content-type"] = "application/json";
    mainheader['x-access-token'] = Token;

    Response response = await get(
      Uri.parse('https://actasalinstante.com:3030/api/user/myData/'),
      headers: mainheader,
    );
    var GetRobots = jsonDecode(response.body.toString());

    print(GetRobots);
    setState(() {
      rol = GetRobots['rol'];
      print(rol);
    });
  }

  // const NavBar({key}) : super(key: key);
  GlobalKey _NavKey = GlobalKey();
  FetchUserLists _userList = FetchUserLists();
  var PagesAll = [
    CarouselExample(),
    SERACHACTAS(),
    SERACHRFC(),
    Cortes_Screen(),
    Robots()
  ];

  var myindex = 0;

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, String>;

    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.white,
        key: _NavKey,
        items: [
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              new Center(
                child: Icon(
                  (myindex == 0) ? Icons.home_outlined : Icons.home,
                  color: Color.fromARGB(255, 127, 137, 146),
                ),
              ),
              new Center(
                child: Text(
                  ' Inicio',
                  style: GoogleFonts.lato(
                    textStyle: Theme.of(context).textTheme.headline4,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.italic,
                    color: Color.fromARGB(255, 127, 137, 146),
                  ),
                ),
              ),
              // Text(' to add'),
            ],
          ),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              new Center(
                child: Icon(
                  (myindex == 1)
                      ? Ionicons.documents_outline
                      : Ionicons.documents,
                  color: Color.fromARGB(255, 127, 137, 146),
                ),
              ),
              new Center(
                child: Text('Actas',
                    style: GoogleFonts.lato(
                      textStyle: Theme.of(context).textTheme.headline4,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.italic,
                      color: Color.fromARGB(255, 127, 137, 146),
                    )),
              ),
            ],
          ),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              new Center(
                child: Icon(
                  (myindex == 2)
                      ? Ionicons.document_outline
                      : Ionicons.document,
                  color: Color.fromARGB(255, 127, 137, 146),
                ),
              ),
              new Center(
                child: Text('RFC',
                    style: GoogleFonts.lato(
                      textStyle: Theme.of(context).textTheme.headline4,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.italic,
                      color: Color.fromARGB(255, 127, 137, 146),
                    )),
              ),
            ],
          ),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              new Center(
                child: Icon(
                  (myindex == 3) ? Icons.settings_outlined : Icons.settings,
                  color: Color.fromARGB(255, 127, 137, 146),
                ),
              ),
              new Center(
                child: Text(' Corte ',
                    style: GoogleFonts.lato(
                      textStyle: Theme.of(context).textTheme.headline4,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.italic,
                      color: Color.fromARGB(255, 127, 137, 146),
                    )),
              ),
            ],
          ),
          if (rol == 'Admin')
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                new Center(
                  child: Icon(
                    (myindex == 4) ? Icons.wysiwyg_outlined : Icons.wysiwyg,
                    color: Colors.amber,
                  ),
                ),
                new Center(
                  child: Text(' Robots ',
                      style: GoogleFonts.lato(
                        textStyle: Theme.of(context).textTheme.headline4,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.italic,
                        color: Colors.amber,
                      )),
                ),
              ],
            ),
          // Wrap(
          //WordList(this._wordModal);
          //   crossAxisAlignment: WrapCrossAlignment.center,
          //   children: [
          //     Icon((myindex == 4 && logout())
          //         ? Icons.logout
          //         : Icons.logout_outlined),
          //     Text(' Cerrar '),
          //     Text('Sesion'),
          //   ],
          // ),
        ],
        buttonBackgroundColor: Colors.black,
        onTap: (index) {
          setState(() {
            myindex = index;
          });
        },
        animationCurve: Curves.fastLinearToSlowEaseIn,
        color: Colors.black,
      ),
      body: PagesAll[myindex],
    );
  }

  void onItemPressed(BuildContext context, {int index}) {
    Navigator.pop(context);

    switch (index) {
      case 0:
        // Navigator.push(context, MaterialPageRoute(builder: (context) => const People()));
        break;
    }
  }
}
