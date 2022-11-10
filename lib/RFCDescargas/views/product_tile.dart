import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:android_intent/android_intent.dart';
import 'package:android_intent/flag.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:app_actasalinstante/RFCDescargas/models/product.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:image_downloader/image_downloader.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../views/controller/controller.dart';
import '../services/Variables.dart';

Icon customIcon = const Icon(Icons.search);
Widget customSearchBar = const Text('My Personal Journal');

class ProductTile extends StatelessWidget {
  final Product product;
  const ProductTile(this.product);

  Future<File> _downloadFile(String filename) async {
    Map<String, String> mainheader = new Map();
    mainheader["content-type"] = "application/pdf";
    mainheader['x-access-token'] = getIt<AuthModel>().token;
    http.Client client = new http.Client();
    var req = await client.get(
        Uri.parse('https://actasalinstante.com:3030/api/rfc/request/donwload/' +
            product.id.toString()),
        headers: mainheader);
    var bytes = req.bodyBytes;

    String dir;
    if (Platform.isAndroid) {
      dir = (await getExternalStorageDirectory()).path;
      print(dir);
      //String dir = (await getApplicationDocumentsDirectory()).path;
      File file = new File('/storage/emulated/0/Download/$filename');
      await file.writeAsBytes(bytes);
      return file;
    }
  }

  Future<File> openfile(String filename) async {
    String uriFile = Uri.encodeFull("/storage/emulated/0/Download/${filename}");

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

  @override
  Widget build(BuildContext context) {
    final _controller = Get.find<Controller>();
  


    return Card(
      //color: Color.fromARGB(255, 27, 98, 156),
      elevation: 20,
      semanticContainer: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      color: Color.fromARGB(255, 232, 234, 246),

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(44),
      ),

      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Center(
// Image radius
                    child: Image.asset('assets/rfc.png',
                        alignment: Alignment.center, fit: BoxFit.cover),
                  ),
                ),
                //        BackdropFilter(
                //   child: Container(
                //     color: Colors.black12,
                //   ),
                //   filter: ImageFilter.blur(sigmaY: 1, sigmaX: 1),
                // ),
                Container(
                  height: 132,
                  width: double.infinity,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
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
                                if (product.isFavorite == Icons.download_done) {
                                  // Perform set of instructions.
                                } else {
                                  _downloadFile(product.url.toString());
                                  _controller.sendNotification();
                                  openfile(product.url.toString());
                                  var snackBar = SnackBar(
                                    elevation: 0,
                                    behavior: SnackBarBehavior.floating,
                                    backgroundColor: Colors.transparent,
                                    content: AwesomeSnackbarContent(
                                      title: 'RFC descargada! ',
                                      message: '' + product.url.toString(),
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
                  )
              ],
            ),
            SizedBox(height: 8),
            new Center(
              child: Text(
                "REGISTRO FEDERAL DE CONTRIBUYENTES",
                maxLines: 2,
                style: TextStyle(
                    fontSize: 19,
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
            Text(
              "Curp: " + product.metadata.toString(),
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
                "SIN ARCHIVO ",
                maxLines: 2,
                style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'avenir',
                    fontWeight: FontWeight.w800,
                    color: Colors.red),
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
                          if (product.url == null) {
                            var snackBar = SnackBar(
                              elevation: 0,
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
                            _controller.sendNotification();
                            openfile(product.url.toString());

                            var snackBar = SnackBar(
                              elevation: 0,
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.transparent,
                              content: AwesomeSnackbarContent(
                                title: 'RFC descargada! ',
                                message: '' + product.url.toString(),
                                contentType: ContentType.success,
                              ),
                            );

                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            //  customIcon = const Icon(Icons.search);
                            //  customSearchBar = const Text('My Personal Journal');
                          }
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
          ],
        ),
      ),
    );
  }
}
