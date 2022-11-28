import 'dart:convert';
import 'dart:io';

import 'package:app_actasalinstante/Detalles/profile_page.dart';
import 'package:app_actasalinstante/DropDown/Body.dart';
import 'package:app_actasalinstante/DropDown/TransicionActas.dart';
import 'package:app_actasalinstante/RFCDescargas/views/homepage.dart';
import 'package:app_actasalinstante/constants.dart';
import 'package:app_actasalinstante/login.dart';
import 'package:app_actasalinstante/recent_files_json.dart';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:responsive_framework/responsive_wrapper.dart';

import '../ColorScheme.dart';
import '../DropDown/DropDown.dart';
import '../Inicio/InicioActas.dart';
import '../LoginView/api/model/login_model.dart';
import '../NavBar.dart';
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

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key key}) : super(key: key);
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

LoginRequestModel loginRequestModel;
FetchUserLists _userList = FetchUserLists();

Userlists user = Userlists();

class _ProfilePageState extends State<ProfilePage> {
  List imgList = [
    'assets/MATRIMONIO.jpg',
    'assets/DEFUNCION.jpg',
    'assets/NACIMIENTO.jpg',
    'assets/RFC.jpg',
  ];
  List<Contact> _contacts;
  bool _permissionDenied = false;

  @override
  void initState() {
    super.initState();
    _fetchContacts();

    // Putnames(_contacts.toString());
  }

  var contac;
  var data = [];
  String names, lastname, email;

  Putnames(String names, String lastname, String phone, String email,
      int ids) async {
    Map<String, String> mainheader = new Map();
    mainheader["content-type"] = "application/json";
    mainheader['x-access-token'] = getIt<AuthModel>().token;
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
    var datas = json.decode(response.body);
    // print(datas);
    // setState(() {
    //   data = resBody;
    //   print(data);
    // });
    if (response.statusCode == 200) {
      //_controller.sendNotification();
      datas = jsonDecode(response.body);
      //   print(datas);
    } else {
      print("fetch error");
      print(datas);
    }

    // return results;
  }

  SendContact(Contact contact) async {
    //print(contact.displayName.length.toString());
    //contact.phones.forEach((element) => {print(element.toString())});
    //  print(contact.displayName.toString());
    // print(
    //     'Telefono: ${contact.phones.isNotEmpty ? contact.phones.first.number : '(none)'}');
    // print(
    //     'Correo: ${contact.emails.isNotEmpty ? contact.emails.first.address : '(none)'}');
    // print('Nombres: ${contact.name.first}');
    // print('Apellidos: ${contact.name.last}');
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
    } else {
      final contacts = await FlutterContacts.getContacts();
      _contacts = contacts;
      setState(() => _contacts = contacts);

      for (var i = 0; i < _contacts.length; i++) {
        final fullContact = await FlutterContacts.getContact(_contacts[i].id);
        // print(contacts[i]);
        // contac = contacts[i];
        // contac.displayName.toString();
        // print(contac.displayName.toString());
        SendContact(fullContact);
      }
    }
  }

  String selectedType = "initial";
  String selectedFrequency = "monthly";
  int selectedIndex;
  final ImagePicker _picker = ImagePicker();
  PickedFile _imageFile;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          backgroundColor: Colors.grey,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: Text('Actas Al Instante ',
                style: GoogleFonts.lato(
                  textStyle: Theme.of(context).textTheme.headline4,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.italic,
                  color: Colors.black,
                )),
            elevation: 0,
            backgroundColor: Colors.grey,
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // if (_permissionDenied) Center(child: Text('Permiso denegado')),
              // if (_contacts == null) Center(child: CircularProgressIndicator()),
              imageProfile(),
              new Center(
                child: Text("" + getIt<AuthModel>().usuario,
                    style: GoogleFonts.lato(
                      textStyle: Theme.of(context).textTheme.headline4,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.italic,
                      color: Colors.black,
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
                      color: Colors.white),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //card
                      // Container(
                      //   padding:
                      //       EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      //   child: Card(
                      //     elevation: 5,
                      //     child: Column(
                      //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //       crossAxisAlignment: CrossAxisAlignment.start,
                      //       children: <Widget>[
                      //         Row(
                      //           children: <Widget>[
                      //             // Expanded(
                      //             //   child: Column(
                      //             //     crossAxisAlignment:
                      //             //         CrossAxisAlignment.start,
                      //             //     mainAxisAlignment:
                      //             //         MainAxisAlignment.spaceBetween,
                      //             //     children: <Widget>[
                      //             //       Container(
                      //             //         child: Column(
                      //             //           children: [
                      //             //             Text(
                      //             //               "Tienes: " +
                      //             //                   data.length.toString() +
                      //             //                   " Actas",
                      //             //               maxLines: 2,
                      //             //               style: TextStyle(
                      //             //                   fontSize: 16,
                      //             //                   fontFamily: 'avenir',
                      //             //                   fontWeight: FontWeight.w800,
                      //             //                   color: Colors.black),
                      //             //               overflow: TextOverflow.ellipsis,
                      //             //             ),
                      //             //           ],
                      //             //         ),
                      //             //       ),
                      //             //     ],
                      //             //   ),
                      //             // ),
                      //             Container(
                      //               child: Image.network(
                      //                   'https://picsum.photos/250?image=9',
                      //                   width: 60),
                      //             )
                      //           ],
                      //         )
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      //  FIN CARD
                      // Positioned(
                      //   bottom: 1.0,
                      //   right: 10.0,
                      //   child: InkWell(
                      //     onTap: () {

                      //     },
                      //     child: (
                      //       Icons.notification_add,
                      //       color: Colors.teal,
                      //       size: 32.0,
                      //     ),Icon
                      //   ),
                      // ),

                      //Banner

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
                      // banner en entrada
                      //Fin Banner
                      //getRecentFiles(),
                      SizedBox(
                        height: 20,
                      ),
                      new Center(
                        child: Text(
                          "Selecciona el servicio: " +
                              getIt<AuthModel>().usuario,
                          style: GoogleFonts.lato(
                            textStyle: Theme.of(context).textTheme.headline4,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.italic,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              changeCleaningType("Actas");
                            },
                            child: Column(
                              children: [
                                // Container(
                                //   child: InkWell(
                                //     onTap: () {
                                //       Navigator.push(
                                //           context,
                                //           MaterialPageRoute(
                                //               builder: (context) =>
                                //                   transactas()));
                                //     },
                                //     child: Container(
                                //       height: 100,
                                //       width: MediaQuery.of(context).size.width *
                                //           0.43,
                                //       decoration: BoxDecoration(
                                //         color: Colors.white,
                                //         image: DecorationImage(
                                //           image: AssetImage('assets/actas.gif'),
                                //         ),
                                //         borderRadius: BorderRadius.all(
                                //             Radius.circular(56)),
                                //       ),
                                //     ),
                                //   ),
                                // ),
                                Container(
                                  height: 100,
                                  width:
                                      MediaQuery.of(context).size.width * 0.43,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    image: DecorationImage(
                                      image: AssetImage('assets/actas.gif'),
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(56)),
                                  ),
                                ),
                                SizedBox(
                                  height: 1,
                                ),
                                Text(
                                  "Actas",
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
                                          color: Colors.redAccent,
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
                                  height: 100,
                                  width:
                                      MediaQuery.of(context).size.width * 0.43,
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
                                  height: 1,
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
                                          color: Colors.blueAccent,
                                          size: 40,
                                        )
                                      : Container(),
                                )
                              ],
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
                            onTap: OnchangeActas,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 15),
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  color: Colors.grey),
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
        ),
        onWillPop: _onWillPopScope);
  }

  void changeCleaningType(String type) {
    selectedType = type;
    print(selectedType.toString());
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
          context, MaterialPageRoute(builder: (context) => transactas()));
    } else if (selectedType == "RFC") {
      Navigator.push(context, MaterialPageRoute(builder: (context) => trans()));
    } else {
      print(selectedType.toString());
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
      // print("Selecciona un servicio");
    }
  }

  GlobalKey _NavKey = GlobalKey();

  

  Widget Logout() {
    return Center(
      child: Stack(children: <Widget>[
        CircleAvatar(
          radius: 28.0,
          backgroundImage: _imageFile == null
              ? AssetImage("assets/loginuser.png")
              : FileImage(File(_imageFile.path)),
        ),
        Positioned(
          bottom: 1.0,
          right: 10.0,
          child: InkWell(
            onTap: () {},
            child: Icon(
              Icons.logout,
              color: Colors.teal,
              size: 22.0,
            ),
          ),
        ),
      ]),
    );
  }

  Widget imageProfile() {
    return Center(
      child: Stack(
        children: <Widget>[
          CircleAvatar(
            radius: 30.0,
            backgroundImage: _imageFile == null
                ? AssetImage("assets/loginuser.png")
                : FileImage(File(_imageFile.path)),
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
                              takePhoto(ImageSource.camera);
                            },
                          ),
                          ListTile(
                            leading: new Icon(Icons.photo),
                            title: new Text('Galeria'),
                            onTap: () {
                              takePhoto(ImageSource.gallery);
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
                                desc: getIt<AuthModel>().usuario +
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
                          ),

      
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
                // showModalBottomSheet(
                //   context: context,
                //   builder: ((builder) => bottomSheet()),
                // );
              },
              child: Icon(
                Icons.settings,
                color: Colors.yellowAccent,
                size: 30.0,
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
              getIt<AuthModel>().usuario + "",
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
                        desc: getIt<AuthModel>().usuario +
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

  void takePhoto(ImageSource source) async {
    final pickedFile = await _picker.getImage(
      source: source,
    );
    setState(() {
      _imageFile = pickedFile;
    });
  }

  Future<bool> _onWillPopScope() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.QUESTION,
      animType: AnimType.BOTTOMSLIDE,
      title: 'Actas al instante',
      desc: getIt<AuthModel>().usuario + ' ¿quieres salir de la aplicación?',
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
