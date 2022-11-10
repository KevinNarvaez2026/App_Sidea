import 'dart:io';

import 'package:android_intent/flag.dart';
import 'package:app_actasalinstante/views/controller/controller.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:app_actasalinstante/models/product.dart';

import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../RFCDescargas/services/Variables.dart';
import '../Search/constants.dart';
import '../Search/serach.dart';
import 'package:android_intent/android_intent.dart';

class ProductTile extends StatelessWidget {
  final Product product;
  const ProductTile(this.product);

  Future<File> _downloadFile(String filename) async {
    Map<String, String> mainheader = new Map();
    mainheader["content-type"] = "application/pdf";
    mainheader['x-access-token'] = getIt<AuthModel>().token;
    http.Client client = new http.Client();
    var req = await client.get(
        Uri.parse(
            'https://actasalinstante.com:3030/api/actas/requests/getMyActa/' +
                product.id.toString()),
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

  Future<File> openfile(String filename) async {
    //String uriFile = Uri.encodeFull("/storage/emulated/0/Download/${filename}");

    String dir = (await getApplicationDocumentsDirectory()).path;
    print(dir);
    if (Platform.isAndroid) {
      final AndroidIntent intent = AndroidIntent(
        action: "action_view",
        data: dir,
        type: "*/*",
        // type: "multipart/",
        flags: [
          Flag.FLAG_GRANT_READ_URI_PERMISSION,
          Flag.FLAG_GRANT_PERSISTABLE_URI_PERMISSION,
          Flag.FLAG_ACTIVITY_NEW_TASK
        ],
      );

      intent.launch();
    }
  }

//  String formattedDate =
  //                             DateFormat('yyyy-MM-dd').format(product.fecha.toString());

  @override
  Widget build(BuildContext context) {
    final _controller = Get.find<Controller>();

    return Card(
      elevation: 90,
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
//             for (var i = 0; i < productController.productList.length; i++)

// // for (int i = 0; i < count.length; i++)
            // Text(
            //   "" + product.id.toString(),
            //   maxLines: 2,
            //   style: TextStyle(
            //       fontSize: 17,
            //       fontFamily: 'avenir',
            //       fontWeight: FontWeight.w800,
            //       color: Colors.black),
            //   overflow: TextOverflow.ellipsis,
            // ),
            Stack(
              children: [
                if (product.metadata.toString() == "NACIMIENTO")
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Center(
// Image radius
                      child: Image.asset('assets/NAC.png',
                          alignment: Alignment.center, fit: BoxFit.cover),
                    ),
                  ),
                if (product.type.toString() == "Cadena Digital")
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Center(
// Image radius
                      child: Image.asset('assets/desconocido.png',
                          alignment: Alignment.center, fit: BoxFit.cover),
                    ),
                  ),
                if (product.metadata.toString() == "MATRIMONIO")
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Center(
// Image radius
                      child: Image.asset('assets/matrimonio.png',
                          alignment: Alignment.center, fit: BoxFit.cover),
                    ),
                  ),
                if (product.metadata.toString() == "DIVORCIO")
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Center(
// Image radius
                      child: Image.asset('assets/divorcio.png',
                          alignment: Alignment.center, fit: BoxFit.cover),
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
                if (product.url.toString() != "null")
                  Positioned(
                    right: 0,
                    child: Obx(() => CircleAvatar(
                          backgroundColor: Colors.green,
                          child: IconButton(
                            icon: product.isFavorite.value
                                ? Icon(Icons.download_done)
                                : Icon(Icons.download),
                            color: Colors.white,
                            onPressed: () {
                              {
                                if (product.url == null) {
                                  var snackBar = SnackBar(
                                    elevation: 20,
                                    behavior: SnackBarBehavior.floating,
                                    backgroundColor: Colors.transparent,
                                    content: AwesomeSnackbarContent(
                                      title: 'No se puede descargar! ',
                                      message: 'Archvio ' +
                                          product.url.toString() +
                                          ' Con detalles',
                                      contentType: ContentType.failure,
                                    ),
                                  );

                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                  // Perform set of instructions.
                                } else {
                                  _downloadFile(product.url.toString());
                                  openfile(product.url.toString());
                                  _controller.sendNotification();

                                  var snackBar = SnackBar(
                                    elevation: 0,
                                    behavior: SnackBarBehavior.floating,
                                    backgroundColor: Colors.transparent,
                                    content: AwesomeSnackbarContent(
                                      title: 'Acta descargada! ',
                                      message: '/storage/emulated/0/Download/' +
                                          product.url.toString(),
                                      contentType: ContentType.success,
                                    ),
                                  );

                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);

                                  //  customIcon = const Icon(Icons.search);
                                  //  customSearchBar = const Text('My Personal Journal');
                                }
                              }

                              product.isFavorite.toggle();
                            },
                          ),
                        )),
                  ),
              ],
            ),
            new Center(
              child: Text(
                " " + product.type.toString(),
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
                "Fecha y Hora: " + product.fecha.toString(),
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
                  color: Colors.black),
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 8),
            if (product.type.toString() == "Datos Personales")
              Text(
                "Tipo de busqueda: " + product.type.toString(),
                maxLines: 2,
                style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'avenir',
                    fontWeight: FontWeight.w800,
                    color: Colors.black),
                overflow: TextOverflow.ellipsis,
              ),
            if (product.type.toString() == "CURP")
              Text(
                "Tipo de busqueda: " + product.type.toString(),
                maxLines: 2,
                style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'avenir',
                    fontWeight: FontWeight.w800,
                    color: Colors.black),
                overflow: TextOverflow.ellipsis,
              ),
            if (product.type.toString() == "CURP")
              Text(
                "Tipo: " + product.metadata.toString(),
                maxLines: 2,
                style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'avenir',
                    fontWeight: FontWeight.w800,
                    color: Colors.black),
                overflow: TextOverflow.ellipsis,
              ),
            if (product.type.toString() == "CURP")
              Text(
                "Curp: " + product.metadatas.toString(),
                maxLines: 2,
                style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'avenir',
                    fontWeight: FontWeight.w800,
                    color: Colors.black),
                overflow: TextOverflow.ellipsis,
              ),
            if (product.type.toString() == "CURP")
              Text(
                "Estado: " + product.metadataestado.toString(),
                maxLines: 2,
                style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'avenir',
                    fontWeight: FontWeight.w800,
                    color: Colors.black),
                overflow: TextOverflow.ellipsis,
              ),
            if (product.type.toString() == "Cadena Digital")
              Text(
                "Tipo de busqueda: " + product.type.toString(),
                maxLines: 2,
                style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'avenir',
                    fontWeight: FontWeight.w800,
                    color: Colors.black),
                overflow: TextOverflow.ellipsis,
              ),
            if (product.type.toString() == "Cadena Digital")
              Text(
                "Cadena: " + product.metadatacadena.toString(),
                maxLines: 2,
                style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'avenir',
                    fontWeight: FontWeight.w800,
                    color: Colors.black),
                overflow: TextOverflow.ellipsis,
              ),
            if (product.type.toString() == "Datos Personales")
              Text(
                "Nombre(s): " + product.metadatanombres.toString(),
                maxLines: 2,
                style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'avenir',
                    fontWeight: FontWeight.w800,
                    color: Colors.black),
                overflow: TextOverflow.ellipsis,
              ),
            if (product.type.toString() == "Datos Personales")
              Text(
                "Primer Apellido: " + product.metadataapellido1.toString(),
                maxLines: 2,
                style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'avenir',
                    fontWeight: FontWeight.w800,
                    color: Colors.black),
                overflow: TextOverflow.ellipsis,
              ),
            if (product.type.toString() == "Datos Personales")
              Text(
                "Segundo Apellido: " + product.metadataapellido2.toString(),
                maxLines: 2,
                style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'avenir',
                    fontWeight: FontWeight.w800,
                    color: Colors.black),
                overflow: TextOverflow.ellipsis,
              ),
            if (product.type.toString() == "Datos Personales")
              if (product.metadata.toString() != "NACIMIENTO")
                Text(
                  "Nombre(s): " + product.snombre.toString(),
                  maxLines: 2,
                  style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'avenir',
                      fontWeight: FontWeight.w800,
                      color: Colors.black),
                  overflow: TextOverflow.ellipsis,
                ),
            if (product.type.toString() == "Datos Personales")
              if (product.metadata.toString() != "NACIMIENTO")
                Text(
                  "Primer Apellido: " + product.sprimerapellido.toString(),
                  maxLines: 2,
                  style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'avenir',
                      fontWeight: FontWeight.w800,
                      color: Colors.black),
                  overflow: TextOverflow.ellipsis,
                ),
            if (product.type.toString() == "Datos Personales")
              if (product.metadata.toString() != "NACIMIENTO")
                Text(
                  "Segundo Apellido: " + product.ssegundoapellido.toString(),
                  maxLines: 2,
                  style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'avenir',
                      fontWeight: FontWeight.w800,
                      color: Colors.black),
                  overflow: TextOverflow.ellipsis,
                ),
            if (product.url.toString() != "null")
              Text(
                "Nombre del archivo: " + product.url.toString(),
                maxLines: 2,
                style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'avenir',
                    fontWeight: FontWeight.w800,
                    color: Colors.black),
                overflow: TextOverflow.ellipsis,
              ),
            if (product.url.toString() == "null")
              Text(
                "SIN ARCHIVO",
                maxLines: 2,
                style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'avenir',
                    fontWeight: FontWeight.w800,
                    color: Colors.red),
                overflow: TextOverflow.ellipsis,
              ),
            SizedBox(height: 8),

            if (product.url.toString() != "null")
              new Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(82),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      MaterialButton(
                        onPressed: () {
                          _downloadFile(product.url.toString());
                          openfile(product.url.toString());
                          _controller.sendNotification();
                        },
                        child: Text("Descargar"),
                        textColor: Colors.white,
                      ),
                      if (product.url.toString() != "null")
                        Icon(
                          Icons.download_done_outlined,
                          size: 15,
                          color: Colors.white,
                        ),
                    ],
                  ),
                ),
              ),

            // SizedBox(height: 8),
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
  }
}
