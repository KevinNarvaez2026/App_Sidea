import 'dart:io';

import 'package:android_intent/android_intent.dart';
import 'package:android_intent/flag.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import '../../NavBar.dart';
import '../../services/SearchapiACTAS/Api_service.dart';
import '../../views/controller/controller.dart';
import '../services/Variables.dart';
import 'Api_service.dart';
import 'user_model.dart';
import 'package:permission_handler/permission_handler.dart';

class SearchUser extends SearchDelegate {
  FetchUserList _userList = FetchUserList();
  Userlist2 id = Userlist2();
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: Icon(Icons.close))
    ];
  }

  FetchUserLists _userLis = FetchUserLists();
  Future<File> _downloadFile(String id, String filename) async {
    Map<String, String> mainheader = new Map();
    mainheader["content-type"] = "application/pdf";
    mainheader['x-access-token'] = getIt<AuthModel>().token;
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

  Future<void> openFiles(String filename) async {
    final filePath = "/storage/emulated/0/Download/" + filename;
    await OpenFilex.open(filePath);
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back_ios),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  var isFavorite = false.obs;
  @override
  Widget buildResults(BuildContext context) {
    return Scaffold(
      backgroundColor: color,
      body: FutureBuilder<List<Userlist2>>(
          future: _userList.getuserList(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            List<Userlist2> data = snapshot.data;

            return ListView.builder(
                itemCount: data?.length,
                itemBuilder: (context, index) {
                  final _controller = Get.find<Controller>();
                  return Card(
                    elevation: 10,
                    color: Colors.white,
                    // color: Color.fromARGB(255, 232, 234, 246),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(64),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          if ('${data[index].comments}' != "Descargado" &&
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
                              '${data[index].comments}' == "Descargado" &&
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
                              if ('${data[index].email}' != "null" &&
                                  '${data[index].comments}' == "Descargado" &&
                                  '${data[index].descarga}' == "true")
                                new Center(
                                  child: InkWell(
                                    onTap: () {
                                      var snackBar = SnackBar(
                                        elevation: 0,
                                        behavior: SnackBarBehavior.floating,
                                        backgroundColor: Colors.transparent,
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
                                          '${data[index].email}'.toString());
                                    },
                                    child: Container(
                                      height: 180,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage('assets/pdf.gif'),
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(6)),
                                      ),
                                    ),
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
                              if ('${data[index].descarga}' != "true" &&
                                  '${data[index].email}' != "null" &&
                                  '${data[index].comments}' == "Descargado")
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
                                  '${data[index].email}' != "null" &&
                                  '${data[index].comments}' == "Descargado")
                                new Center(
                                  child: Container(
                                    height: 180,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage('assets/new.gif'),
                                      ),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(6)),
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
                              "Fecha y Hora: " +
                                  DateFormat("yyyy-MM-dd hh:mm:a")
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
                          Text(
                            "Tipo de busqueda: " + '${data[index].phone}',
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
                              "Nombre del archivo: " + '${data[index].email}',
                              maxLines: 2,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'avenir',
                                  fontWeight: FontWeight.w800),
                              overflow: TextOverflow.ellipsis,
                            ),
                          SizedBox(height: 8),
                          if ('${data[index].email}' != "null" &&
                              '${data[index].comments}' == "Descargado" &&
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
                                        _downloadFile(
                                            '${data[index].id}'.toString(),
                                            '${data[index].email}'.toString());

                                        _controller.sendNotification();

                                        AwesomeDialog(
                                          context: context,
                                          dialogType: DialogType.WARNING,
                                          animType: AnimType.BOTTOMSLIDE,
                                          title: 'Actas al instante',
                                          desc: getIt<AuthModel>().usuario +
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
                                            openFiles('${data[index].email}'
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
                              '${data[index].comments}' == "Descargado" &&
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
                                          behavior: SnackBarBehavior.floating,
                                          backgroundColor: Colors.transparent,
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
                                            '${data[index].email}'.toString());
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
                              '${data[index].comments}' == "Descargado" &&
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
                                        _downloadFile(
                                            '${data[index].id}'.toString(),
                                            '${data[index].email}'.toString());

                                        _controller.sendNotification();

                                        AwesomeDialog(
                                          context: context,
                                          dialogType: DialogType.WARNING,
                                          animType: AnimType.BOTTOMSLIDE,
                                          title: 'Actas al instante',
                                          desc: getIt<AuthModel>().usuario +
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
                                            openFiles('${data[index].email}'
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
                              '${data[index].comments}' == "Descargado" &&
                                  '${data[index].email}' == "null")
                            new Center(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.yellow,
                                  borderRadius: BorderRadius.circular(82),
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

                          if ('${data[index].comments}' != "Descargado" &&
                              '${data[index].comments}' != "null")
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
                                          title: 'Error',
                                          desc: '' + '${data[index].comments}',
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
                          //
                          //
                          //
                          //SizedBox(height: 8),
                          // if (product.url.toString() != "null")
                          //   Container(
                          //     decoration: BoxDecoration(
                          //       color: Colors.blue,
                          //       borderRadius: BorderRadius.circular(82),
                          //     ),
                          //     padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                          //     child: Row(
                          //       mainAxisSize: MainAxisSize.min,
                          //       children: [
                          //         MaterialButton(
                          //           onPressed: () {
                          //             // _downloadFile(product.url.toString());

                          //             openfile(product.url.toString());
                          //             //_controller.sendNotification();
                          //           },
                          //           child: Text("Open"),
                          //           textColor: Colors.white,
                          //         ),
                          //         if (product.url.toString() != "null")
                          //           Icon(
                          //             Icons.download_done_outlined,
                          //             size: 16,
                          //             color: Colors.white,
                          //           ),
                          //       ],
                          //     ),
                          //   ),
                        ],
                      ),
                    ),
                  );
                });
          }),
    );
  }

  final Color color = HexColor('#D61C4E');
  @override
  Widget buildSuggestions(BuildContext context) {
    return Scaffold(
      backgroundColor: color,
      body: Container(
        child: Center(
          child: Text(
            'Busqueda de RFC ',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
