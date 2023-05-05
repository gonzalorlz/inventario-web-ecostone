import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:hungry/escanear/escanearController.dart';
import 'package:hungry/interfaces/login_interface.dart';
import 'package:hungry/views/widgets/appBar.dart';
import 'package:hungry/views/widgets/drawer_page.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EscanearPagina extends StatefulWidget {
  @override
  _EscanearPaginaState createState() => _EscanearPaginaState();
}

class _EscanearPaginaState extends State<EscanearPagina> {
  TextEditingController _stockcontroller = TextEditingController();

  final Future _prefs = SharedPreferences.getInstance();
  List<Map<String, dynamic>> inventoryList = [];
  List<Map<String, dynamic>> inventarioBuscarCodigo = [];
  Map _currentInventory;
  final _service = ILogin();
  final controller = EscanearController();
  final scrollController = ScrollController();
  String scancode;
  var controllerStock = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var item;

  @override
  void initState() {
    super.initState();
    _initializeInventoryList();
    _setInventarioBuscarCodigo();
    _getInventory();
  }

  Future _getInventory() async {
    final prefs = await SharedPreferences.getInstance();
    final inventory = prefs.getString('currentInventory');
    if (inventory != null) {
      setState(() {
        _currentInventory = Map<String, dynamic>.from(jsonDecode(inventory));
      });
    }
  }

  Future _initializeInventoryList() async {
    final value = await _service.obtenerInventariosBodega();
    setState(() {
      inventoryList = List<Map<String, dynamic>>.from(value);
    });
  }

  Future _setInventarioBuscarCodigo() async {
    final value = await _service.obtenerInventarios();
    setState(() {
      inventarioBuscarCodigo = List<Map<String, dynamic>>.from(value);
    });
  }

  Future delete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('currentInventory');
    setState(() {
      _currentInventory = null;
    });
  }

  Future<void> addProductoInventarioBodega(Map<String, dynamic> data) async {
    final add = await _service.addproductoInventarioBodega(data);
    return add;
  }

  Widget buildInventoryButton(BuildContext context) {
    if (inventoryList.isEmpty) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      print(
          'el inventorylist es : $inventoryList y es de typE: ${inventoryList.runtimeType}');
      return Center(
        child: ElevatedButton(
          child: Text('Seleccione un inventario ',
              style: TextStyle(fontSize: 18.0)),
          onPressed: () => showDialog(
            context: context,
            builder: (BuildContext context) => Dialog(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: EdgeInsets.all(16.0),
                width: double.maxFinite,
                height: MediaQuery.of(context).size.height * 0.5,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Inventarios : ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24.0,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Scrollbar(
                        child: ListView.builder(
                          controller: scrollController,
                          physics: const AlwaysScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: inventoryList.length,
                          itemBuilder: (BuildContext context, int index) =>
                              InkWell(
                            onTap: () async {
                              final inventory =
                                  json.encode(inventoryList[index]);

                              final prefs =
                                  await SharedPreferences.getInstance();
                              await prefs.setString(
                                  'currentInventory', inventory);

                              setState(() {
                                _currentInventory = jsonDecode(inventory);
                              });

                              Navigator.pop(context);
                            },
                            child: Card(
                              elevation: 6.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        '${inventoryList[index]['nombre']}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20.0,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 8.0),
                                    Flexible(
                                      child: Text(
                                        '${inventoryList[index]['fecha'] != null ? inventoryList[index]['fecha'] : ""}',
                                        style: TextStyle(fontSize: 16.0),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
  }

  Widget viewInventoryDetailButton() => ElevatedButton(
        onPressed: () => _showArrayDetail(context, _currentInventory['_id']),
        child: Text('Ver Detalles del Invenatrio',
            style: TextStyle(fontSize: 18.0)),
      );

  Widget deleteButton() => ElevatedButton(
        onPressed: delete,
        child: Text('Eliminar Inventyario'),
      );

  Future<Widget> currentInventoryDetail() async {
    print('entro aca ');
    final inventoryDetailJson = await _getInventoryDetail();
    Map<String, dynamic> inventoryDetail =
        inventoryDetailJson.isNotEmpty ? jsonDecode(inventoryDetailJson) : {};

    return Center(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: Text(
            'Inventario Seleccionado:',
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 16.0),
        Center(
          child: Text(
            'Nombre: ${_currentInventory['nombre'] ?? ""}',
            style: TextStyle(fontSize: 18.0),
          ),
        ),
        Center(
          child: Text(
            'Fecha: ${_currentInventory['fecha'] != null ? DateFormat('yyyy-MM-dd').format(DateTime.parse(_currentInventory['fecha'])) : ""}',
            style: TextStyle(fontSize: 18.0),
          ),
        ),
        const SizedBox(height: 16.0),
      ],
    ));
  }

  Widget _buildBody(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([_prefs, _getInventoryDetail()]),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        final prefs = snapshot.data[0];
        final inventoryDetail = snapshot.data[1];

        String currentInventorys = prefs.getString('currentInventory') ?? '';
        Map<String, dynamic> currentInventory =
            currentInventorys.isNotEmpty ? jsonDecode(currentInventorys) : null;
        if (currentInventory != null) {
          currentInventory['detail'] = inventoryDetail;
          prefs.setString('currentInventory', jsonEncode(currentInventory));
        }

        return Center(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 24.0),
                OutlinedButton.icon(
                  onPressed: currentInventory == null
                      ? null
                      : () async {
                          final barcodeScanRes =
                              await FlutterBarcodeScanner.scanBarcode(
                            '#ff6666',
                            'Cancelar',
                            true,
                            ScanMode.BARCODE,
                          );
                        },
                  icon: Icon(Icons.qr_code_scanner),
                  label: Text(
                    'Escanear Código',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: 32.0,
                      vertical: 16.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                SizedBox(height: 32.0),
                if (currentInventory == null) buildInventoryButton(context),
                if (currentInventory != null) ...[
                  FutureBuilder(
                    future: currentInventoryDetail(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      return Container(
                        child: snapshot.data,
                      );
                    },
                  ),
                  SizedBox(height: 32.0),
                  Container(
                    constraints: BoxConstraints(maxWidth: 500),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: viewInventoryDetailButton(),
                        ),
                        SizedBox(width: 32.0),
                        Expanded(
                          child: deleteButton(),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 32.0),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Future _getInventoryDetail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('currentInventoryDetail') ?? '';
  }

  dynamic buscarItem(String codigo) {
    for (dynamic obj in inventarioBuscarCodigo) {
      if (obj['arrayDetalle'].length > 200) {
        for (dynamic detalle in obj['arrayDetalle']) {
          if (detalle['codigoFsl'] == codigo) {
            return detalle;
          }
        }
      }
    }
    return null;
  }

  Future _showArrayDetail(BuildContext context, String id) async {
    final response = await _service.obtenerInventarioBodega(id);

    if (response == null) {
      // Handle error here, e.g. show an error message
      return null;
    }

    // Extract inventory array from the response
    final inventory = response['arrayDetalle'];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.8,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Detalle',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: Scrollbar(
                    controller: scrollController,
                    child: ListView.builder(
                      controller: scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: inventory == null ? 0 : inventory.length,
                      itemBuilder: (BuildContext context, int index) {
                        final descripcion =
                            inventory[index]['descripcion'] ?? "N/A";
                        final codigo = inventory[index]['codigo'] ?? "N/A";
                        final stock = inventory[index]['stock'] ?? "N/A";
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Code FSL: ${descripcion}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Code: ${codigo}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'stock: ${stock}',
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Center(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cerrar'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBarWidget().appBar('Scan Page'),
        body: _buildBody(context),
        drawer: MyDrawerWidget(),
      );
}
