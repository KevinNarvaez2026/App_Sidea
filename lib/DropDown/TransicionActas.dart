import 'package:app_actasalinstante/DropDown/Body.dart';
import 'package:app_actasalinstante/DropDown/CadenaDigital.dart';
import 'package:app_actasalinstante/DropDown/DatosPersonales.dart';
import 'package:app_actasalinstante/RFCDescargas/views/homepage.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:animated_background/animated_background.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lottie/lottie.dart';
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

class transactas extends StatefulWidget {
  const transactas({key}) : super(key: key);

  @override
  _transactasState createState() => _transactasState();
}

class _transactasState extends State<transactas>
    with SingleTickerProviderStateMixin {
  // create animation controller
  AnimationController _animationController;
  AnimationController _controller;
  // initialise animation controller
  @override
  void initState() {
    super.initState();
    GetNames();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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

  static const duration = Duration(milliseconds: 800);
  static const fastDuration = Duration(milliseconds: 500);
  List imgList = [
    'assets/MATRIMONIO.jpg',
    'assets/DEFUNCION.jpg',
    'assets/NACIMIENTO.jpg',
    'assets/RFC.jpg',
  ];
  String selectedType = "initial";
  String selectedFrequency = "monthly";
  final Color color = HexColor('#D61C4E');

  final Color color_Card = HexColor('#01081f');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          '' + user.toString(),
          style: GoogleFonts.lato(
            textStyle: Theme.of(context).textTheme.headline4,
            fontSize: 22,
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.italic,
            color: Colors.white,
          ),
        ),
        elevation: 0,
        backgroundColor: color,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)),
                  color: Colors.white),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: Colors.transparent,
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(width: 9.0),
                        Center(
                          child: Container(
                              decoration: BoxDecoration(
                                color: color_Card,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              margin: EdgeInsets.only(top: 10),
                              child: SingleChildScrollView(
                                  child: Padding(
                                      padding: EdgeInsets.all(15.0),
                                      child: Column(children: [
                                        Text(
                                          "ACTAS",
                                          style: GoogleFonts.lato(
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .headline4,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                            fontStyle: FontStyle.italic,
                                            color: Colors.white,
                                          ),
                                          textAlign: TextAlign.start,
                                        ),
                                        Text(
                                          "\nPARA SOLICITAR UN ACTA DE NACIMIENTO, DEFUNCIÓN, DIVORCIO Y MATRIMONIO, TOCA EN EL BÓTON.",
                                          style: GoogleFonts.lato(
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .headline4,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            fontStyle: FontStyle.italic,
                                            color: Colors.white,
                                          ),
                                          textAlign: TextAlign.justify,
                                        ),
                                      ])))),
                        ),
                        //   subheading('Active Projects'),
                        SizedBox(height: 5.0),

                        Row(
                          children: <Widget>[
                            Container(
                                decoration: BoxDecoration(
                                  color: color_Card,
                                  borderRadius: BorderRadius.circular(30.0),
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
                                                  pageBuilder:
                                                      (context, animation, _) {
                                                    return FadeTransition(
                                                      opacity: animation,
                                                      child: Body(),
                                                    );
                                                  },
                                                  transitionDuration: duration,
                                                  reverseTransitionDuration:
                                                      duration,
                                                ),
                                              );
                                            },
                                            child: Container(
                                              margin:
                                                  EdgeInsets.only(bottom: 8),
                                              height: 100,
                                              child: Card(
                                                color: color_Card,
                                                semanticContainer: true,
                                                clipBehavior:
                                                    Clip.antiAliasWithSaveLayer,
                                                child: Image.asset(
                                                  'assets/NEW_Acta.png',
                                                  fit: BoxFit.fill,
                                                ),
                                                //shadowColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                                elevation: 0,
                                                margin: EdgeInsets.all(10.0),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            "SOLICITAR ACTAS",
                                            style: GoogleFonts.lato(
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .headlineMedium,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700,
                                              fontStyle: FontStyle.italic,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ])))),
                            SizedBox(width: 25.0),
                            // Container(
                            //     decoration: BoxDecoration(
                            //       color: color_Card,
                            //       borderRadius: BorderRadius.circular(30.0),
                            //     ),
                            //     margin: EdgeInsets.only(top: 10),
                            //     child: SingleChildScrollView(
                            //         child: Padding(
                            //             padding: EdgeInsets.all(17.0),
                            //             child: Column(children: [
                            //               InkWell(
                            //                 onTap: () {
                            //                   Navigator.push(
                            //                     context,
                            //                     PageRouteBuilder(
                            //                       pageBuilder:
                            //                           (context, animation, _) {
                            //                         return FadeTransition(
                            //                           opacity: animation,
                            //                           child: trans(),
                            //                         );
                            //                       },
                            //                       transitionDuration: duration,
                            //                       reverseTransitionDuration:
                            //                           duration,
                            //                     ),
                            //                   );
                            //                 },
                            //                 child: Container(
                            //                   margin:
                            //                       EdgeInsets.only(bottom: 8),
                            //                   height: 100,
                            //                   child: Card(
                            //                     color: color_Card,
                            //                     semanticContainer: true,
                            //                     clipBehavior:
                            //                         Clip.antiAliasWithSaveLayer,
                            //                     child: Image.asset(
                            //                       'assets/NEW_RFC.png',
                            //                       fit: BoxFit.fill,
                            //                     ),
                            //                     //shadowColor: Colors.white,
                            //                     shape: RoundedRectangleBorder(
                            //                       borderRadius:
                            //                           BorderRadius.circular(
                            //                               10.0),
                            //                     ),
                            //                     elevation: 0,
                            //                     margin: EdgeInsets.all(10.0),
                            //                   ),
                            //                 ),
                            //               ),
                            //               Text(
                            //                 "RFC",
                            //                 style: GoogleFonts.lato(
                            //                   textStyle: Theme.of(context)
                            //                       .textTheme
                            //                       .headlineMedium,
                            //                   fontSize: 16,
                            //                   fontWeight: FontWeight.w700,
                            //                   fontStyle: FontStyle.italic,
                            //                   color: Colors.white,
                            //                 ),
                            //               ),
                            //             ])))),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 1,
                  ),

                  //BUSQUEDA POR DATOS PERSONALES
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     InkWell(
                  //       onTap: () {
                  //         changeCleaningType("Personales");
                  //       },
                  //       child: Column(
                  //         children: [
                  //           Container(
                  //             height: 100,
                  //             width: MediaQuery.of(context).size.width * 0.44,
                  //             decoration: BoxDecoration(
                  //               color: Color.fromARGB(255, 255, 255, 255),
                  //               image: DecorationImage(
                  //                 image: AssetImage('assets/datosP.gif'),
                  //               ),
                  //               borderRadius:
                  //                   BorderRadius.all(Radius.circular(26)),
                  //             ),
                  //           ),
                  //           SizedBox(
                  //             height: 10,
                  //           ),
                  //           Text(
                  //             "Busqueda por Datos Personales",
                  //             style: TextStyle(fontWeight: FontWeight.w600),
                  //           ),
                  //           SizedBox(
                  //             height: 10,
                  //           ),
                  //           Container(
                  //             height: 40,
                  //             width: 40,
                  //             decoration: BoxDecoration(
                  //               shape: BoxShape.circle,
                  //               color: Color(0xffededed),
                  //             ),
                  //             child: (selectedType == "Personales")
                  //                 ? Icon(
                  //                     Icons.check_circle,
                  //                     color: pink,
                  //                     size: 40,
                  //                   )
                  //                 : Container(),
                  //           )
                  //         ],
                  //       ),
                  //     ),
                  //     // InkWell(
                  //     //   onTap: () {
                  //     //     changeCleaningType("Civil");
                  //     //   },
                  //     //   child: Column(
                  //     //     children: [
                  //     //       Container(
                  //     //         height: 5,
                  //     //         width: MediaQuery.of(context).size.width * 0.43,
                  //     //         decoration: BoxDecoration(
                  //     //           color: Color.fromARGB(255, 255, 255, 255),
                  //     //           borderRadius:
                  //     //               BorderRadius.all(Radius.circular(9)),
                  //     //         ),
                  //     //       ),
                  //     //     ],
                  //     //   ),
                  //     // )
                  //   ],
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void changeCleaningType(String type) {
    selectedType = type;
    setState(() {});
  }

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

  void OnchangeActas() {
    if (selectedType == "Actas") {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, _) {
            return FadeTransition(
              opacity: animation,
              child: Body(),
            );
          },
          transitionDuration: duration,
          reverseTransitionDuration: duration,
        ),
      );
    } else if (selectedType == "Cadena") {
      // Navigator.push(
      //   context,
      //   PageRouteBuilder(
      //     pageBuilder: (context, animation, _) {
      //       return FadeTransition(
      //         opacity: animation,
      //         child: CadenaDigital(),
      //       );
      //     },
      //     transitionDuration: duration,
      //     reverseTransitionDuration: duration,
      //   ),
      // );
    } else if (selectedType == "Personales") {
      // Lottie.asset(
      //   'assets/login.json',
      //   controller: _controller,
      //   onLoaded: (composition) {
      //     // Configure the AnimationController with the duration of the
      //     // Lottie file and start the animation.
      //     _controller
      //       ..duration = composition.duration
      //       ..forward().then((value) => Navigator.of(context)
      //           .push(MaterialPageRoute(builder: (context) => NavBar())));
      //   },
      // );
      // print(_controller);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => DatosPersonales()));
    } else {
      print(selectedType.toString());
      var snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Selecciona un servicio!',
          message: '',
          contentType: ContentType.failure,
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      // print("Selecciona un servicio");
    }
    // @override
    // Widget build(BuildContext context) {
    //   return Scaffold(

    //       body: Center(

    //     child: GestureDetector(
    //       onTap: _iconTapped,

    //       child: AnimatedIcon(
    //         progress: _animationController,
    //         icon: AnimatedIcons.arrow_menu,
    //         size: 200,

    //       ),
    //     ),

    //   ),

    //   );
    // }
  }
}
