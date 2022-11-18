import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../LoginView/api/ProgressHUD.dart';
import '../../NavBar.dart';
import 'animation/FadeAnimation.dart';

class D_Actas extends StatefulWidget {
  const D_Actas({Key key}) : super(key: key);

  @override
  _D_Actastate createState() => _D_Actastate();
}

class _D_Actastate extends State<D_Actas> {
  bool isApiCallProcess = false;
  String Token = "";
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    GetNames();
    Get_Datos();
    Lenguaje();
  }

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
  }

  void _speak(voice) async {
    initSetting();
    await flutterTts.speak(voice);
  }

  void _stop() async {
    await flutterTts.stop();
  }

  String user = "";
  GetNames() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      user = prefs.getString('username');
    });
  }
  // List<Service> services = [
  //   Service('Cleaning',
  //       'https://img.icons8.com/external-vitaliy-gorbachev-flat-vitaly-gorbachev/2x/external-cleaning-labour-day-vitaliy-gorbachev-flat-vitaly-gorbachev.png'),
  //   Service('Plumber',
  //       'https://img.icons8.com/external-vitaliy-gorbachev-flat-vitaly-gorbachev/2x/external-plumber-labour-day-vitaliy-gorbachev-flat-vitaly-gorbachev.png'),
  //   Service('Electrician',
  //       'https://img.icons8.com/external-wanicon-flat-wanicon/2x/external-multimeter-car-service-wanicon-flat-wanicon.png'),
  //   Service('Painter',
  //       'https://img.icons8.com/external-itim2101-flat-itim2101/2x/external-painter-male-occupation-avatar-itim2101-flat-itim2101.png'),
  //   Service('Carpenter', 'https://img.icons8.com/fluency/2x/drill.png'),
  //   Service('Gardener',
  //       'https://img.icons8.com/external-itim2101-flat-itim2101/2x/external-gardener-male-occupation-avatar-itim2101-flat-itim2101.png'),
  // ];

  // List<dynamic> workers = [
  //   [
  //     'Alfredo Schafer' +  user,
  //     'Plumber',
  //     'https://images.unsplash.com/photo-1506803682981-6e718a9dd3ee?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&fit=crop&h=200&w=200&s=c3a31eeb7efb4d533647e3cad1de9257',
  //     4.8
  //   ],
  // ];

  var id, tipo, search, curp, cadena, names, last_name, state;

  Get_Datos() async {
    SharedPreferences set_acta = await SharedPreferences.getInstance();

    setState(() {
      id = set_acta.getString('id');
      tipo = set_acta.getString('tipo');
      search = set_acta.getString('busqueda');
      curp = set_acta.getString('curp');
      cadena = set_acta.getString('cadena');
      names = set_acta.getString('nombres');
      last_name = set_acta.getString('apellidos');
      state = set_acta.getString('estado');
    });
    _speak(user+',Tu acta con la curp de,'+curp+', esta lista para descargar');
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: descargas(context),
      inAsyncCall: isApiCallProcess,
      opacity: 0.3,
      key: Key(isApiCallProcess.toString()),
      valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
    );
  }

  Widget descargas(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            '' + user.toString(),
            style: TextStyle(color: Colors.white),
          ),
          elevation: 0,
          actions: [
            // IconButton(
            //   onPressed: () {},
            //   icon: Icon(
            //     Icons.notifications_none,
            //     color: Colors.grey.shade700,
            //     size: 30,
            //   ),
            // )
          ],
        ),
        backgroundColor: Colors.white.withOpacity(0.1),
        body: SingleChildScrollView(
            child: Column(children: [
          FadeAnimation(
              1,
              Padding(
                padding: EdgeInsets.only(left: 20.0, top: 10.0, right: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    new Center(
                      child: Text(
                        'Descarga tu acta',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),

                    // TextButton(
                    //     onPressed: () {},
                    //     child: Text(
                    //       'View all',
                    //     ))
                  ],
                ),
              )),
          SizedBox(
            height: 20,
          ),
          FadeAnimation(
              1.2,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  padding: EdgeInsets.all(20.0),
                  height: 480,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade200,
                        offset: Offset(0, 4),
                        blurRadius: 10.0,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: Image.asset(
                          'assets/NAC.png',
                          alignment: Alignment.center,
                          fit: BoxFit.cover,
                          width: 150,
                        ),
                      ),
                      SizedBox(height: 40),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(width: 1),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Text(
                              //   "Folio: ",
                              //   style: TextStyle(
                              //       color: Colors.redAccent,
                              //       fontSize: 20,
                              //       fontWeight: FontWeight.bold),
                              // ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Tipo: " + tipo.toString(),
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.7),
                                    fontSize: 18),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Busqueda: " + search.toString(),
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.7),
                                    fontSize: 18),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Cadena: " + cadena.toString(),
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.7),
                                    fontSize: 18),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "CURP: " + curp.toString(),
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.7),
                                    fontSize: 18),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Nombres: " + names.toString(),
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.7),
                                    fontSize: 18),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Apellidos: " + last_name.toString(),
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.7),
                                    fontSize: 18),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Estado: " + state.toString(),
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.7),
                                    fontSize: 18),
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
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
                                  setState(() {
                                    isApiCallProcess = true;
                                  });
                                  _downloadFile(id.toString(), curp.toString());
                                   _speak('Espere un momento');
                                },
                                child: Text("Descargar"),
                                textColor: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Container(
                      //   height: 50,
                      //   decoration: BoxDecoration(
                      //       color: Colors.greenAccent,
                      //       borderRadius: BorderRadius.circular(15.0)),
                      //   child: Center(
                      //       child: Text(
                      //     'Descargar',
                      //     style: TextStyle(color: Colors.white, fontSize: 18),
                      //   )),
                      // )
                    ],
                  ),
                ),
              )),
          SizedBox(
            height: 20,
          ),

          // Container(
          //   padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          //   height: 300,
          //   child: GridView.builder(
          //       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //         crossAxisCount: 3,
          //         childAspectRatio: 1.0,
          //         crossAxisSpacing: 10.0,
          //         mainAxisSpacing: 10.0,
          //       ),
          //       physics: NeverScrollableScrollPhysics(),
          //       itemCount: services.length,
          //       itemBuilder: (BuildContext context, int index) {
          //         return FadeAnimation(
          //             (1.0 + index) / 4,
          //             serviceContainer(services[index].imageURL,
          //                 services[index].name, index));
          //       }),
          // ),
          SizedBox(
            height: 20,
          ),
          // FadeAnimation(
          //     1.3,
          //     Padding(
          //       padding: EdgeInsets.only(left: 20.0, right: 10.0),
          //       child: Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         children: [
          //           Text(
          //             'Top Rated',
          //             style:
          //                 TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          //           ),
          //           TextButton(
          //               onPressed: () {},
          //               child: Text(
          //                 'View all',
          //               ))
          //         ],
          //       ),
          //     )),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            height: 120,
            child: Center(),
          ),
          SizedBox(
            height: 150,
          ),
        ])));
  }

  serviceContainer(String image, String name, int index) {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.only(right: 20),
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          border: Border.all(
            color: Colors.blue.withOpacity(0),
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.network(image, height: 45),
              SizedBox(
                height: 20,
              ),
              Text(
                name,
                style: TextStyle(fontSize: 15),
              )
            ]),
      ),
    );
  }

  workerContainer(String name, String job, String image, double rating) {
    return GestureDetector(
      child: AspectRatio(
        aspectRatio: 3.5,
        child: Container(
          margin: EdgeInsets.only(right: 20),
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.grey.shade200,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: Image.network(image)),
                SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      name,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      job,
                      style: TextStyle(fontSize: 15),
                    )
                  ],
                ),
                Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      rating.toString(),
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Icon(
                      Icons.star,
                      color: Colors.orange,
                      size: 20,
                    )
                  ],
                )
              ]),
        ),
      ),
    );
  }
}
