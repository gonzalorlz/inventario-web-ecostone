import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hungry/models/helper/recipe_helper.dart';
import 'package:hungry/views/utils/AppColor.dart';

import '../../interfaces/login_interface.dart';
import '../../models/core/recipe.dart';

class DetalleProductoPage extends StatefulWidget {
  final dynamic inventario;

  DetalleProductoPage(this.inventario);

  @override
  _DetalleProductoPageState createState() => _DetalleProductoPageState();
}

class _DetalleProductoPageState extends State<DetalleProductoPage> {
  TextEditingController searchInputController = TextEditingController();
  final List<Recipe> searchResult = RecipeHelper.sarchResultRecipe;
  final services = ILogin();
  List<dynamic> filteredDetalle;

  @override
  void initState() {
    super.initState();
    filteredDetalle = widget.inventario['arrayDetalle'];
  }

  void filterDetalle(String query) {
    if (query.isNotEmpty) {
      setState(() {
        filteredDetalle = widget.inventario['arrayDetalle'].where((detalle) {
          final codigo = detalle.toString().toLowerCase();
          return codigo.contains(query.toLowerCase());
        }).toList();
      });
    } else {
      setState(() {
        filteredDetalle = widget.inventario['arrayDetalle'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primary,
        elevation: 0,
        centerTitle: true,
        title: Text(
          '\nDetalle productos',
          style: TextStyle(
            fontFamily: 'inter',
            fontWeight: FontWeight.w400,
            fontSize: 16,
          ),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            TextField(
              controller: searchInputController,
              decoration: InputDecoration(
                labelText: 'Buscar',
              ),
              onChanged: filterDetalle,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredDetalle.length,
                // ignore: missing_return
                itemBuilder: (context, index) {
                  final detalle = filteredDetalle[index];
              

                  if (detalle['categoria'] != null)
                    return Container(
                      width: MediaQuery.of(context).size.width * 0.75,
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                detalle['descripcion'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Stock: ${detalle['stock']}',
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Categoría: ${detalle['categoria'].toString()}',
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Código: ${detalle['codigo']}',
                              ),
                            ],
                          ),
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
  }
}
