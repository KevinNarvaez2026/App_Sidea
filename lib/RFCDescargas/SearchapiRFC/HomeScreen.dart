import 'dart:convert';

import 'package:android_intent/flag.dart';
import 'package:app_actasalinstante/DropDown/Descargar_actas/animation/FadeAnimation.dart';
import 'package:app_actasalinstante/NavBar.dart';
import 'package:app_actasalinstante/RFCDescargas/SearchapiRFC/Api_service.dart';
import 'package:app_actasalinstante/RFCDescargas/SearchapiRFC/search.dart';
import 'package:app_actasalinstante/RFCDescargas/SearchapiRFC/user_model.dart';

import 'package:app_actasalinstante/RFCDescargas/services/Variables.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
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

import '../../RFC/Modal_RFC.dart';
import '../../RFC/Transicion.dart';
import '../../SplashScreen/Splashscreen1.dart';
import '../../views/controller/controller.dart';
import 'package:permission_handler/permission_handler.dart';

class SERACHRFC extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<SERACHRFC> with TickerProviderStateMixin {
  FetchUserList _userList = FetchUserList();
  @override
  void initState() {
    this.getdatesrffc();
    GetNames();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    // TODO: implement initState
    super.initState();
  }

  String user = "";
  GetNames() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      user = prefs.getString('username');
    });
    _runAnimation();
    print(user);
  }

  String Token = "";

  List data = List();

  Future<String> getdatesrffc({String query}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Token = prefs.getString('token');
    Map<String, String> mainheader = new Map();
    mainheader["content-type"] = "application/json";
    mainheader['x-access-token'] = Token;
    var response = await get(
      Uri.parse(
          'https://actasalinstante.com:3030/api/actas/reg/corte/MyDates/'),
      headers: mainheader,
    );
    var resBody = json.decode(response.body);
    if (response.statusCode == 401) {
      prefs.remove('token');
      prefs.remove('username');
      await Future.delayed(Duration(seconds: 2));
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext ctx) => SplashScreen()));
    }
    setState(() {
      data = resBody;
      print(data);
    });
    // if (response.statusCode == 200) {
    //   //_controller.sendNotification();
    //   data = jsonDecode(response.body);
    //  // print(data);
    // } else {
    //   print("fetch error");
    // }

    // return results;
  }

  Future<File> _downloadFile(String id, String filename) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Token = prefs.getString('token');
    Map<String, String> mainheader = new Map();
    mainheader["content-type"] = "application/pdf";
    mainheader['x-access-token'] = Token;
    http.Client client = new http.Client();
    var req = await client.get(
        Uri.parse(
            'https://actasalinstante.com:3030/api/rfc/request/donwload/' + id),
        headers: mainheader);
    var bytes = req.bodyBytes;

    String dir;
    if (Platform.isAndroid) {
      dir = (await getExternalStorageDirectory()).path;
    } else if (Platform.isIOS) {
      dir = (await getApplicationDocumentsDirectory()).path;
    }

    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    } else {
      File file = new File('/storage/emulated/0/Download/$filename');
      await file.writeAsBytes(bytes);

      return file;
    }
    print(status);
  }

  static const duration = Duration(milliseconds: 300);
  var _openResult = 'Unknown';

  Future<void> openFiles(String filename) async {
    final filePath = "/storage/emulated/0/Download/" + filename;
    final result = await OpenFilex.open(filePath);

    setState(() {
      _openResult = "type=${result.type}  message=${result.message}";
      print(_openResult);
    });
  }

  var now = new DateTime.now();
  var isFavorite = false.obs;
  int index;
  final Color color = HexColor('#D61C4E');
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

  AnimationController _animationController;
  void _runAnimation() async {
    for (int i = 0; i < 3; i++) {
      await _animationController.forward();
      await _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          backgroundColor: color,
          floatingActionButton: RotationTransition(
            turns: Tween(begin: 0.0, end: -.1)
                .chain(CurveTween(curve: Curves.elasticIn))
                .animate(_animationController),
            child: FloatingActionButton(
              onPressed: () {
                showdialog_Aler();
                _runAnimation();
              },
              child: Icon(
                Icons.add,
                color: Colors.white,
                size: 29,
              ),
              backgroundColor: Colors.black,
              tooltip: 'Más Informacion',
              elevation: 5,
              splashColor: Colors.grey,
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          appBar: AppBar(
            actions: [
              new Center(
                child: new DropdownButton(
                  hint: Text(
                    "Selecciona el Corte",
                    style: GoogleFonts.lato(
                      textStyle: Theme.of(context).textTheme.headline4,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.italic,
                      color: Colors.white,
                    ),
                  ),
                  dropdownColor: Colors.white,
                  items: data.map((item) {
                    return new DropdownMenuItem(
                      child: new Text(item['corte'].toString()),
                      value: item['corte'].toString(),
                    );
                  }).toList(),
                  onChanged: (newVal) {
                    setState(() {
                      _userList.datesforuserrfc = newVal;
                    });
                  },
                  value: _userList.datesforuserrfc,
                ),
              ),
              new IconButton(
                icon: new Icon(Icons.info),
                iconSize: 30.0,
                highlightColor: Colors.white,
                color: Colors.white,
                onPressed: () {
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.SUCCES,
                    animType: AnimType.BOTTOMSLIDE,
                    title: '' + user.toString(),
                    desc: 'Tienes: ' + _userList.data.length.toString() + 'PDF',
                    btnOkOnPress: () {
                      // exit(0);
                    },
                  )..show();
                  print(_userList.data.length.toString());
                  // _userList.data.length.toString();
                },
              ),
              IconButton(
                onPressed: () {
                  showSearch(context: context, delegate: SearchUser());
                },
                icon: Icon(Icons.search_sharp),
                color: Colors.white,
                iconSize: 30.0,
              )
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
                color: Colors.white,
              ),
            ),
          ),
          body: Container(
            padding: EdgeInsets.all(10),
            child: FutureBuilder<List<Userlist2>>(
                future: _userList.getuserList(),
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
                                  if ('${data[index].comments}' !=
                                          "Descargado" &&
                                      '${data[index].comments}' != "null")
                                    new Center(
                                      child: Text(
                                        (index + 1).toString(),
                                        maxLines: 5,
                                        style: TextStyle(
                                            fontSize: 22,
                                            fontFamily: 'avenir',
                                            fontWeight: FontWeight.w800,
                                            color: Colors.redAccent),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  if ('${data[index].descarga}' != "true" &&
                                      '${data[index].email}' != "null" &&
                                      '${data[index].comments}' == "Descargado")
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
                                  if ('${data[index].comments}' == "null" &&
                                          '${data[index].email}' == "null" ||
                                      '${data[index].comments}' ==
                                              "Descargado" &&
                                          '${data[index].email}' == "null")
                                    new Center(
                                      child: Text(
                                        (index + 1).toString(),
                                        maxLines: 5,
                                        style: TextStyle(
                                            fontSize: 22,
                                            fontFamily: 'avenir',
                                            fontWeight: FontWeight.w800,
                                            color: Colors.yellow),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  if ('${data[index].descarga}' != "false" &&
                                      '${data[index].email}' != "null" &&
                                      '${data[index].comments}' == "Descargado")
                                    new Center(
                                      child: Text(
                                        (index + 1).toString(),
                                        maxLines: 5,
                                        style: TextStyle(
                                            fontSize: 22,
                                            fontFamily: 'avenir',
                                            fontWeight: FontWeight.w800,
                                            color: Colors.black),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: Center(
// Image radius
                                          child: Image.asset('assets/rfc.png',
                                              alignment: Alignment.center,
                                              fit: BoxFit.cover),
                                        ),
                                      ),
                                      Container(
                                        height: 200,
                                        width: double.infinity,
                                        clipBehavior: Clip.antiAlias,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(54),
                                        ),
                                      ),
                                      if ('${data[index].descarga}' != "true" &&
                                          '${data[index].email}' != "null" &&
                                          '${data[index].comments}' ==
                                              "Descargado")
                                        new Center(
                                          child: Text(
                                            "Nuevo ",
                                            maxLines: 5,
                                            style: TextStyle(
                                                fontSize: 30,
                                                fontFamily: 'avenir',
                                                fontWeight: FontWeight.w800,
                                                color: Colors.blueAccent),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      if ('${data[index].comments}' !=
                                              "Descargado" &&
                                          '${data[index].comments}' != "null")
                                        new Center(
                                          child: Container(
                                            height: 180,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: AssetImage(
                                                    'assets/error.gif'),
                                              ),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(6)),
                                            ),
                                          ),
                                        ),
                                      if ('${data[index].email}' != "null" &&
                                          '${data[index].comments}' ==
                                              "Descargado" &&
                                          '${data[index].descarga}' == "true")
                                        new Center(
                                          child: InkWell(
                                            onTap: () {
                                              var snackBar = SnackBar(
                                                elevation: 0,
                                                behavior:
                                                    SnackBarBehavior.floating,
                                                backgroundColor:
                                                    Colors.transparent,
                                                content: AwesomeSnackbarContent(
                                                  title: 'Si Tu PDF No Se Abre',
                                                  message:
                                                      'Descargala Otra Vez \nNo Genera Ningun Costo ',
                                                  contentType: ContentType.help,
                                                ),
                                              );

                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(snackBar);

                                              openFiles('${data[index].email}'
                                                  .toString());
                                            },
                                            child: Container(
                                              height: 180,
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: AssetImage(
                                                      'assets/pdf.gif'),
                                                ),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(6)),
                                              ),
                                            ),
                                          ),
                                        ),
                                      if ('${data[index].descarga}' != "true" &&
                                          '${data[index].email}' != "null" &&
                                          '${data[index].comments}' ==
                                              "Descargado")
                                        new Center(
                                          child: Container(
                                            height: 180,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: AssetImage(
                                                    'assets/new.gif'),
                                              ),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(6)),
                                            ),
                                          ),
                                        ),
                                      if ('${data[index].comments}' == "null" &&
                                              '${data[index].email}' ==
                                                  "null" ||
                                          '${data[index].comments}' ==
                                                  "Descargado" &&
                                              '${data[index].email}' == "null")
                                        new Center(
                                          child: Container(
                                            height: 180,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: AssetImage(
                                                    'assets/particles.gif'),
                                              ),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(6)),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  new Center(
                                    child: Text(
                                      "" + '${data[index].phone}',
                                      maxLines: 2,
                                      style: TextStyle(
                                          fontSize: 22,
                                          fontFamily: 'avenir',
                                          fontWeight: FontWeight.w800),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  new Center(
                                    child: Text(
                                      "" +
                                          DateFormat("dd-MM-yyyy h:mm:a")
                                              .format(data[index].horaTotal)
                                              .toString(),
                                      maxLines: 5,
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'avenir',
                                          fontWeight: FontWeight.w800,
                                          color: Colors.black),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Text(
                                    "Datos",
                                    maxLines: 2,
                                    style: TextStyle(
                                        fontSize: 19,
                                        fontFamily: 'avenir',
                                        fontWeight: FontWeight.w800,
                                        color: Colors.blueAccent),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    "Tipo de busqueda: " +
                                        '${data[index].phone}',
                                    maxLines: 2,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'avenir',
                                        fontWeight: FontWeight.w800),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    "Curp: " + '${data[index].data}',
                                    maxLines: 2,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'avenir',
                                        fontWeight: FontWeight.w800),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  if ('${data[index].email}' != "null")
                                    Text(
                                      "Nombre del archivo: " +
                                          '${data[index].email}',
                                      maxLines: 2,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'avenir',
                                          fontWeight: FontWeight.w800),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  SizedBox(height: 8),
                                  if ('${data[index].email}' != "null" &&
                                      '${data[index].comments}' ==
                                          "Descargado" &&
                                      '${data[index].descarga}' != "true")
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
                                                _downloadFile(
                                                    '${data[index].id}'
                                                        .toString(),
                                                    '${data[index].email}'
                                                        .toString());

                                                _controller.sendNotification();

                                                AwesomeDialog(
                                                  context: context,
                                                  dialogType:
                                                      DialogType.WARNING,
                                                  animType:
                                                      AnimType.BOTTOMSLIDE,
                                                  title: 'Actas al instante',
                                                  desc: user.toString() +
                                                      ' ¿quieres abrir tu PDF',
                                                  btnCancelOnPress: () {
                                                    Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (BuildContext
                                                                    context) =>
                                                                NavBar()));
                                                    //  Navigator.of(context).pop(true);
                                                  },
                                                  btnOkOnPress: () {
                                                    openFiles(
                                                        '${data[index].email}'
                                                            .toString());

                                                    Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (BuildContext
                                                                    context) =>
                                                                NavBar()));
                                                  },
                                                )..show();
                                              },
                                              child: Text("Descargar"),
                                              textColor: Colors.white,
                                            ),
                                            Icon(
                                              Icons.download,
                                              size: 15,
                                              color: Colors.white,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  SizedBox(height: 8),
                                  if ('${data[index].email}' != "null" &&
                                      '${data[index].comments}' ==
                                          "Descargado" &&
                                      '${data[index].descarga}' == "true")
                                    new Center(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey,
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
                                                var snackBar = SnackBar(
                                                  elevation: 0,
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  content:
                                                      AwesomeSnackbarContent(
                                                    title:
                                                        'Si Tu PDF No Se Abre',
                                                    message:
                                                        'Descargala Otra Vez \nNo Genera Ningun Costo ',
                                                    contentType:
                                                        ContentType.help,
                                                  ),
                                                );

                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(snackBar);
                                                openFiles(
                                                    '${data[index].email}');
                                              },
                                              child: Text("Abrir"),
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
                                  if ('${data[index].email}' != "null" &&
                                      '${data[index].comments}' ==
                                          "Descargado" &&
                                      '${data[index].descarga}' == "true")
                                    new Center(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.lightGreen,
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
                                                _downloadFile(
                                                    '${data[index].id}'
                                                        .toString(),
                                                    '${data[index].email}'
                                                        .toString());

                                                _controller.sendNotification();

                                                AwesomeDialog(
                                                  context: context,
                                                  dialogType:
                                                      DialogType.WARNING,
                                                  animType:
                                                      AnimType.BOTTOMSLIDE,
                                                  title: 'Actas al instante',
                                                  desc: user.toString() +
                                                      ' ¿quieres abrir tu PDF',
                                                  btnCancelOnPress: () {
                                                    Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (BuildContext
                                                                    context) =>
                                                                NavBar()));
                                                    //  Navigator.of(context).pop(true);
                                                  },
                                                  btnOkOnPress: () {
                                                    openFiles(
                                                        '${data[index].email}'
                                                            .toString());

                                                    Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (BuildContext
                                                                    context) =>
                                                                NavBar()));
                                                  },
                                                )..show();
                                              },
                                              child: Text("Descargar otra vez"),
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
                                  if ('${data[index].comments}' == "null" &&
                                          '${data[index].email}' == "null" ||
                                      '${data[index].comments}' ==
                                              "Descargado" &&
                                          '${data[index].email}' == "null" &&
                                          '${data[index].email}' == '')
                                    new Center(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.yellow,
                                          borderRadius:
                                              BorderRadius.circular(82),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4, vertical: 2),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            MaterialButton(
                                              onPressed: null,
                                              onLongPress: null,
                                              child: Text("En Proceso"),
                                              textColor: Colors.white,
                                            ),
                                            Icon(
                                              Icons.priority_high_outlined,
                                              size: 15,
                                              color: Colors.white,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  if ('${data[index].comments}' !=
                                          "Descargado" &&
                                      '${data[index].comments}' != "null")
                                    new Center(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.redAccent,
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
                                                  dialogType: DialogType.ERROR,
                                                  animType:
                                                      AnimType.BOTTOMSLIDE,
                                                  title: 'Error',
                                                  desc: '' +
                                                      '${data[index].comments}',
                                                  btnOkOnPress: () {},
                                                )..show();
                                              },
                                              child: Text("Detalles"),
                                              textColor: Colors.white,
                                            ),
                                            Icon(
                                              Icons.priority_high_outlined,
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
