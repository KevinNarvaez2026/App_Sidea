import 'package:android_intent/android_intent.dart';
import 'package:android_intent/flag.dart';
import 'package:app_actasalinstante/ColorScheme.dart';
import 'package:app_actasalinstante/DropDown/TransicionActas.dart';
import 'package:app_actasalinstante/RFC/Transicion.dart';
import 'package:app_actasalinstante/SplashScreen/SplashLogin.dart';

import 'package:app_actasalinstante/services/SearchapiACTAS/Api_service.dart';

import 'package:app_actasalinstante/services/SearchapiACTAS/search.dart';
import 'package:app_actasalinstante/services/SearchapiACTAS/user_model.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:http/http.dart' as http;
import 'package:app_actasalinstante/RFCDescargas/services/Variables.dart';
import 'package:app_actasalinstante/views/controller/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:android_intent/android_intent.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart' as Path;
import 'package:open_filex/open_filex.dart';
import '../../NavBar.dart';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu>
    with TickerProviderStateMixin {
  FetchUserLists _userList = FetchUserLists();
  AnimationController _animationController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
  }

  String selectedType = "initial";
  String selectedFrequency = "monthly";
  int selectedIndex;
  final ImagePicker _picker = ImagePicker();
  PickedFile _imageFile;
  Future<File> _downloadFile(String id, String filename) async {
    Map<String, String> mainheader = new Map();
    mainheader["content-type"] = "application/pdf";
    mainheader['x-access-token'] = getIt<AuthModel>().token;
    http.Client client = new http.Client();
    var req = await client.get(
        Uri.parse(
            'https://actasalinstante.com:3030/api/actas/requests/getMyActa/' +
                id),
        headers: mainheader);
    var bytes = req.bodyBytes;

    String dir;
    if (Platform.isAndroid) {
      dir = (await getExternalStorageDirectory()).path;
    } else if (Platform.isIOS) {
      dir = (await getApplicationDocumentsDirectory()).path;
    }
// var status = await Permission.storage.status;
//                   if (!status.isGranted) {
//                     await Permission.storage.request();

//                   }
    //String dir = (await getApplicationDocumentsDirectory()).path;
    File file = new File('/storage/emulated/0/Download/$filename');
    await file.writeAsBytes(bytes);

    return file;
  }

  var _openResult = 'Unknown';

  Future<void> openFiles(String filename) async {
    final filePath = "/storage/emulated/0/Download/" + filename;
    final result = await OpenFilex.open(filePath);
    _openResult = "${result.type}";
    print(result.type);
    print(filePath.toString());
  }

// type=${result.type}
  var isFavorite = false.obs;

  int count;
  int index;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
child: Scaffold(
          backgroundColor: Colors.grey,
       
          body: Container(
 child: FutureBuilder<List<Userlists>>(
                future: _userList.getuserLists(),
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
                          ));
                        }
                        final _controller = Get.find<Controller>();
                        return Card(
                          color: selectedIndex == index ? Colors.white : null,
                          elevation: 10,
                          // color: Color.fromARGB(255, 232, 234, 246),
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
                                imageProfile(),
              new Center(
                child: Text("" + getIt<AuthModel>().usuario,
                    style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'avenir',
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
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
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: Card(
                          elevation: 5,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  // Expanded(
                                  //   child: Column(
                                  //     crossAxisAlignment:
                                  //         CrossAxisAlignment.start,
                                  //     mainAxisAlignment:
                                  //         MainAxisAlignment.spaceBetween,
                                  //     children: <Widget>[
                                  //       Container(
                                  //         child: Column(
                                  //           children: [
                                  //             Text(
                                  //               "Tienes: " +
                                  //                   data.length.toString() +
                                  //                   " Actas",
                                  //               maxLines: 2,
                                  //               style: TextStyle(
                                  //                   fontSize: 16,
                                  //                   fontFamily: 'avenir',
                                  //                   fontWeight: FontWeight.w800,
                                  //                   color: Colors.black),
                                  //               overflow: TextOverflow.ellipsis,
                                  //             ),
                                  //           ],
                                  //         ),
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),
                                  Container(
                                    child: Image.network(
                                        'https://picsum.photos/250?image=9',
                                        width: 60),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      //  FIN CARD
                      // Positioned(
                      //   bottom: 1.0,
                      //   right: 10.0,
                      //   child: InkWell(
                      //     onTap: () {

                      //     },
                      //     child: Icon(
                      //       Icons.notification_add,
                      //       color: Colors.teal,
                      //       size: 32.0,
                      //     ),
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

                      SizedBox(
                        height: 20,
                      ),
                      new Center(
                        child: Text(
                          "Selecciona el servicio: " +
                              getIt<AuthModel>().usuario,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
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
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 16,
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
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 16,
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
                                style: TextStyle(
                                    fontSize: 19,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
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
                        );
                      });
                }),
          ),




            
           
          
          
        






),


        onWillPop: _onWillPopScope);
  }
 void changeCleaningType(String type) {
    selectedType = type;
    print(selectedType.toString());
    setState(() {});
  }

  void changeFrequency(String frequency) {
    selectedFrequency = frequency;
    setState(() {});
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
      dialogType: DialogType.WARNING,
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
