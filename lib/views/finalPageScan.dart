import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:hungry/escanear/escanearController.dart';
import 'package:hungry/interfaces/login_interface.dart';
import 'package:hungry/views/widgets/appBar.dart';
import 'package:hungry/views/widgets/drawer_page.dart';
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
  Map currentInventory;
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
        currentInventory = null;
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
      currentInventory = null;
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
      return Center(
        child: ElevatedButton(
          child: Text('Mostrar Inventarios', style: TextStyle(fontSize: 18.0)),
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
                                currentInventory = jsonDecode(inventory);
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

  Widget viewInventoryDetailButton(
    BuildContext context,
  ) =>
      ElevatedButton(
        onPressed: () => _showArrayDetail(context, currentInventory['_id']),
        child: Text('Ver Detalles del Invenatrio',
            style: TextStyle(fontSize: 18.0)),
      );

  Widget deleteButton() => ElevatedButton(
        onPressed: delete,
        child: Text('Delete Inventory'),
      );

  Widget _buildBody(BuildContext context) {
    return FutureBuilder(
      future: _prefs,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final prefs = snapshot.data;
        String currentInventorys = prefs.getString('currentInventory') ?? '';
        if (currentInventorys.isNotEmpty) {
          currentInventory = jsonDecode(currentInventorys);
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (currentInventory == null) buildInventoryButton(context),
              if (currentInventory != null) ...[
                currentInventoryDetail(context),
                SizedBox(height: 16.0),
                viewInventoryDetailButton(context),
                SizedBox(height: 16.0),
                deleteButton(),
                SizedBox(height: 16.0),
              ],
              ElevatedButton(
                onPressed: () async {
                  final barcodeScanRes =
                      await FlutterBarcodeScanner.scanBarcode(
                    '#ff6666',
                    'Cancel',
                    true,
                    ScanMode.BARCODE,
                  );

                  if (barcodeScanRes != null) {
                    scancode = barcodeScanRes;
                    var itemSeleccionado = buscarItem(scancode);

                    setState(() {
                      item = itemSeleccionado;
                    });
                    print('el item seleccionado es: $itemSeleccionado');

                    if (item != null) {
                      showDialog(
                        context: context,
                        builder: (BuildContext dialogContext) {
                          return AlertDialog(
                            contentPadding: EdgeInsets.all(16.0),
                            title: Text('Producto Escaneado'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Codigo: ${item['codigo']}'),
                                Text('Descripcion: ${item['descripcion']}'),
                                Text('Stock: ${item['stock']}'),
                                Text('Categoria: ${item['categoria']}'),
                                Text('CodigoFsl: ${item['codigoFsl']}'),
                                TextFormField(
                                  controller: controllerStock,
                                  decoration: InputDecoration(
                                    labelText: 'Ingrese su input',
                                  ),
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(dialogContext),
                                child: Text('Cerrar'),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  if (controllerStock.text.isNotEmpty) {
                                    item['stock'] = controllerStock.text;
                                    final itemNew =
                                        Map<String, dynamic>.from(item);
                                    final data = {
                                      '_id': currentInventory['_id'],
                                      'arrayDetalle': [itemNew]
                                    };

                                    final add =
                                        addProductoInventarioBodega(data);

                                    var a =
                                        await _service.obtenerInventarioBodega(
                                            currentInventory['_id']);

                                    final inventory = json.encode(a);

                                    final prefs =
                                        await SharedPreferences.getInstance();
                                    await prefs.setString(
                                        'currentInventory', inventory);
                                    Navigator.pop(dialogContext);
                                  }
                                },
                                child: Text('Guardar'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  }
                },
                child: Text(
                  'Escanear Codigo',
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget currentInventoryDetail(BuildContext context) {
    if (currentInventory == null) {
      return Container();
    }
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
              'Name: ${currentInventory['nombre'] ?? ""}',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          Center(
            child: Text(
              'Date: ${currentInventory['fecha'] ?? ""}',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          const SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: viewInventoryDetailButton(
                  context,
                ),
              ),
              const SizedBox(
                width: 16.0,
              ),
              Flexible(
                child: deleteButton(),
              ),
            ],
          )
        ],
      ),
    );
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
