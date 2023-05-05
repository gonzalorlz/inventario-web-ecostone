import 'package:flutter/material.dart';
import 'package:hungry/interfaces/login_interface.dart';
import 'package:hungry/views/screens/detallProductoPage.dart';
import 'package:hungry/views/widgets/appBar.dart';
import 'package:hungry/views/widgets/drawer_page.dart';
import 'package:hungry/views/widgets/loading.dart';
import 'package:intl/intl.dart';

class ListaInventariosPage extends StatefulWidget {
  final String argumento;
  ListaInventariosPage({this.argumento});

  @override
  _ListaInventariosPageState createState() => _ListaInventariosPageState();
}

class _ListaInventariosPageState extends State<ListaInventariosPage> {
  TextEditingController searchInputController = TextEditingController();
  List<dynamic> informacion = [];
  List<dynamic> filteredList = [];
  var title;
  Map<String, dynamic> selectedInventario;
  bool loadingList = true;

  @override
  void initState() {
    super.initState();
    if (widget.argumento == 'bodega') {
      title = 'Inventarios BODEGA';
      ILogin().obtenerInventariosBodega().then((data) {
        setState(() {
          informacion = data;
          filteredList = informacion;
        });
      });
    } else if (widget.argumento == 'sistema') {
      title = 'Inventarios SISTEMA';
      ILogin().obtenerInventarios().then((data) {
        setState(() {
          informacion = data;
          filteredList = informacion;
        });
      });
    }

    searchInputController.addListener(() {
      filterResults(searchInputController.text);
    });
  }

  @override
  void dispose() {
    searchInputController.dispose();
    super.dispose();
  }

  Future filterResults(String query) async {
    if (query.isEmpty) {
      setState(() {
        filteredList = List.from(informacion);
      });
    } else {
      final List results = [];

      informacion.forEach((inventario) {
        final String name = '${inventario['nombre']}';
        final String category = '${inventario['categoria']}';
        if (name.toLowerCase().contains(query.toLowerCase()) ||
            category.toLowerCase().contains(query.toLowerCase())) {
          results.add(inventario);
        }
      });

      setState(() {
        filteredList = results;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarWidget().appBar(title),
      drawer: MyDrawerWidget(),
      body: selectedInventario != null
          ? ListView.builder(
              itemCount: selectedInventario['arrayDetalle'].length,
              itemBuilder: (context, index) {
                final detail = selectedInventario['arrayDetalle'][index];
                return GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Descripcion: ${detail['descripcion'] ?? ''}',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10.0),
                              Text(
                                'Codigo Ecostone: ${detail['codigo'] ?? ''}',
                                style: TextStyle(
                                  fontSize: 20.0,
                                ),
                              ),
                              SizedBox(height: 10.0),
                              Text(
                                'Codigo FSL: ${detail['codigoFsl'] ?? ''}',
                                style: TextStyle(fontSize: 16.0),
                              ),
                              SizedBox(height: 10.0),
                              Text(
                                'Categoria: ${detail['categoria'] ?? ''}',
                                style: TextStyle(fontSize: 16.0),
                              ),
                              SizedBox(height: 10.0),
                              Text(
                                'Stock: ${detail['stock'] ?? ''}',
                                style: TextStyle(fontSize: 16.0),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          : Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    title.toUpperCase(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: searchInputController,
                    decoration: InputDecoration(
                      hintText: 'Buscar inventario',
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        final inventario = filteredList[index];
                        final String fechaString = inventario['fecha'];
                        final DateTime fecha =
                            DateFormat('yyyy-MM-dd').parse(fechaString);

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedInventario = inventario;
                            });
                          },
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 8.0),
                                padding: EdgeInsets.all(16.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey[300],
                                      blurRadius: 10.0,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      flex: 3,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Nombre ', // added default name value
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18.0,
                                              color: Colors.black,
                                            ),
                                          ),
                                          SizedBox(height: 4.0),
                                          Text(
                                            '${inventario['nombre'] ?? 'Nombre no especificado'}', // added date text
                                            style: TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Flexible(
                                      flex: 2,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Fecha ',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18.0,
                                              color: Colors.black,
                                            ),
                                          ),
                                          SizedBox(height: 4.0),
                                          Text(
                                            '${DateFormat('dd/MM/yyyy').format(fecha)}', // added time text
                                            style: TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(thickness: 1.0),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back),
                  ),
                ],
              ),
            ),
    );
  }

  void handleDetails(BuildContext context, dynamic inventario) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetalleProductoPage(inventario),
      ),
    );
  }
}
