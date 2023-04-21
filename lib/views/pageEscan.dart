// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:hungry/models/inventarios/inventario_model.dart';
// import 'package:hungry/views/widgets/appBar.dart';
// import 'package:hungry/views/widgets/button.dart';
// import 'package:hungry/views/widgets/inventoryDetail.dart';
// import 'package:hungry/views/widgets/loading.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import '../interfaces/login_interface.dart';

// class PageEscan extends StatefulWidget {
//   @override
//   _PageEscanState createState() => _PageEscanState();
// }
// class _PageEscanState extends State<PageEscan> {
//   Future<List<dynamic>> listaInventariosFuture;
//   var inventarioComp;
//   final services = ILogin();
//   final boton = ButtonP();
//   var inventarioAUsar;
//   final inventariodetalle = InventoryDetail();
//   final inventarioModel = InventarioModel();
//   final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

//   @override
//   void initState() {
//     super.initState();
//     listaInventariosFuture = services.obtenerInventarios();
//     listaInventariosFuture.then((value) {
//       setState(() {
//         inventarioComp = value[value.length - 1];
//         inventarioAUsar = _getInventario() ?? {}; // Actualizar inventarioAUsar aquí
//       });
//       if(inventarioAUsar!=null) obtenerInventario();
//     });
//     print('este el el initstate');
//   }
// void obtenerInventario() async {
//     await _getInventario().then((value) => {
//       setState(() {
//         inventarioAUsar = value ?? {}; // Actualizar inventarioAUsar aquí
//       })
//     });
//   }

//   Future<void> _setInventario(String inventario) async {
//     final SharedPreferences prefs = await _prefs;
//     prefs.setString('inventario', inventario.toString());
//   }

// dynamic _getInventario()async {
//     final SharedPreferences prefs = await _prefs;
//     final a = prefs.getString('inventario');
//     if (a != null) {
//       Map<String, dynamic> json = jsonDecode(a);
//       Map<String, dynamic> mapa = Map<String, dynamic>.from(json);
//       return mapa;
//     } else {
//       return {}; // Devolver un valor predeterminado
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBarWidget().appBar('Escanear'),
//       body: inventarioAUsar==null
//           ? FutureBuilder<List<dynamic>>(
//               future: listaInventariosFuture,
//               builder: (BuildContext context,
//                   AsyncSnapshot<List<dynamic>> snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return Center(child: Loading().loadingIndicator());
//                 }
//                 if (snapshot.hasError) {
//                   return Center(
//                     child: Text(
//                       'Error al cargar la lista de inventarios',
//                       style: TextStyle(color: Colors.red),
//                     ),
//                   );
//                 }
//                 final inventarios = snapshot.data ?? [];
//                 print('el tipo de imventarioausar es ${inventarioAUsar.runtimeType}');
//                 return Column(
//                   children: [
//                     SizedBox(height: MediaQuery.of(context).size.height * 0.05),
//                     if (inventarioAUsar?.isEmpty ?? true)
//                       Expanded(
//                         child: Center(
//                           child: InkWell(
//                             onTap: () => showInventariosDialog(
//                                 context, listaInventariosFuture),
//                             child: Container(
//                               width: double.infinity,
//                               margin: EdgeInsets.symmetric(horizontal: 16),
//                               padding: EdgeInsets.all(16),
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.black.withOpacity(0.1),
//                                     blurRadius: 10,
//                                     offset: Offset(0, 5),
//                                   ),
//                                 ],
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Icon(Icons.folder_open),
//                                   SizedBox(width: 16),
//                                   Text(
//                                     'Seleccionar inventario',
//                                     style: TextStyle(fontSize: 18),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       )
//                     else
//                       (Loading().loadingIndicator())
//                   ],
//                 );
//               },
//             )
//           : 
//     );
//   }

//   Future<void> showInventariosDialog(BuildContext context,
//       Future<List<dynamic>> listaInventariosFuture) async {
//     final listaInventarios = await listaInventariosFuture;
//     int _selectedIndex = -1;
//     Map<String, dynamic> _inventarioSeleccionado;
//     await showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('Seleccionar un inventario'),
//           content: Container(
//             width: double.maxFinite,
//             child: ListView.builder(
//               itemBuilder: (context, index) {
//                 final inventario = listaInventarios[index];
//                 return ListTile(
//                   title: Text(inventario['nombre']),
//                   onTap: () {
//                     _selectedIndex = index;
//                     _inventarioSeleccionado = inventario;
//                     inventarioAUsar = _inventarioSeleccionado;

              
//                     setState(() {
//                       _setInventario(inventario.toString());
//                     });
//                     Navigator.pop(context);
//                   },
//                 );
//               },
//               itemCount: listaInventarios.length - 1,
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

//   buscar(codigo) {
//     final data = inventarioComp['arrayDetalle'];
//     for (var element in data) {
//       if (element['codigo'] == '21052704B') {
//         return element;
//       }
//     }
//     return null; // si no se encuentra el elemento, retornar null
//   }

//   void showInventarioDetail(
//       BuildContext context, Map<String, dynamic> inventarioAUsar) {
//     final String nombre = inventarioAUsar['nombre'];
//     final String fecha = inventarioAUsar['fecha'].toString();
//     final List<Map<String, String>> arrayDetalle =
//         List<Map<String, String>>.from(inventarioAUsar['arrayDetalle']
//             .map((detalle) => Map<String, String>.from(detalle)));

//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Dialog(
//           child: Container(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   'Detalle de Inventario',
//                   style: Theme.of(context).textTheme.headline6,
//                 ),
//                 const SizedBox(height: 16),
//                 Text(
//                   'Nombre: $nombre',
//                   style: Theme.of(context).textTheme.subtitle1,
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   'Fecha: $fecha',
//                   style: Theme.of(context).textTheme.subtitle1,
//                 ),
//                 const SizedBox(height: 16),
//                 Text(
//                   'Detalle:',
//                   style: Theme.of(context).textTheme.subtitle1,
//                 ),
//                 const SizedBox(height: 8),
//                 Expanded(
//                   child: ListView.builder(
//                     shrinkWrap: true,
//                     itemCount: arrayDetalle.length,
//                     itemBuilder: (BuildContext context, int index) {
//                       final detalle = arrayDetalle[index];
//                       final codigo = detalle['codigo'].toString();
//                       final descripcion = detalle['descripcion'];
//                       final categoria = detalle['categoria'];

//                       return Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'Código: $codigo',
//                             style: Theme.of(context).textTheme.bodyText1,
//                           ),
//                           const SizedBox(height: 4),
//                           Text(
//                             'Descripción: $descripcion',
//                             style: Theme.of(context).textTheme.bodyText1,
//                           ),
//                           const SizedBox(height: 4),
//                           Text(
//                             'Categoría: $categoria',
//                             style: Theme.of(context).textTheme.bodyText1,
//                           ),
//                           const SizedBox(height: 16),
//                         ],
//                       );
//                     },
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 Align(
//                   alignment: Alignment.centerRight,
//                   child: TextButton(
//                     onPressed: () => Navigator.pop(context),
//                     child: const Text('Cerrar'),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
