import 'package:app_actasalinstante/DropDown/Body.dart';
import 'package:app_actasalinstante/RFC/RFC_Moral.dart';
import 'package:app_actasalinstante/RFCDescargas/views/homepage.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

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
import 'Modal_RFC.dart';

class trans extends StatefulWidget {
  const trans({key}) : super(key: key);

  @override
  _transState createState() => _transState();
}

class _transState extends State<trans> with SingleTickerProviderStateMixin {
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

  final Color color_Modal = HexColor("#424242");
  showdialog_Aler() {
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              title: Center(
                child: Text(
                  'Solicitar rfc'.toUpperCase(),
                  style: TextStyle(color: Colors.white),
                ),
              ),
              backgroundColor: color_Modal,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              content: Builder(
                builder: (context) {
                  // Get available height and width of the build area of this widget. Make a choice depending on the size.
                  var height = MediaQuery.of(context).size.height;
                  var width = MediaQuery.of(context).size.width;

                  return Container(
                    height: height - 20,
                    width: width - 20,
                    child: ModalRfc(),
                  );
                },
              ),
            ));
  }

  final Color color = HexColor('#D61C4E');

  final Color color_Card = HexColor('#01081f');
  var _currentSelectedValue;
  var _currentSelectedValueRFC;
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
      backgroundColor: color,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'RFC ' + user.toString(),
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
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40)),
                  color: Colors.white),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: Colors.transparent,
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        //   subheading('Active Projects'),
                        //  SizedBox(height: 5.0),

                        // Center(
                        //   child: Container(
                        //       decoration: BoxDecoration(
                        //         color: color_Card,
                        //         borderRadius: BorderRadius.circular(10.0),
                        //       ),
                        //       margin: EdgeInsets.only(top: 10),
                        //       child: SingleChildScrollView(
                        //           child: Padding(
                        //               padding: EdgeInsets.all(15.0),
                        //               child: Column(children: [
                        //                 Text(
                        //                   "Solicitudes".toUpperCase(),
                        //                   style: GoogleFonts.lato(
                        //                     textStyle: Theme.of(context)
                        //                         .textTheme
                        //                         .headline4,
                        //                     fontSize: 18,
                        //                     fontWeight: FontWeight.w700,
                        //                     fontStyle: FontStyle.italic,
                        //                     color: Colors.white,
                        //                   ),
                        //                   textAlign: TextAlign.start,
                        //                 ),
                        //                 Text(
                        //                   "\nPARA REVISAR O DESCARGAR TUS SOLICITUDES ENVIADAS, DA CLICK EN EL BÓTON",
                        //                   style: GoogleFonts.lato(
                        //                     textStyle: Theme.of(context)
                        //                         .textTheme
                        //                         .headline4,
                        //                     fontSize: 14,
                        //                     fontWeight: FontWeight.w700,
                        //                     fontStyle: FontStyle.italic,
                        //                     color: Colors.white,
                        //                   ),
                        //                   textAlign: TextAlign.justify,
                        //                 ),
                        //                 Padding(
                        //                   padding: EdgeInsets.symmetric(
                        //                       horizontal: 160),
                        //                   child: Container(
                        //                     padding: EdgeInsets.only(
                        //                         top: 1, left: 1),
                        //                     decoration: BoxDecoration(
                        //                         borderRadius:
                        //                             BorderRadius.circular(50),
                        //                         border: Border(
                        //                           bottom: BorderSide(
                        //                               color: Colors.black),
                        //                           top: BorderSide(
                        //                               color: Colors.black),
                        //                           left: BorderSide(
                        //                               color: Colors.black),
                        //                           right: BorderSide(
                        //                               color: Colors.black),
                        //                         )),
                        //                     child: MaterialButton(
                        //                       minWidth: double.infinity,
                        //                       height: 60,
                        //                       onPressed: () {

                        //                       },
                        //                       color: Colors.white,
                        //                       elevation: 0,
                        //                       shape: RoundedRectangleBorder(
                        //                         borderRadius:
                        //                             BorderRadius.circular(50),
                        //                       ),
                        //                       child: Text(
                        //                         "Ver".toUpperCase(),
                        //                         style: TextStyle(
                        //                           fontWeight: FontWeight.w600,
                        //                           fontSize: 18,
                        //                           color: Colors.black,
                        //                         ),
                        //                       ),
                        //                     ),
                        //                   ),
                        //                 ),
                        //               ])))),
                        // ),

                        SizedBox(width: 15.0),
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
                                          "Nuevo".toUpperCase(),
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
                                          "\nPARA SOLICITAR UN RFC DE PERSONA MORAL O FÍSICA, TOCA EN EL BÓTON.",
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
                                        SizedBox(height: 10.0),
                                        new Center(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(52),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 40, vertical: 8),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                MaterialButton(
                                                  onPressed: () {
                                                    showdialog_Aler();

                                                    // Send_RFC_CURP(
                                                    //     _currentSelectedValue.toString().toUpperCase(),
                                                    //     curpController.text.toString().toUpperCase(),
                                                    //     entidad.toString(),
                                                    //     ConReverso.toString());
                                                  },
                                                  child: Text(
                                                    "Nuevo".toUpperCase(),
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 18,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  textColor: Colors.black,
                                                ),
                                                Icon(
                                                  Icons.send,
                                                  size: 19,
                                                  color: Colors.black,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ])))),
                        ),
                      ],
                    ),
                  ),

                  if (_currentSelectedValue == "Moral")
                    Container(
                      color: Colors.transparent,
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          //   subheading('Active Projects'),
                          SizedBox(height: 5.0),

                          Row(
                            children: <Widget>[
                              Center(
                                child: Container(
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
                                                      pageBuilder: (context,
                                                          animation, _) {
                                                        return FadeTransition(
                                                          opacity: animation,
                                                          child: RFC_MORAL(),
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
                                                          BorderRadius.circular(
                                                              10.0),
                                                    ),
                                                    elevation: 0,
                                                    margin:
                                                        EdgeInsets.all(10.0),
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                "RFC MORAL",
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
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                  if (_currentSelectedValue == "Fisica")
                    Container(
                      color: Colors.transparent,
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
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
                                                    pageBuilder: (context,
                                                        animation, _) {
                                                      return FadeTransition(
                                                        opacity: animation,
                                                        child: RfcBody(),
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
                                                margin:
                                                    EdgeInsets.only(bottom: 8),
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
                                              "CURP",
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
                                                    pageBuilder: (context,
                                                        animation, _) {
                                                      return FadeTransition(
                                                        opacity: animation,
                                                        child: CurpRfcBody(),
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
                                                margin:
                                                    EdgeInsets.only(bottom: 8),
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

                  //               Row(
                  //                 mainAxisAlignment: MainAxisAlignment.center,
                  //                 children: [
                  //                   InkWell(
                  //                     onTap: () {

                  //                     },
                  //                     child: Column(
                  //                       children: [
                  //                         Container(
                  //                           height: 190,
                  //                           width: MediaQuery.of(context).size.width * 0.43,
                  //                           decoration: BoxDecoration(
                  //                             color: Color.fromARGB(255, 255, 255, 255),
                  //                             image: DecorationImage(
                  //                               image:
                  //                                   AssetImage('assets/BusquedaCurp.gif'),
                  //                             ),
                  //                             borderRadius:
                  //                                 BorderRadius.all(Radius.circular(26)),
                  //                           ),
                  //                         ),
                  //                         Text(
                  //                           "Curp",
                  //                           style: GoogleFonts.lato(
                  //                             textStyle:
                  //                                 Theme.of(context).textTheme.headline4,
                  //                             fontSize: 16,
                  //                             fontWeight: FontWeight.w700,
                  //                             fontStyle: FontStyle.italic,
                  //                             color: Colors.black,
                  //                           ),
                  //                         ),

                  //                       ],
                  //                     ),
                  //                   ),
                  //                   InkWell(
                  //                     onTap: () {
                  //                  Navigator.push(
                  //   context,
                  //   PageRouteBuilder(
                  //     pageBuilder: (context, animation, _) {
                  //       return FadeTransition(
                  //         opacity: animation,
                  //         child: CurpRfcBody(),
                  //       );
                  //     },
                  //     transitionDuration: duration,
                  //     reverseTransitionDuration: duration,
                  //   ),
                  // );
                  //                     },
                  //                     child: Column(
                  //                       children: [
                  //                         Container(
                  //                           height: 190,
                  //                           width: MediaQuery.of(context).size.width * 0.43,
                  //                           decoration: BoxDecoration(
                  //                             color: Color.fromARGB(255, 255, 255, 255),
                  //                             image: DecorationImage(
                  //                               image: AssetImage('assets/rfc.gif'),
                  //                             ),
                  //                             borderRadius:
                  //                                 BorderRadius.all(Radius.circular(29)),
                  //                           ),
                  //                         ),
                  //                         SizedBox(
                  //                           height: 10,
                  //                         ),
                  //                         Text(
                  //                           "RFC",
                  //                           style: GoogleFonts.lato(
                  //                             textStyle:
                  //                                 Theme.of(context).textTheme.headline4,
                  //                             fontSize: 16,
                  //                             fontWeight: FontWeight.w700,
                  //                             fontStyle: FontStyle.italic,
                  //                             color: Colors.black,
                  //                           ),
                  //                         ),

                  //                       ],
                  //                     ),
                  //                   ),
                  //                 ],
                  //               ),
                  //             SizedBox(
                  //               height: 80,
                  //             ),
                  // Expanded(
                  //   child: Container(),
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
              child: RfcBody(),
            );
          },
          transitionDuration: duration,
          reverseTransitionDuration: duration,
        ),
      );

      // Navigator.push(
      //     context, MaterialPageRoute(builder: (context) => RfcBody()));
    } else if (selectedType == "RFC") {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, _) {
            return FadeTransition(
              opacity: animation,
              child: CurpRfcBody(),
            );
          },
          transitionDuration: duration,
          reverseTransitionDuration: duration,
        ),
      );
    } else if (selectedType == "RFC_MORAL") {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, _) {
            return FadeTransition(
              opacity: animation,
              child: RFC_MORAL(),
            );
          },
          transitionDuration: duration,
          reverseTransitionDuration: duration,
        ),
      );
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
  }
}
