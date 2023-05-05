import 'package:flutter/material.dart';
import 'package:hungry/interfaces/login_interface.dart';
import 'package:hungry/views/widgets/appBar.dart';
import 'package:hungry/views/widgets/loading.dart';

class CompararPage extends StatefulWidget {
  @override
  _CompararPageState createState() => _CompararPageState();
}

class _CompararPageState extends State<CompararPage> {
  final ILogin _loginService = ILogin();
  List<Map<String, dynamic>> _inventoriesBodega = [];
  List<Map<String, dynamic>> _inventories = [];
  bool _isLoading = false;
  String r = '';
  String _r = '';
  Future<List<Map<String, dynamic>>> _getInventarioSistema() async {
    List<dynamic> data = await _loginService.obtenerInventarios();
    if (data != null)
      return List<Map<String, dynamic>>.from(data);
    else
      return null;
  }

  Future<List<Map<String, dynamic>>> _getInventariosBodega() async {
    List<dynamic> data = await _loginService.obtenerInventariosBodega();
    if (data != null)
      return List<Map<String, dynamic>>.from(data);
    else
      return null;
  }

  @override
  void initState() {
    super.initState();
  }

  bool _showTable() {
    if (_selectedInventories.length == 2 &&
        _selectedInventories[0]['arrayDetalle'] != null &&
        _selectedInventories[1]['arrayDetalle'] != null) {
      return true;
    } else {
      return false;
    }
  }

  List<Map<String, dynamic>> _selectedInventories = [];

  _showInventoryDialog(List<Map<String, dynamic>> inventories) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Inventories'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: inventories.map((inventory) {
                var nombre = inventory['nombre'] ?? 'No Name';
                var fecha = inventory['fecha'] ?? 'No Date';
                return ListTile(
                  title: Text(nombre),
                  subtitle: Text(fecha),
                  onTap: () {
                    setState(() {
                      _selectedInventories.add(inventory);
                    });
                    Navigator.of(context).pop();
                  },
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget().appBar('Comparar'),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    _isLoading = true;
                  });
                  var data = await _getInventarioSistema();
                  setState(() {
                    _inventories = data;
                    _isLoading = false;
                  });
                  _showInventoryDialog(List<Map<String, dynamic>>.from(data));
                },
                child: Text(
                  'Sistema',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  padding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                ),
              ),
              SizedBox(width: 20.0),
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    _isLoading = true;
                  });
                  var data = await _getInventariosBodega();
                  setState(() {
                    _inventoriesBodega = data;
                    _isLoading = false;
                  });
                  _showInventoryDialog(List<Map<String, dynamic>>.from(data));
                },
                child: Text(
                  'Bodega',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  padding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.0),
          if (_isLoading)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Loading().loadingIndicator(),
                    SizedBox(height: 10.0),
                    Text(
                      'Cargando...',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (_showTable())
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: ListViewBuilder(),
              ),
            )
        ],
      ),
    );
  }

// ignore: non_constant_identifier_names
  ListViewBuilder() {
    List filteredInventories = List.from(_selectedInventories);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          onChanged: (valor) {
            _r = valor;
            filteredInventories = _selectedInventories.where((inventory) {
              final nombre = inventory['nombre']?.toLowerCase() ?? '';
              final fecha = inventory['fecha']?.toLowerCase() ?? '';
              final detalle = inventory['arrayDetalle']
                      ?.map((item) => item.values.join(' '))
                      ?.join(' ')
                      ?.toLowerCase() ??
                  '';
              final invDetalle = inventory['detalle']?.toLowerCase() ?? '';

              final query = valor.toLowerCase();

              return nombre.contains(query) ||
                  fecha.contains(query) ||
                  detalle.contains(query) ||
                  invDetalle.contains(query);
            }).toList();

            setState(() {});
          },
          decoration: InputDecoration(
            hintText: 'Search...',
            border: OutlineInputBorder(),
          ),
        ),
        Divider(),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: filteredInventories.length,
            itemBuilder: (BuildContext context, int index) {
              final inventory = filteredInventories[index];
              final nombre = inventory['nombre'] ?? 'No Name';
              final fecha = inventory['fecha'] ?? 'No Date';
              final detalle = inventory['arrayDetalle'] ?? [];

              // Get Bodega Detalle
              final bodegaDetalle = _inventoriesBodega
                  .expand((inv) => inv['arrayDetalle'] as List<dynamic>)
                  .toList()
                  .cast<Map<String, dynamic>>();

              List<dynamic> filteredDetalle = detalle.where((item) {
                // ignore: unnecessary_cast
                final stockItem = bodegaDetalle.firstWhere(
                  (bodegaItem) => bodegaItem['codigo'] == item['codigo'],
                  orElse: () => <String, dynamic>{},
                ) as Map<String, dynamic>;
                final stock = convertirCadenaANumeroEntero(
                    stockItem['stock'] as String ?? '0');
                final difference =
                    convertirCadenaANumeroEntero(item['stock']) - stock;

                final detalleItem =
                    item['descripcion']?.toString()?.toLowerCase() ?? '';
                final codigoItem =
                    item['codigo']?.toString()?.toLowerCase() ?? '';
                final codeFsl =
                    item['codigoFsl']?.toString()?.toLowerCase() ?? '';

                final query = _r.toLowerCase();

                return detalleItem.contains(query) ||
                    codigoItem.contains(query) ||
                    codeFsl.contains(query);
              }).toList();

              return FutureBuilder(
                future:
                    Future.delayed(Duration(milliseconds: 500), () => 'Data'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: Loading().loadingIndicator(),
                    );
                  } else {
                    return responsiveScrollView(filteredDetalle, bodegaDetalle);
                  }
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget responsiveScrollView(List detalle, List bodegaDetalle) {
    return Column(
      children: detalle.map((item) {
        final stockItem = bodegaDetalle.firstWhere(
          (bodegaItem) => bodegaItem['codigo'] == item['codigo'],
          orElse: () => <String, dynamic>{},
        ) as Map<String, dynamic>;
        final stock =
            convertirCadenaANumeroEntero(stockItem['stock'] as String ?? '0');
        final difference = convertirCadenaANumeroEntero(item['stock']) - stock;

        return Card(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.code,
                      size: 20,
                      color: Colors.grey,
                    ),
                    SizedBox(width: 5),
                    Text(
                      'Codigo : ${item['codigo'].toString()}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Icon(
                      Icons.description,
                      size: 20,
                      color: Colors.grey,
                    ),
                    SizedBox(width: 5),
                    Text(
                      'Descripcion: ${item['descripcion'].toString()}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Icon(
                      Icons.credit_card,
                      size: 20,
                      color: Colors.grey,
                    ),
                    SizedBox(width: 5),
                    Text(
                      'Código FSL: ${item['codigoFsl'].toString()}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Icon(
                      Icons.storage,
                      size: 20,
                      color: Colors.grey,
                    ),
                    SizedBox(width: 5),
                    Text(
                      'Stock Bodega: ${stock.toString()}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Icon(
                      Icons.inventory,
                      size: 20,
                      color: Colors.grey,
                    ),
                    SizedBox(width: 5),
                    Text(
                      'Stock Sistema : ${(item['stock'] ?? "").toString()}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Icon(
                      Icons.compare_arrows,
                      size: 20,
                      color: difference > 0 ? Colors.red : Colors.green,
                    ),
                    SizedBox(width: 5),
                    Text(
                      'Diferencia: ${difference.toString()}',
                      style: TextStyle(
                        fontSize: 14,
                        color: difference > 0 ? Colors.red : Colors.green,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  int convertirCadenaANumeroEntero(String numeroFormateado) {
    String numeroSinFormato =
        numeroFormateado.replaceAll(RegExp('[^0-9\\-\\,]'), '');
    int indexComa = numeroSinFormato.lastIndexOf(",");
    if (indexComa != -1) {
      numeroSinFormato = numeroSinFormato.substring(0, indexComa);
    }
    numeroSinFormato = numeroSinFormato.replaceAll(",", "").replaceAll(".", "");
    int numeroEntero = int.parse(numeroSinFormato);
    return numeroEntero;
  }
}
