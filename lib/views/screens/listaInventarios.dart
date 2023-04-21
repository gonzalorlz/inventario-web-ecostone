import 'package:flutter/material.dart';
import 'package:hungry/interfaces/login_interface.dart';
import 'package:hungry/models/core/recipe.dart';
import 'package:hungry/models/helper/recipe_helper.dart';
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
  final List<Recipe> searchResult = RecipeHelper.sarchResultRecipe;
  Future<List<dynamic>> listaInventarios;
  final services = ILogin();
  var informacion;
  var title;

  @override
  void initState() {
    super.initState();
    if (widget.argumento == 'bodega') {
      title = 'Inventarios BODEGA';
      listaInventarios = services.obtenerInventariosBodega();
    } else if (widget.argumento == 'sistema') {
      title = 'Inventarios SISTEMA';
      listaInventarios = services.obtenerInventarios();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarWidget().appBar(title),
      drawer: MyDrawerWidget(),
      body: FutureBuilder(
        future: listaInventarios,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Loading().loadingIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('${snapshot.error}'),
            );
          } else if (snapshot.hasData && snapshot.data != null) {
            final inventarios = snapshot.data;
            return Container(
              padding: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.lightBlue[200],
                    Colors.lightGreen[200],
                  ],
                ),
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[300],
                    blurRadius: 10.0,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 20),
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
                      itemCount: inventarios.length,
                      itemBuilder: (context, index) {
                        final inventario = inventarios[index];
                        final String fechaString = inventario['fecha'];
                        final DateTime fecha =
                            DateFormat('yyyy-MM-dd').parse(fechaString);
                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 8.0),
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.6,
                                        child: Text(
                                          '${inventario['nombre'] != null ? inventario['nombre'] : ''}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.0,
                                          ),
                                        ),
                                      ),
                                      PopupMenuButton(
                                        itemBuilder: (context) => [
                                          PopupMenuItem(
                                            child: Text('Eliminar'),
                                            value: 'eliminar',
                                          ),
                                          PopupMenuItem(
                                            child: Text('Editar'),
                                            value: 'editar',
                                          ),
                                          PopupMenuItem(
                                            child: Text('Detalles'),
                                            value: 'detalles',
                                          ),
                                        ],
                                        onSelected: (value) {
                                          if (value == 'eliminar')
                                            handleDelete(inventario);
                                          else if (value == 'editar')
                                            handleEdit(inventario);
                                          else if (value == 'detalles')
                                            handleDetails(context, inventario);
                                        },
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Text('$fecha'),
                                ],
                              ),
                            ),
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
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  void handleDelete(dynamic inventario) {
    // TODO: implementar la logica de eliminar inventario
  }

  void handleEdit(dynamic inventario) {
    // TODO: implementar la logica de editar inventario
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
