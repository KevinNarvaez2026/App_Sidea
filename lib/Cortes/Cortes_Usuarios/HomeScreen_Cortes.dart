import 'dart:ffi';
import 'dart:ffi';
import 'dart:io';

import 'package:app_actasalinstante/DropDown/Descargar_actas/animation/FadeAnimation.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:excel/excel.dart';
import 'package:syncfusion_flutter_datagrid_export/export.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Column, Row;

import '../../SplashScreen/Splashscreen1.dart';
// Local import
import 'helper/save_file_mobile_desktop.dart'
    if (dart.library.html) 'helper/save_file_web.dart' as helper;

import '../../SplashScreen/Splashscreen1.dart';

class Cortes_Screen extends StatefulWidget {
  @override
  _Cortes_ScreenState createState() => _Cortes_ScreenState();
}

class _Cortes_ScreenState extends State<Cortes_Screen>
    with TickerProviderStateMixin {
  @override
  void initState() {
    getdates();

    // TODO: implement initState
    super.initState();
    Lenguaje();
    GetNames();
  }

  //VOICE
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
    // print(langCode);
  }

  void _speak(voice) async {
    initSetting();
    await flutterTts.speak(voice);
  }

  ShowDialog() {
    var snackBar = SnackBar(
      elevation: 0,
      duration: const Duration(seconds: 10),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: 'Toque la parte blanca',
        message: 'Para ver más información del acta\n Solicitada',
        contentType: ContentType.help,
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    _speak(user +
        ',Toque la parte blanca, Para ver mas información de su acta solicitada');
  }

  String user = "";
  GetNames() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      user = prefs.getString('username');
    });
    _speak('Bienvenido,' + user + ', a tu apartado de corte');
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
      Uri.parse(
          'https://actasalinstante.com:3030/api/actas/reg/corte/MyDates/'),
      headers: mainheader,
    );
    var resBody = json.decode(response.body);
    if (response.statusCode == 200) {
      for (var i = 0; i < resBody.length; i++) {
        // print(resBody[i]);
      }
    }

    // ShowDialog();

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

  String Cortes;

  int selectedIndex;
  int count;
  final GlobalKey<SfDataGridState> _datosgrid = GlobalKey<SfDataGridState>();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: SafeArea(
            child: Scaffold(
          backgroundColor: Colors.white,
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
                      Cortes = newVal;
                      // Get_Cortes(Cortes);
                    });
                  },
                  value: Cortes,
                ),
              ),
              new Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(82),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      MaterialButton(
                        height: 20,
                        elevation: 5,
                        onPressed: () {
                          _speak(
                              'Espere un momento porfavor, estamos descagando su corte');
                          exportDataGridToExcel();
                          // _downloadFile(
                          //     '${data[index].id}'
                          //         .toString(),
                          //     '${data[index].website}'
                          //         .toString());
                          // _animationController.forward();
                          //  _controller.sendNotification();
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
            ],
            automaticallyImplyLeading: false,
            elevation: 0,
            backgroundColor: Colors.white,
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
          body: FutureBuilder(
            future: getProductDataSource(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              return snapshot.hasData
                  ? SfDataGrid(
                      key: _datosgrid,
                      source: snapshot.data,
                      columns: getColumns())
                  : Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 8,
                      ),
                    );
            },
          ),
        )),
        onWillPop: _onWillPopScope);
  }

  Future<void> exportDataGridToExcel() async {
    try {
      print(_datosgrid.currentState);
      //  await Future.delayed(Duration(seconds: 5));
      final Workbook workbook =
          _datosgrid.currentState?.exportToExcelWorkbook();
      print(workbook);
      final List<int> bytes = workbook.saveAsStream();
      workbook.dispose();

      await helper.saveAndLaunchFile(bytes, 'DataGrid.xlsx');
    } catch (e) {
      print(e);
      _speak(e.toString());
    }
  }

  Future<ProductDataGridSource> getProductDataSource() async {
    var productList = await generateProductList();

    return ProductDataGridSource(productList);
  }

  List<GridColumn> getColumns() {
    return <GridColumn>[
      GridTextColumn(
          columnName: 'Id',
          autoFitPadding: EdgeInsets.all(2.0),
          width: 60,
          label: Container(
              //padding: EdgeInsets.all(18),
              alignment: Alignment.topCenter,
              child: Text('Id', overflow: TextOverflow.clip, softWrap: true))),
      GridTextColumn(
          columnName: 'Documento',
          autoFitPadding: EdgeInsets.all(10.0),
          width: 180,
          label: Container(
              padding: EdgeInsets.all(8),
              alignment: Alignment.topCenter,
              child: Text(
                'Documento',
                textAlign: TextAlign.left,
                overflow: TextOverflow.clip,
                softWrap: true,
                style: TextStyle(fontSize: 19, color: Colors.black),
              ))),
      GridTextColumn(
          columnName: 'Estado',
          autoFitPadding: EdgeInsets.all(10.0),
          width: 180,
          label: Container(
              padding: EdgeInsets.all(8),
              alignment: Alignment.topCenter,
              child: Text(
                'Estado',
                textAlign: TextAlign.center,
                overflow: TextOverflow.clip,
                softWrap: true,
                style: TextStyle(fontSize: 19, color: Colors.black),
              ))),
      GridTextColumn(
          columnName: 'Nombre',
          autoFitPadding: EdgeInsets.all(10.0),
          width: 290,
          label: Container(
              padding: EdgeInsets.all(8),
              alignment: Alignment.topCenter,
              child: Text(
                'Nombre',
                textAlign: TextAlign.center,
                overflow: TextOverflow.clip,
                softWrap: true,
                style: TextStyle(fontSize: 19, color: Colors.black),
              ))),
      GridTextColumn(
          columnName: 'Fecha',
          width: 180,
          label: Container(
              padding: EdgeInsets.all(8),
              alignment: Alignment.topCenter,
              child: Text(
                'Fecha',
                overflow: TextOverflow.clip,
                softWrap: true,
                style: TextStyle(fontSize: 19, color: Colors.black),
              ))),
      GridTextColumn(
          columnName: 'Precio',
          width: 90,
          label: Container(
              padding: EdgeInsets.all(8),
              alignment: Alignment.topCenter,
              child: Text(
                'Precio',
                style: TextStyle(fontSize: 19, color: Colors.black),
              )))
    ];
  }

  int indexs;
  Future<List<Product>> generateProductList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Token = prefs.getString('token');
    Map<String, String> mainheader = new Map();
    mainheader["content-type"] = "application/json";
    mainheader['x-access-token'] = Token;
    if (Cortes == null) {
      var response = await get(
        Uri.parse(
            'https://actasalinstante.com:3030/api/actas/reg/myCorte/null'),
        headers: mainheader,
      );
      var decodedProducts =
          json.decode(response.body).cast<Map<String, dynamic>>();
      List<Product> productList = await decodedProducts
          .map<Product>((json) => Product.fromJson(json))
          .toList();
      // print("hola");
      //  print(decodedProducts);

      return productList;
    } else {
      var response = await get(
        Uri.parse(
            'https://actasalinstante.com:3030/api/actas/reg/myCorte/' + Cortes),
        headers: mainheader,
      );
      var decodedProducts =
          json.decode(response.body).cast<Map<String, dynamic>>();
      List<Product> productList = await decodedProducts
          .map<Product>((json) => Product.fromJson(json))
          .toList();
      // print("hola");
      //  print(decodedProducts);

      return productList;
    }

    // index = decodedProducts;

    // var date_Cortes = json.decode(response.body);
    // if (response.statusCode == 200) {
    //   for (var i = 0; i < date_Cortes.length; i++) {
    //     print(date_Cortes[i]);
    //     print(date_Cortes[i]['document']);
    //   }
    // }
  }

//EXCEL

  Future exportReport() async {
    final excel = Excel.createExcel();

    final sheet = excel.sheets[excel.getDefaultSheet() as String];
    sheet.setColWidth(2, 50);
    sheet.setColAutoFit(3);

    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 1)).value =
        'Id';

    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 2)).value =
        'Documento';

    //var excel = Excel.createExcel();
    DateTime _now = DateTime.now();
    String _name = DateFormat('yyyy-MM-dd').format(_now);
    String _fileName = user.toString() + _name;

    List<int> potato = excel.save(fileName: _name);

    PermissionStatus status = await Permission.storage.request();
    if (status == PermissionStatus.granted) {
      await File('/storage/emulated/0/Download/$_fileName.xlsx')
          .writeAsBytes(potato, flush: true)
          .then((value) {
        print('saved');
      });
    } else if (status == PermissionStatus.denied) {
      print(
          'Denied. Show a dialog with a reason and again ask for the permission.');
    } else if (status == PermissionStatus.permanentlyDenied) {
      print('Take the user to the settings page.');
    }

    return null;
  }

  _exportToExcel() {
    final excel = Excel.createExcel();
    final sheet = excel.sheets[excel.getDefaultSheet() as String];
    sheet.setColWidth(2, 50);
    sheet.setColAutoFit(3);

    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 1)).value =
        'Id';

    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: 2)).value =
        'Documento';

    excel.save();
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

class ProductDataGridSource extends DataGridSource {
  ProductDataGridSource(this.productList) {
    buildDataGridRow();
  }
  List<DataGridRow> dataGridRows;
  List<Product> productList;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    ColumnWidthMode.auto;
    return DataGridRowAdapter(cells: [
      Container(
        child: Text(
          row.getCells()[0].value.toString(),
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 14, color: Colors.black),
        ),
        alignment: Alignment.center,
        padding: EdgeInsets.all(16.0),
      ),
      Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(16.0),
        height: 100,
        child: Text(
          row.getCells()[1].value,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 14, color: Colors.black),
        ),
      ),
      Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(16.0),
        height: 100,
        width: 10,
        child: Text(
          row.getCells()[2].value.toString(),
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 14, color: Colors.black),
        ),
      ),
      Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(16.0),
        height: 100,
        width: 10,
        child: Text(
          row.getCells()[3].value.toString(),
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 14, color: Colors.black),
        ),
      ),
      Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(16.0),
        child: Text(
          DateFormat('dd/mm/yyyy').format(row.getCells()[4].value).toString(),
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 14, color: Colors.black),
        ),
      ),
      Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(8.0),
          child: Text(
            row.getCells()[5].value.toString(),
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 14, color: Colors.black),
          ))
    ]);
  }

  @override
  List<DataGridRow> get rows => dataGridRows;

  void buildDataGridRow() {
    dataGridRows = productList.map<DataGridRow>((dataGridRow) {
      return DataGridRow(cells: [
        DataGridCell(columnName: '#', value: 0.toString()),
        DataGridCell<String>(
            columnName: 'Documento', value: dataGridRow.customerID),
        DataGridCell<String>(
            columnName: 'Estado', value: dataGridRow.employeeID),
        DataGridCell<String>(columnName: 'Nombre', value: dataGridRow.nombre),
        DataGridCell<DateTime>(
            columnName: 'Fecha', value: dataGridRow.orderDate),
        DataGridCell<int>(columnName: 'Precio', value: dataGridRow.freight),
        DataGridCell<int>(columnName: 'Total', value: dataGridRow.freight)
      ]);
    }).toList(growable: false);
  }
}

class Product {
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      // orderID: json['client']["id"],
      customerID: json['document'],
      employeeID: json['state'],
      nombre: json['nameinside'],
      orderDate: DateTime.parse(json['createdAt']),
      //  shippedDate: DateTime.parse(json['createdAt']),
      freight: json['price0'],
    );
  }
  Product({
    // this.orderID,
    this.customerID,
    this.employeeID,
    this.orderDate,
    this.shippedDate,
    this.freight,
    this.nombre,
  });
  // final int orderID;
  final String customerID;
  final String employeeID;
  final String nombre;
  final DateTime orderDate;
  final DateTime shippedDate;
  final int freight;
}










// class Cortes_Screen extends StatefulWidget {
//   @override
//   _Cortes_ScreenState createState() => _Cortes_ScreenState();
// }

// class _Cortes_ScreenState extends State<Cortes_Screen>
//     with TickerProviderStateMixin {
//   List<Employee> employees = <Employee>[];
//   EmployeeDataGridSource employeeDataGridSource;

//   final GlobalKey<SfDataGridState> _key = GlobalKey<SfDataGridState>();

//   @override
//   void initState() {
//     super.initState();
//     employees = getEmployeeData();
//     employeeDataGridSource = EmployeeDataGridSource(employeeData: employees);
//  generateProductList();
//   }

//   Future<void> exportDataGridToExcel() async {
//     final Workbook workbook = _key.currentState.exportToExcelWorkbook();

//     final List<int> bytes = workbook.saveAsStream();
//     workbook.dispose();
//     print("saved");
//     await helper.saveAndLaunchFile(bytes, 'DataGrid.xlsx');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(title: const Text('Syncfusion Flutter DataGrid Export')),
//         body: Column(children: <Widget>[
//           Container(
//               margin: const EdgeInsets.all(12.0),
//               child: Row(children: <Widget>[
//                 SizedBox(
//                     height: 40.0,
//                     width: 150.0,
//                     child: MaterialButton(
//                         color: Colors.blue,
//                         child: const Center(
//                             child: Text('Export to Excel',
//                                 style: TextStyle(color: Colors.white))),
//                         onPressed: exportDataGridToExcel))
//               ])),
//           Expanded(
//               child: SfDataGrid(
//                   key: _key,
//                   source: employeeDataGridSource,
//                   columns: <GridColumn>[
//                 GridColumn(
//                     columnName: 'ID',
//                     label: Container(
//                         padding: const EdgeInsets.all(16.0),
//                         alignment: Alignment.center,
//                         child: const Text('ID'))),
//                 GridColumn(
//                     columnName: 'Name',
//                     label: Container(
//                         padding: const EdgeInsets.all(8.0),
//                         alignment: Alignment.center,
//                         child: const Text('Name'))),
//                 GridColumn(
//                     columnName: 'Designation',
//                     label: Container(
//                         padding: const EdgeInsets.all(8.0),
//                         alignment: Alignment.center,
//                         child: const Text('Designation',
//                             overflow: TextOverflow.ellipsis))),
//                 GridColumn(
//                     columnName: 'Salary',
//                     label: Container(
//                         padding: const EdgeInsets.all(8.0),
//                         alignment: Alignment.center,
//                         child: const Text('Salary')))
//               ]))
//         ]));
//   }

  
//   var document;
//   var Cortes;
//     int indexs;
//     Future<List<Employee>> generateProductList() async {
//       SharedPreferences prefs = await SharedPreferences.getInstance();

//       Token = prefs.getString('token');
//       Map<String, String> mainheader = new Map();
//       mainheader["content-type"] = "application/json";
//       mainheader['x-access-token'] = Token;
//       if (Cortes == null) {
//         var response = await get(
//           Uri.parse(
//               'https://actasalinstante.com:3030/api/actas/reg/myCorte/null'),
//           headers: mainheader,
//         );
//         var decodedProducts =
//             json.decode(response.body).cast<Map<String, dynamic>>();
//         List<Employee> productList = await decodedProducts
//             .map<Employee>((json) => Employee.fromJson(json))
//             .toList();
//         // print("hola");
//         for (var i = 0; i < decodedProducts.length; i++) {
//        //    print(decodedProducts[i]['document']);
          
//              document = decodedProducts[i]['document'];
//              print(document);
      
//         }
       

//         return productList;
//       } else {
//         var response = await get(
//           Uri.parse('https://actasalinstante.com:3030/api/actas/reg/myCorte/' +
//               Cortes),
//           headers: mainheader,
//         );
//         var decodedProducts =
//             json.decode(response.body).cast<Map<String, dynamic>>();
//         List<Employee> productList = await decodedProducts
//             .map<Employee>((json) => Employee.fromJson(json))
//             .toList();
//         // print("hola");
//         //  print(decodedProducts);

//         return productList;
//       }
//     }
//     List<Employee> getEmployeeData() {

//       return <Employee>[
      
//       Employee("10001", document.toString(), 'Project Lead', 20000),
   
//     ];
 
    
//   }
//   String _mySelection;

//   List data = List();
//   String Token = "";
//   Future<String> getdates({String query}) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();

//     setState(() {
//       Token = prefs.getString('token');
//     });
//     //print(Token);
//     Map<String, String> mainheader = new Map();
//     mainheader["content-type"] = "application/json";
//     mainheader['x-access-token'] = Token;
//     var response = await get(
//       Uri.parse(
//           'https://actasalinstante.com:3030/api/actas/reg/corte/MyDates/'),
//       headers: mainheader,
//     );
//     var resBody = json.decode(response.body);
//     if (response.statusCode == 200) {
//       for (var i = 0; i < resBody.length; i++) {
//         print(resBody[i]);
//       }
//     }

//     // ShowDialog();

//     if (response.statusCode == 401) {
//       // AnimationsError();

//       prefs.remove('token');
//       prefs.remove('username');
//       await Future.delayed(Duration(seconds: 2));
//       Navigator.pushReplacement(context,
//           MaterialPageRoute(builder: (BuildContext ctx) => SplashScreen()));
//     }

//     setState(() {
//       data = resBody;
//       // print(data);
//     });
//     // if (response.statusCode == 200) {
//     //   //_controller.sendNotification();
//     //   data = jsonDecode(response.body);
//     //  // print(data);
//     // } else {
//     //   print("fetch error");
//     // }

//     // return results;
  
//   }
// }

// class Employee {
//   /// Creates the employee class with required details.
//   Employee(this.id, this.name, this.designation, this.salary);

//   /// Id of an employee.
//   String id;

//   /// Name of an employee.
//   String name;

//   /// Designation of an employee.
//   String designation;

//   /// Salary of an employee.
//   int salary;

//   Employee.fromJson(Map<String, dynamic> json) {
//     id = json['document'];
//   }

  
// }

// /// An object to set the employee collection data source to the datagrid. This
// /// is used to map the employee data to the datagrid widget.
// class EmployeeDataGridSource extends DataGridSource {
//   /// Creates the employee data source class with required details.
//   EmployeeDataGridSource({List<Employee> employeeData}) {
//     _employeeData = employeeData
//         .map<DataGridRow>((Employee dataGridRow) =>
//             DataGridRow(cells: <DataGridCell>[
//               DataGridCell<String>(columnName: 'ID', value: dataGridRow.id),
//               DataGridCell<String>(columnName: 'Name', value: dataGridRow.name),
//               DataGridCell<String>(
//                   columnName: 'Designation', value: dataGridRow.designation),
//               DataGridCell<int>(
//                   columnName: 'Salary', value: dataGridRow.salary),
//             ]))
//         .toList();
//   }

//   List<DataGridRow> _employeeData = <DataGridRow>[];

//   @override
//   List<DataGridRow> get rows => _employeeData;

//   @override
//   DataGridRowAdapter buildRow(DataGridRow row) {
//     return DataGridRowAdapter(
//         cells: row.getCells().map<Widget>((DataGridCell cell) {
//       return Container(
//         alignment: Alignment.center,
//         padding: const EdgeInsets.all(8.0),
//         child: Text(cell.value.toString()),
//       );
//     }).toList());
//   }
// }
