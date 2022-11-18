import 'package:app_actasalinstante/DropDown/Body.dart';
import 'package:app_actasalinstante/RFC/RFC_Moral.dart';
import 'package:app_actasalinstante/RFCDescargas/views/homepage.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:animated_background/animated_background.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../ColorScheme.dart';
import '../DropDown/DropDown.dart';
import '../Inicio/InicioActas.dart';
import '../NavBar.dart';
import '../RFC/RfcBody.dart';
import '../RFC/Transicion.dart';
import '../RFCDescargas/services/Variables.dart';
import '../views/homepage.dart';
import 'Curpfile.dart';

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
  var _currentSelectedValue;
  String label = "Persona";
  var _currencies = ["Fisica", "Moral"];
  String selectedType = "initial";
  String selectedFrequency = "monthly";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 127,137,146),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          '' + user.toString(),
          style: GoogleFonts.lato(
            textStyle: Theme.of(context).textTheme.headline4,
            fontSize: 22,
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.italic,
            color: Colors.black,
          ),
        ),
        elevation: 0,
        backgroundColor: Color.fromARGB(255, 127,137,146),
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
                  // Flexible(
                  //   fit: FlexFit.loose,
                  //   flex: 300,
                  //   child: Container(
                  //     height: 300,
                  //     child: ListView.builder(
                  //       itemCount: imgList.length,
                  //       itemBuilder: (BuildContext context, int index) {
                  //         return Column(
                  //           children: <Widget>[
                  //             CarouselSlider(
                  //               options: CarouselOptions(
                  //                 height: 290.0,
                  //                 enlargeCenterPage: true,
                  //                 autoPlay: true,
                  //                 aspectRatio: 16 / 9,
                  //                 autoPlayCurve: Curves.easeInBack,
                  //                 enableInfiniteScroll: true,
                  //                 autoPlayAnimationDuration:
                  //                     Duration(milliseconds: 900),
                  //                 viewportFraction: 0.8,
                  //               ),
                  //               items: imgList.map((item) {
                  //                 return Padding(
                  //                   padding: const EdgeInsets.only(left: 1.0),
                  //                   child: Container(
                  //                     height: 300,
                  //                     margin:
                  //                         EdgeInsets.symmetric(vertical: 20),
                  //                     decoration: BoxDecoration(
                  //                       color: Colors.white,
                  //                       borderRadius: BorderRadius.circular(10),
                  //                       boxShadow: [
                  //                         BoxShadow(
                  //                           color: Colors.black,
                  //                           blurRadius: 4,
                  //                           spreadRadius: 4,
                  //                         ),
                  //                       ],
                  //                     ),
                  //                     child: Image.asset(
                  //                       '$item',
                  //                       fit: BoxFit.fill,
                  //                     ),
                  //                   ),
                  //                 );
                  //               }).toList(),
                  //             ),
                  //           ],
                  //         );
                  //       },
                  //     ),
                  //   ),
                  // ),

                  Text(
                    "Selecciona el servicio: " + user.toString(),
                    style: GoogleFonts.lato(
                      textStyle: Theme.of(context).textTheme.headline4,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.italic,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  FormField<String>(
                    builder: (FormFieldState<String> state) {
                      return InputDecorator(
                        decoration: InputDecoration(
                            label: Text(label.toString()),
                            errorStyle: TextStyle(
                                color: Colors.redAccent, fontSize: 16.0),
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
                  if (_currentSelectedValue == null)
                    SizedBox(
                      height: 100,
                    ),
                  if (_currentSelectedValue == null)
                    new Center(
                      child: Card(
                        child: new Container(
                          child: Text(
                            "Actas al instante",
                            style: GoogleFonts.lato(
                              textStyle: Theme.of(context).textTheme.headline4,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.italic,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          height: MediaQuery.of(context).size.width * 0.43,
                          width: MediaQuery.of(context).size.width * 0.43,
                          decoration: new BoxDecoration(
                            color: Colors.white,
                            image: new DecorationImage(
                              fit: BoxFit.cover,
                              colorFilter: new ColorFilter.mode(
                                  Colors.black.withOpacity(0.2),
                                  BlendMode.dstATop),
                              image: AssetImage('assets/Principal.gif'),
                            ),
                          ),
                        ),
                      ),
                    ),

                  if (_currentSelectedValue == "Moral")
                    new Center(
                      child: InkWell(
                        onTap: () {
                          changeCleaningType("RFC_MORAL");
                        },
                        child: Column(
                          children: [
                            Container(
                              height: 190,
                              width: MediaQuery.of(context).size.width * 0.43,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 255, 255, 255),
                                image: DecorationImage(
                                  image: AssetImage('assets/rfc.gif'),
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(26)),
                              ),
                            ),
                            Text(
                              "RFC Moral",
                              style: GoogleFonts.lato(
                                textStyle:
                                    Theme.of(context).textTheme.headline4,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                fontStyle: FontStyle.italic,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xffededed),
                              ),
                              child: (selectedType == "RFC_MORAL")
                                  ? Icon(
                                      Icons.check_circle,
                                      color: pink,
                                      size: 40,
                                    )
                                  : Container(),
                            )
                          ],
                        ),
                      ),
                    ),

                  if (_currentSelectedValue == "Fisica")
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            changeCleaningType("Actas");
                          },
                          child: Column(
                            children: [
                              Container(
                                height: 190,
                                width: MediaQuery.of(context).size.width * 0.43,
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  image: DecorationImage(
                                    image:
                                        AssetImage('assets/BusquedaCurp.gif'),
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(26)),
                                ),
                              ),
                              Text(
                                "RFC por curp",
                                style: GoogleFonts.lato(
                                  textStyle:
                                      Theme.of(context).textTheme.headline4,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xffededed),
                                ),
                                child: (selectedType == "Actas")
                                    ? Icon(
                                        Icons.check_circle,
                                        color: pink,
                                        size: 40,
                                      )
                                    : Container(),
                              )
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            changeCleaningType("RFC");
                          },
                          child: Column(
                            children: [
                              Container(
                                height: 190,
                                width: MediaQuery.of(context).size.width * 0.43,
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  image: DecorationImage(
                                    image: AssetImage('assets/rfc.gif'),
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(29)),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "RFC",
                                style: GoogleFonts.lato(
                                  textStyle:
                                      Theme.of(context).textTheme.headline4,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xffededed),
                                ),
                                child: (selectedType == "RFC")
                                    ? Icon(
                                        Icons.check_circle,
                                        color: pink,
                                        size: 40,
                                      )
                                    : Container(),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  SizedBox(
                    height: 80,
                  ),
                  // Expanded(
                  //   child: Container(),
                  // ),
                  if (_currentSelectedValue == "Fisica")
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: OnchangeActas,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 60, vertical: 15),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                color: Color.fromARGB(255, 127,137,146),),
                            child: Text(
                              "Solicitar",
                              style: GoogleFonts.lato(
                                textStyle:
                                    Theme.of(context).textTheme.headline4,
                                fontSize: 19,
                                fontWeight: FontWeight.w700,
                                fontStyle: FontStyle.italic,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),

                  if (_currentSelectedValue == "Moral")
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: OnchangeActas,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 60, vertical: 15),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                color: Color.fromARGB(255, 127,137,146),),
                            child: Text(
                              "Solicitar",
                              style: GoogleFonts.lato(
                                textStyle:
                                    Theme.of(context).textTheme.headline4,
                                fontSize: 19,
                                fontWeight: FontWeight.w700,
                                fontStyle: FontStyle.italic,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
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

    Widget buildColoredCard() => Card(
          //shadowColor: Colors.green,
          elevation: 8,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Container(
            padding: EdgeInsets.all(46),
            child: Column(
              children: [
                IconButton(
                  icon: Icon(Icons.document_scanner),
                  iconSize: 120,
                  color: Colors.blue,
                  tooltip: 'Tramita tus Actas',
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => RfcBody()));
                  },
                ),
                Text(
                  "CURP",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                IconButton(
                  icon: Icon(Icons.document_scanner_outlined),
                  iconSize: 120,
                  color: Colors.blue,
                  tooltip: 'Tramita tus RFC',
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => CurpRfcBody()));
                  },
                ),
                Text(
                  "RFC",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );

    Widget buildColoredCard2() => Card(
          shadowColor: Colors.black,
          elevation: 8,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blue,
                  Colors.blue,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selecciona el tipo de busqueda de RFC',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );

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
