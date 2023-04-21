import 'package:flutter/material.dart';
import 'package:hungry/views/widgets/appBar.dart';

class CompPage extends StatelessWidget {
  final List<dynamic> dataInventario;
  final List<dynamic> dataBodega;

  CompPage({this.dataInventario, this.dataBodega});

  @override
  Widget build(BuildContext context) {
    // Obtener los conjuntos de los elementos en los "arrayDetalle" de cada lista
    final setInventario = Set.from(dataInventario.expand(
        (element) => element['arrayDetalle'].map((e) => e['descripcion'])));
    final setBodega = Set.from(dataBodega.expand(
        (element) => element['arrayDetalle'].map((e) => e['descripcion'])));

    // Encontrar elementos en inventario que no están en bodega
    final inInventarioNotInBodega = setInventario.difference(setBodega);

    // Encontrar elementos en bodega que no están en inventario
    final inBodegaNotInInventario = setBodega.difference(setInventario);

    // Obtener el total de diferencias
    final totalDifferences =
        inInventarioNotInBodega.length + inBodegaNotInInventario.length;

    return Scaffold(
        appBar: AppBarWidget().appBar('Resultado '),
        body: Stack(
          children: [
            SingleChildScrollView(
                child: Padding(
              padding: const EdgeInsets.all(16.0),
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (totalDifferences > 0)
                        Card(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Elementos en inventario no presentes en bodega:',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: inInventarioNotInBodega
                                      .map((item) => Text(item.toString()))
                                      .toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (totalDifferences > 0)
                        Card(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Elementos en bodega no presentes en inventario:',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: inBodegaNotInInventario
                                      .map((item) => Text(item.toString()))
                                      .toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (totalDifferences == 0)
                        Text(
                          'No se encontraron diferencias entre los inventarios.',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    SizedBox(
                      height: 200,
                    ),
                    Card(
                        child: Container(
                            height: 200,
                            child: Center(
                              child: Text(
                                'Total de diferencias: $totalDifferences',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )))
                  ],
                )
              ]),
            ))
          ],
        ));
  }
}
