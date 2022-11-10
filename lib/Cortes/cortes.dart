import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

import '../RFCDescargas/services/Variables.dart';

class cortes extends StatefulWidget {
  cortes(String string, {Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _cortesState createState() => _cortesState();
}

class _cortesState extends State<cortes> {
  Future<bool> _onWillPopScope() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.WARNING,
      animType: AnimType.BOTTOMSLIDE,
      title: 'Actas al instante',
      desc: getIt<AuthModel>().usuario + ' ¿quieres salir de la aplicación?',
      btnCancelOnPress: () {
        Navigator.of(context).pop(true);
      },
      btnOkOnPress: () {
        exit(0);
      },
    )..show();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: SafeArea(
            child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text(
              'Corte del usuario: ' + getIt<AuthModel>().usuario,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700,
              ),
            ),
            elevation: 5,
            backgroundColor: Colors.redAccent,
          ),
          body: FutureBuilder(
            future: getProductDataSource(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              return snapshot.hasData
                  ? SfDataGrid(source: snapshot.data, columns: getColumns())
                  : Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 5,
                      ),
                    );
            },
          ),
        )),
        onWillPop: _onWillPopScope);
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
              child: Text('Documento',
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.clip,
                  softWrap: true))),
      GridTextColumn(
          columnName: 'Estado',
          autoFitPadding: EdgeInsets.all(10.0),
          width: 180,
          label: Container(
              padding: EdgeInsets.all(8),
              alignment: Alignment.topCenter,
              child: Text('Estado',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.clip,
                  softWrap: true))),
      GridTextColumn(
          columnName: 'Nombre (Acta)',
          autoFitPadding: EdgeInsets.all(10.0),
          width: 290,
          label: Container(
              padding: EdgeInsets.all(8),
              alignment: Alignment.topCenter,
              child: Text('Nombre (Acta)',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.clip,
                  softWrap: true))),
      GridTextColumn(
          columnName: 'Fecha',
          width: 180,
          label: Container(
              padding: EdgeInsets.all(8),
              alignment: Alignment.topCenter,
              child:
                  Text('Fecha', overflow: TextOverflow.clip, softWrap: true))),
      GridTextColumn(
          columnName: 'Precio',
          width: 90,
          label: Container(
              padding: EdgeInsets.all(8),
              alignment: Alignment.topCenter,
              child: Text('Precio')))
    ];
  }

  Future<List<Product>> generateProductList() async {
    Map<String, String> mainheader = new Map();
    mainheader["content-type"] = "application/json";
    mainheader['x-access-token'] = getIt<AuthModel>().token;
    var response = await http.get(
      Uri.parse(
          'https://actasalinstante.com:3030/api/actas/reg/Corte/984/2022-06-04'),
      headers: mainheader,
    );
    var decodedProducts =
        json.decode(response.body).cast<Map<String, dynamic>>();
    List<Product> productList = await decodedProducts
        .map<Product>((json) => Product.fromJson(json))
        .toList();
    return productList;
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
    columnWidthMode:
    ColumnWidthMode.auto;
    return DataGridRowAdapter(cells: [
      Container(
        child: Text(
          row.getCells()[0].value.toString(),
          overflow: TextOverflow.ellipsis,
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
        ),
      ),
      Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(16.0),
        child: Text(
          DateFormat('MM/dd/yyyy').format(row.getCells()[4].value).toString(),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(8.0),
          child: Text(
            row.getCells()[5].value.toStringAsFixed(1),
            overflow: TextOverflow.ellipsis,
          ))
    ]);
  }

  @override
  List<DataGridRow> get rows => dataGridRows;

  void buildDataGridRow() {
    dataGridRows = productList.map<DataGridRow>((dataGridRow) {
      return DataGridRow(cells: [
        DataGridCell(columnName: '#', value: dataGridRow.orderID),
        DataGridCell<String>(
            columnName: 'Documento', value: dataGridRow.customerID),
        DataGridCell<String>(
            columnName: 'Estado', value: dataGridRow.employeeID),
        DataGridCell<String>(
            columnName: 'Nombre(Acta)', value: dataGridRow.nombre),
        DataGridCell<DateTime>(
            columnName: 'Fecha', value: dataGridRow.orderDate),
        DataGridCell<int>(columnName: 'Precio', value: dataGridRow.freight)
      ]);
    }).toList(growable: false);
  }
}

class Product {
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      orderID: json['client']["id"],
      customerID: json['document'],
      employeeID: json['state'],
      nombre: json['nameinside'],
      orderDate: DateTime.parse(json['createdAt']),
      shippedDate: DateTime.parse(json['createdAt']),
      freight: json['price'],
    );
  }
  Product({
    this.orderID,
    this.customerID,
    this.employeeID,
    this.orderDate,
    this.shippedDate,
    this.freight,
    this.nombre,
  });
  final int orderID;
  final String customerID;
  final String employeeID;
  final String nombre;
  final DateTime orderDate;
  final DateTime shippedDate;
  final int freight;
}
