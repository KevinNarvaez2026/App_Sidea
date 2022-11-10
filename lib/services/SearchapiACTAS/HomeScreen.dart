import 'dart:convert';

import 'package:android_intent/android_intent.dart';
import 'package:android_intent/flag.dart';

import 'package:app_actasalinstante/services/SearchapiACTAS/Api_service.dart';

import 'package:app_actasalinstante/services/SearchapiACTAS/search.dart';
import 'package:app_actasalinstante/services/SearchapiACTAS/user_model.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:app_actasalinstante/RFCDescargas/services/Variables.dart';
import 'package:app_actasalinstante/views/controller/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:android_intent/android_intent.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart' as Path;
import 'package:open_filex/open_filex.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../LoginView/api/ProgressHUD.dart';
import '../../NavBar.dart';
import '../../SplashScreen/Splashscreen1.dart';
import 'package:permission_handler/permission_handler.dart';

class SERACHACTAS extends StatefulWidget {
  @override
  _SERACHACTASState createState() => _SERACHACTASState();
}

class _SERACHACTASState extends State<SERACHACTAS>
    with TickerProviderStateMixin {
  FetchUserLists _userList = FetchUserLists();
  Userlists list = Userlists();
  List<Userlists> resultsid;
  AnimationController _animationController;
  @override
  void initState() {
    this.getdates();
    // TODO: implement initState
    super.initState();
    GetNames();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
  }

  String user = "";
  GetNames() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      user = prefs.getString('username');
    });
    // print(user);
  }

  String _mySelection;

  List data = List();
  String Token = "";
  Future<String> getdates({String query}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      Token = prefs.getString('token');
    });
    //print(Token);
    Map<String, String> mainheader = new Map();
    mainheader["content-type"] = "application/json";
    mainheader['x-access-token'] = Token;
    var response = await get(
      Uri.parse('https://actasalinstante.com:3030/api/actas/requests/myDates/'),
      headers: mainheader,
    );
    var resBody = json.decode(response.body);
    if (response.statusCode == 401) {
      // AnimationsError();

      prefs.remove('token');
      prefs.remove('username');
      await Future.delayed(Duration(seconds: 2));
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext ctx) => SplashScreen()));
    }

    setState(() {
      data = resBody;
      // print(data);
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

//ZONA DE DESCARGA
  bool isApiCallProcess = false;
  Future<File> _downloadFile(String folio, String filename) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      Token = prefs.getString('token');
    });
    Map<String, String> mainheader = new Map();
    mainheader["content-type"] = "application/pdf";
    mainheader['x-access-token'] = Token;
    http.Client client = new http.Client();
    var req = await client.get(
        Uri.parse(
            'https://actasalinstante.com:3030/api/services/actas/download/' +
                folio),
        headers: mainheader);
    var bytes = jsonDecode(req.body.toString());

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
      setState(() {
        setState(() {
          isApiCallProcess = false;
        });
      });
      File file = new File('/storage/emulated/0/Download/$filename' + '.pdf');
      var decoded = base64.decode(bytes['b64'].toString());

      await file.writeAsBytes(decoded);
      Open_pdf(filename);
      return file;
    }
  }

  Open_pdf(folio) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.WARNING,
      animType: AnimType.BOTTOMSLIDE,
      title: 'Actas al instante',
      desc: user.toString() + ' ¿quieres abrir tu PDF',
      btnCancelOnPress: () {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) => NavBar()));
        // Navigator.of(context).pop(true);
      },
      btnOkOnPress: () {
        openFiles(folio.toString());
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) => NavBar()));
      },
    )..show();
  }

  var _openResult = 'Unknown';

  Future<void> openFiles(String filename) async {
    final filePath = "/storage/emulated/0/Download/" + filename + '.pdf';
    final result = await OpenFilex.open(filePath);
    _openResult = "${result.type}";
  }

  // final f = new DateFormat('yyyy-MM-dd hh:mm');
// type=${result.type}
  var isFavorite = false.obs;
  int selectedIndex;
  int count;
  int index;

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: Actas_De(context),
      inAsyncCall: isApiCallProcess,
      opacity: 0.3,
      key: Key(isApiCallProcess.toString()),
      valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
    );
  }

  Widget Actas_De(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          backgroundColor: Colors.grey,
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
                      color: Colors.black,
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
                      _userList.datesforuser = newVal;
                    });
                  },
                  value: _userList.datesforuser,
                ),
              ),
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
                    desc:
                        'Tienes: ' + _userList.data.length.toString() + ' PDF',
                    btnOkOnPress: () {
                      // exit(0);
                    },
                  )..show();
                  //   print(_userList.data.length.toString());
                  // _userList.data.length.toString();
                },
              ),
              IconButton(
                onPressed: () {
                  showSearch(context: context, delegate: SearchUser());
                },
                icon: Icon(Icons.search_sharp),
                color: Colors.black,
                iconSize: 30.0,
              ),
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
                            ),
                          );
                        }

                        final _controller = Get.find<Controller>();

                        return Card(
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
                                if ('${data[index].descarga}' != "true" &&
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

                                if ('${data[index].descarga}' != "false" &&
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
                                if ('${data[index].comments}' != "Descargado" &&
                                    '${data[index].comments}' != "null" &&
                                    '${data[index].comments}' != ".")
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
                                Stack(
                                  children: [
                                    //  if ('${data[index].type}' == "Nacimiento")
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: Center(
// Image radius
                                        child: Image.asset('assets/NAC.png',
                                            alignment: Alignment.center,
                                            fit: BoxFit.cover),
                                      ),
                                    ),
                                    if ('${data[index].type}' ==
                                        "Cadena Digital")
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: Center(
// Image radius
                                          child: Image.asset(
                                              'assets/desconocido.png',
                                              alignment: Alignment.center,
                                              fit: BoxFit.cover),
                                        ),
                                      ),
                                    if ('${data[index].type}' == "Matrimonio")
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: Center(
// Image radius
                                          child: Image.asset(
                                              'assets/matrimonio.png',
                                              alignment: Alignment.center,
                                              fit: BoxFit.cover),
                                        ),
                                      ),
                                    if ('${data[index].type}' == "Divorcio")
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: Center(
// Image radius
                                          child: Image.asset(
                                              'assets/divorcio.png',
                                              alignment: Alignment.center,
                                              fit: BoxFit.cover),
                                        ),
                                      ),
                                    if ('${data[index].type}' == "Defuncion")
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: Center(
// Image radius
                                          child: Image.asset(
                                              'assets/DEFUNCION.jpg',
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
                                        borderRadius: BorderRadius.circular(54),
                                      ),
                                    ),
                                    if ('${data[index].comments}' !=
                                            "Descargado" &&
                                        '${data[index].comments}' != "null" &&
                                        '${data[index].comments}' != ".")
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
                                    if ('${data[index].comments}' == "null" ||
                                        '${data[index].comments}' ==
                                            "Descargado")
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
                                    if ('${data[index].comments}' ==
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
                                                    'Descargala Otra Vez No Genera Ningun Costo ',
                                                contentType: ContentType.help,
                                              ),
                                            );

                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(snackBar);

                                            openFiles('${data[index].website}'
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
                                    if ('${data[index].descarga}' != "true" &&
                                        '${data[index].comments}' ==
                                            "Descargado")
                                      new Center(
                                        child: Container(
                                          height: 180,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image:
                                                  AssetImage('assets/new.gif'),
                                            ),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(6)),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                if ('${data[index].type}' == "Cadena Digital")
                                  new Center(
                                    child: Text(
                                      "Cadena Digital ",
                                      maxLines: 2,
                                      style: GoogleFonts.lato(
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .headline4,
                                        fontSize: 22,
                                        fontWeight: FontWeight.w700,
                                        fontStyle: FontStyle.italic,
                                        color: Colors.black,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                if ('${data[index].type}' != "Cadena Digital")
                                  new Center(
                                    child: Text(
                                      " " + '${data[index].metadatatype}',
                                      maxLines: 5,
                                      style: TextStyle(
                                          fontSize: 22,
                                          fontFamily: 'avenir',
                                          fontWeight: FontWeight.w800,
                                          color: Colors.black),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),

                                new Center(
                                  child: Text(
                                    "" +
                                        DateFormat("dd-MM-yyyy h:mm:a")
                                            .format(data[index].fecha)
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
                                SizedBox(height: 8),

                                if ('${data[index].metadatatype}' == "CURP")
                                  Text(
                                    "Tipo de busqueda: " +
                                        '${data[index].metadatatype}',
                                    maxLines: 2,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'avenir',
                                        fontWeight: FontWeight.w800,
                                        color: Colors.black),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                if ('${data[index].type}' == "Nacimiento")
                                  Text(
                                    "Tipo: " + '${data[index].type}',
                                    maxLines: 2,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'avenir',
                                        fontWeight: FontWeight.w800,
                                        color: Colors.black),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                //  if ('${data[index].metadata}' == "curp")
                                Text(
                                  "Curp: " + '${data[index].metadata}',
                                  maxLines: 2,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'avenir',
                                      fontWeight: FontWeight.w800,
                                      color: Colors.black),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                //    if ('${data[index].metadataestado}' == "estado")
                                Text(
                                  "Estado: " + '${data[index].metadataestado}',
                                  maxLines: 2,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'avenir',
                                      fontWeight: FontWeight.w800,
                                      color: Colors.black),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if ('${data[index].type}' == "Cadena Digital")
                                  Text(
                                    "Tipo de busqueda: " +
                                        '${data[index].type}',
                                    maxLines: 2,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'avenir',
                                        fontWeight: FontWeight.w800,
                                        color: Colors.black),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                if ('${data[index].type}' == "Cadena Digital")
                                  Text(
                                    "Cadena: " +
                                        '${data[index].metadatacadena}',
                                    maxLines: 2,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'avenir',
                                        fontWeight: FontWeight.w800,
                                        color: Colors.black),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                if ('${data[index].type}' == "Datos Personales")
                                  Text(
                                    "Nombre(s): " + '${data[index].username}',
                                    maxLines: 2,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'avenir',
                                        fontWeight: FontWeight.w800,
                                        color: Colors.black),
                                    overflow: TextOverflow.ellipsis,
                                  ),

                                if ('${data[index].type}' == "Datos Personales")
                                  Text(
                                    "Segundo Apellido: " +
                                        '${data[index].apellido2}',
                                    maxLines: 2,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'avenir',
                                        fontWeight: FontWeight.w800,
                                        color: Colors.black),
                                    overflow: TextOverflow.ellipsis,
                                  ),

                                if ('${data[index].website}' != "null")
                                  Text(
                                    "Nombre del archivo: " +
                                        '${data[index].website}',
                                    maxLines: 2,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'avenir',
                                        fontWeight: FontWeight.w800,
                                        color: Colors.black),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                // Container(
                                //   height: 100.0,
                                //   child: Lottie.network(
                                //     'https://assets5.lottiefiles.com/packages/lf20_hdmkzp2n.json',
                                //     controller: _animationController,
                                //     height: 180,
                                //     repeat: false,
                                //   ),
                                // ),
                                SizedBox(height: 8),
                                if ('${data[index].comments}' == "Descargado" &&
                                    '${data[index].descarga}' != "true")
                                  new Center(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.circular(82),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4, vertical: 2),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          MaterialButton(
                                            onPressed: () {
                                              setState(() {
                                                isApiCallProcess = true;
                                              });
                                              _downloadFile('${data[index].id}',
                                                  '${data[index].metadata}');
                                              // _downloadFile(
                                              //     '${data[index].id}'
                                              //         .toString(),
                                              //     '${data[index].website}'
                                              //         .toString());
                                              // _animationController.forward();
                                              _controller.sendNotification();
                                            },
                                            child: Text("Descargar"),
                                            textColor: Colors.white,
                                          ),
                                          Icon(
                                            Icons.download,
                                            size: 20,
                                            color: Colors.white,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                if ('${data[index].comments}' != "Descargado" &&
                                    '${data[index].comments}' != "null" &&
                                    '${data[index].comments}' != ".")
                                  new Center(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.redAccent,
                                        borderRadius: BorderRadius.circular(82),
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
                                                animType: AnimType.BOTTOMSLIDE,
                                                title: '' +
                                                    '${data[index].comments}',
                                                desc: '',
                                                // btnCancelOnPress: () {
                                                //   //  Navigator.of(context).pop(true);
                                                // },
                                                btnOkOnPress: () {},
                                              )..show();
                                            },
                                            child: Text("Detalles"),
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
                                if ('${data[index].comments}' == "Descargado" &&
                                    '${data[index].descarga}' == "true")
                                  new Center(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius: BorderRadius.circular(82),
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
                                                content: AwesomeSnackbarContent(
                                                  title: 'Si Tu PDF No Se Abre',
                                                  message:
                                                      'Descargala Otra Vez \nNo Genera Ningun Costo ',
                                                  contentType: ContentType.help,
                                                ),
                                              );

                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(snackBar);
                                              openFiles(
                                                  '${data[index].metadata}');
                                            },
                                            child: Text("Abrir"),
                                            textColor: Colors.white,
                                          ),
                                          if ('${data[index].website}' !=
                                              "null")
                                            Icon(
                                              Icons.download_done,
                                              size: 20,
                                              color: Colors.white,
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                SizedBox(height: 8),
                                if ('${data[index].comments}' == "Descargado" &&
                                    '${data[index].descarga}' == "true")
                                  new Center(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.lightGreen,
                                        borderRadius: BorderRadius.circular(82),
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
                                                content: AwesomeSnackbarContent(
                                                  title: 'Descargando Acta',
                                                  message: 'Espere un momento',
                                                  contentType:
                                                      ContentType.success,
                                                ),
                                              );

                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(snackBar);

                                              _downloadFile('${data[index].id}',
                                                  '${data[index].metadata}');
                                            },
                                            child: Text("Descargar otra vez"),
                                            textColor: Colors.white,
                                          ),
                                          if ('${data[index].website}' !=
                                              "null")
                                            Icon(
                                              Icons.replay_outlined,
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
