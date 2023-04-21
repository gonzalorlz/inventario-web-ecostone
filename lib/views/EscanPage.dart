// import 'package:flutter/material.dart';
// import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
// import 'package:hungry/interfaces/login_interface.dart';
// import 'package:hungry/views/pageEscan.dart';
// import 'package:hungry/views/widgets/appBar.dart';
// import 'package:hungry/views/widgets/loading.dart';

// class BarcodeScannerPage extends StatefulWidget {
//   @override
//   _BarcodeScannerPageState createState() => _BarcodeScannerPageState();
// }

// class _BarcodeScannerPageState extends State<BarcodeScannerPage> {
//   String _barcode = 'Esperando...';
//   final services = ILogin();
//   var _element;
//   bool mostrarInterfazOriginal = true;
//   var resultadoBusqueda;
//   List<dynamic> listaInven;
//   Future<List<dynamic>> listaInventariosFuture;
//   var inventarioComp;
//   Future<void> _scanBarcode() async {
//     final barcode = await FlutterBarcodeScanner.scanBarcode(
//       '#FF0000',
//       'Cancelar',
//       true,
//       ScanMode.BARCODE,
//     );
//     final service = ILogin();
//     setState(() {
//       _barcode = barcode;
//     });
//     buscar(_barcode);
//     return _barcode.toString();
//   }

//   var producto;
//   var itemUsar;
//   @override
//   void initState() {
//     super.initState();
//     listaInventariosFuture = services.obtenerInventarios();
//     listaInventariosFuture
//         .then((value) => {inventarioComp = value[value.length - 1]});
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBarWidget().appBar('Escanear Producto'),
//       body: FutureBuilder(
//         future: listaInventariosFuture,
//         builder: (context, snapshot) {
//           return detalle(context, producto);
//         },
//       ),
//     );
//   }

//   buscar(codigo) {
//     final data = inventarioComp['arrayDetalle'];
//     for (var element in data) {
//       if (element['codigo'] == '21052704B') {
//         return element;
//       }
//     }
//     return null; // si no se encuentra el elemento, retornar null
//   }

//   @override
//   Widget detalle(context, producto) {
//     bool mostrarInterfazOriginal = true;
//     var resultadoBusqueda;
//     var element;
//     return FutureBuilder(
//       future: listaInventariosFuture,
//       builder: (context, snapshot) {
//         if (snapshot.hasError) {
//           return Text('Error al cargar los datos');
//         } else if (snapshot.hasData) {
//           listaInven = snapshot.data[snapshot.data.length - 1]['arrayDetalle'];
//           if (mostrarInterfazOriginal) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   if (itemUsar != null) item(itemUsar, 'Nombre', 'nombre'),
//                   if (itemUsar != null) item(itemUsar, 'Fecha', 'fecha'),
//                   if (itemUsar != null) item(itemUsar, 'id ', '_id'),
//                   SizedBox(height: 32),
//                   if (resultadoBusqueda != null)
//                     Container(
//                       child: Text(element['codigo']),
//                     ),
//                   ElevatedButton(
//                     onPressed: () async {
//                       resultadoBusqueda = await buscar('codigo');
//                       if (resultadoBusqueda != null) {
//                         setState(() {
//                           resultadoBusqueda = resultadoBusqueda;
//                         });
//                       } else {
//                         showDialog(
//                           context: context,
//                           builder: (BuildContext context) {
//                             return AlertDialog(
//                               title: Text('No encontrado'),
//                               content: Text(
//                                   'No se ha encontrado ningún elemento con ese código'),
//                               actions: [
//                                 TextButton(
//                                   onPressed: () {
//                                     Navigator.of(context).pop();
//                                   },
//                                   child: Text('OK'),
//                                 ),
//                               ],
//                             );
//                           },
//                         );
//                       }
//                     },
//                     child: Text('Escanear'),
//                   ),
//                   if (resultadoBusqueda != null) Text(resultadoBusqueda),
//                   ElevatedButton(
//                     onPressed: () async {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => PageEscan()),
//                       );
//                       // showListDialog(context, listaInventariosFuture);
//                     },
//                     child: Text('Selecciona un inventario'),
//                   ),
//                   ElevatedButton(
//                     onPressed: () async {
//                       // Aquí deberías agregar el código para guardar los datos
//                       mostrarInterfazOriginal = false;
//                       // Luego, mostrar el resultado después de guardar los datos
//                       // por ejemplo, con un Text o un AlertDialog
//                       if (resultadoBusqueda != null) {
//                         showDialog(
//                           context: context,
//                           builder: (BuildContext context) {
//                             return AlertDialog(
//                               title: Text('Datos guardados'),
//                               content: Text(
//                                   'Los datos se han guardado correctamente.\nResultado de la búsqueda: $resultadoBusqueda'),
//                               actions: [
//                                 TextButton(
//                                   onPressed: () {
//                                     Navigator.of(context).pop();
//                                   },
//                                   child: Text('OK'),
//                                 ),
//                               ],
//                             );
//                           },
//                         );
//                       } else {
//                         showDialog(
//                           context: context,
//                           builder: (BuildContext context) {
//                             return AlertDialog(
//                               title: Text('Datos guardados'),
//                               content: Text(
//                                   'Los datos se han guardado correctamente'),
//                               actions: [
//                                 TextButton(
//                                   onPressed: () {
//                                     Navigator.of(context).pop();
//                                   },
//                                   child: Text('OK'),
//                                 ),
//                               ],
//                             );
//                           },
//                         );
//                       }
//                     },
//                     child: Text('Guardar'),
//                   ),
//                 ],
//               ),
//             );
//           } else {
//             return Center(
//               child: Text('Los datos se han guardado correctamente'),
//             );
//           }
//         } else {
//           return Center(
//             child: Loading().loadingIndicator(),
//           );
//         }
//       },
//     );
//   }

//   Future<void> showListDialog(
//       BuildContext context, Future<List<dynamic>> futureList) async {
//     List<dynamic> list = await futureList;
//     int selectedIndex = -1;

//     await showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Selecciona un elemento'),
//           content: Container(
//             width: double.maxFinite,
//             child: ListView.builder(
//               shrinkWrap: true,
//               itemCount: list.length,
//               itemBuilder: (BuildContext context, int index) {
//                 final item = list[index];
//                 final name = item['nombre'];
//                 final date = item['fecha'];

//                 return Card(
//                   elevation: 2,
//                   child: ListTile(
//                     title: Text(name),
//                     subtitle: Text(date),
//                     selected: index == selectedIndex,
//                     onTap: () {
//                       setState(() {
//                         selectedIndex = index;
//                         itemUsar = item;
//                       });
//                       Navigator.pop(context);
//                     },
//                   ),
//                 );
//               },
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget item(dynamic item, String title, String itemName) {
//     return Card(
//       elevation: 2,
//       child: Padding(
//         padding: EdgeInsets.all(16),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Expanded(
//               flex: 1,
//               child: Text(
//                 title,
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 16,
//                 ),
//               ),
//             ),
//             SizedBox(width: 16),
//             Expanded(
//               flex: 2,
//               child: Text(
//                 item[itemName].toString(),
//                 style: TextStyle(
//                   fontSize: 16,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
