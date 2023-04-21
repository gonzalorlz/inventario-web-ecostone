import 'package:flutter/material.dart';
import 'package:hungry/interfaces/login_interface.dart';
import 'package:hungry/views/widgets/appBar.dart';
import 'package:hungry/views/widgets/drawer_page.dart';

class CompararPage extends StatefulWidget {
  @override
  _CompararPageState createState() => _CompararPageState();
}

class _CompararPageState extends State<CompararPage> {
  Map<String, dynamic> selectedData = {};
  Map<String, dynamic> selectedDataFromInventario;
  Map<String, dynamic> selectedDataFromBodega;
  List<Map<String, dynamic>> dataInventario = [];
  List<Map<String, dynamic>> dataBodega = [];
  final service = ILogin();

  Future<void> _showDialog(
      List<Map<String, dynamic>> dataList,
      BuildContext context,
      Function(Map<String, dynamic>) selectedDataCallback) async {
    selectedData = {};
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text('Selecciona un inventario'),
          children: dataList
              .map(
                (data) => SimpleDialogOption(
                  onPressed: () {
                    setState(() {
                      selectedData = data;
                      Navigator.pop(context);
                      selectedDataCallback(selectedData);
                    });
                  },
                  child: Text(data['nombre'] ?? ""), // Add null check here
                ),
              )
              .toList(),
        );
      },
    );
  }

  void _setSelectedDataFromInventario(Map<String, dynamic> data) {
    setState(() {
      selectedDataFromInventario = data;
    });
  }

  void _setSelectedDataFromBodega(Map<String, dynamic> data) {
    setState(() {
      selectedDataFromBodega = data;
    });
  }

  Widget build(BuildContext context) {
    List<dynamic> arrayDetalle = _getDifferenceArray();

    return Scaffold(
      appBar: AppBarWidget().appBar('Comparar'),
      drawer: MyDrawerWidget(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: _buildInventoryButton(),
              ),
              SizedBox(width: 24),
              Expanded(
                child: _buildWarehouseButton(),
              ),
            ],
          ),
          SizedBox(height: 24),
          if (selectedDataFromInventario != null &&
              selectedDataFromBodega != null) ...[
            Expanded(
              child: _buildSelectedInventoryCard(),
            ),
            SizedBox(height: 10),
            Expanded(
              child: _buildSelectedWarehouseCard(),
            ),
            SizedBox(height: 10),
            Expanded(
              child: _buildDifferenceCard(context, arrayDetalle),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDifferenceCard(BuildContext context, List arrayDetalle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Diferencias :",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16),
        Expanded(
          child: GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    contentPadding: EdgeInsets.all(0.0),
                    content: Container(
                      width: double.maxFinite,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  "Buscar",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                icon: Icon(Icons.close),
                              ),
                            ],
                          ),
                          TextField(
                            decoration: InputDecoration(
                              hintText: "Buscar por descripcion",
                              suffixIcon: Icon(Icons.search),
                              border: InputBorder.none,
                            ),
                            onChanged: (value) {
                              // Tu código para filtrar los elementos
                            },
                          ),
                          Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: arrayDetalle.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${arrayDetalle[index]['descripcion']}",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          "${arrayDetalle[index]['categoria']}",
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          "${arrayDetalle[index]['codigo']}",
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          "${arrayDetalle[index]['codigoFsl']}",
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "ver lista de diferencias ",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Icon(Icons.list),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Total: ${arrayDetalle.length}",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 8),
            Icon(
              Icons.numbers,
              size: 16,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInventoryButton() {
    return ElevatedButton(
      onPressed: () async {
        await setDataInventario();
        if (dataInventario.isNotEmpty) {
          await _showDialog(
              dataInventario, context, _setSelectedDataFromInventario);
        }
      },
      child: Text(
        "Seleccionar inventario",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: ButtonStyle(
        padding: MaterialStateProperty.all(
          EdgeInsets.symmetric(
            horizontal: 32,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildWarehouseButton() {
    return ElevatedButton(
      onPressed: () async {
        await setDataBodega();
        if (dataBodega.isNotEmpty) {
          await _showDialog(dataBodega, context, _setSelectedDataFromBodega);
          setState(() {});
        }
      },
      child: Text(
        "Seleccionar bodega",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: ButtonStyle(
        padding: MaterialStateProperty.all(
          EdgeInsets.symmetric(
            horizontal: 32,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedInventoryCard() {
    if (selectedDataFromBodega == null) return Container();

    return Flexible(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Item seleccionado en Inventario:",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '${selectedDataFromBodega['nombre'] ?? ''}',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedWarehouseCard() {
    if (selectedDataFromInventario == null) return Container();

    return Flexible(
      fit: FlexFit.tight,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Item seleccionado en Inventario:",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '${selectedDataFromInventario['nombre'] ?? ''}',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<dynamic> _getDifferenceArray() {
    List<dynamic> arrayDetalle = [];
    if (selectedDataFromInventario != null && selectedDataFromBodega != null) {
      Set<dynamic> setInventario =
          Set.from(selectedDataFromInventario['arrayDetalle']);
      Set<dynamic> setBodega = Set.from(selectedDataFromBodega['arrayDetalle']);
      arrayDetalle = setInventario.difference(setBodega).toList();
    }
    return arrayDetalle;
  }

  Future setDataInventario() async {
    final data = await obtenerInventarios();
    setState(() {
      dataInventario = data;
    });
  }

  Future<List<Map<String, dynamic>>> obtenerInventarios() async {
    final List data = await service.obtenerInventarios();
    List<Map<String, dynamic>> typedList =
        data.map((i) => i as Map<String, dynamic>).toList();
    return typedList;
  }

  Future<List<Map<String, dynamic>>> obtenerInventariosBodega() async {
    final List data = await service.obtenerInventariosBodega();
    List<Map<String, dynamic>> typedList =
        data.map((i) => i as Map<String, dynamic>).toList();
    return typedList;
  }

  Future setDataBodega() async {
    final data = await obtenerInventariosBodega();
    setState(() {
      dataBodega = data;
    });
  }
}
