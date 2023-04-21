// import 'package:flutter/material.dart';
// import 'package:hungry/interfaces/login_interface.dart';
// import 'package:hungry/views/utils/AppColor.dart';
// import 'package:hungry/views/widgets/custom_text_field.dart';

// import '../../../models/inventarios/crearInventario_model.dart';
// import '../../screens/escanear_page.dart';

// class NuevoInventarioModal extends StatefulWidget {
//   @override
//   State<NuevoInventarioModal> createState() => _NuevoInventarioModalState();
// }

// class _NuevoInventarioModalState extends State<NuevoInventarioModal> {
//   final TextEditingController _nombreController = TextEditingController();
//   final _service = ILogin();

//   @override
//   Widget build(BuildContext context) {
//     // final code = BarCodeScan();

//     return Container(
//       width: MediaQuery.of(context).size.width,
//       height: MediaQuery.of(context).size.height * 85 / 100,
//       padding: EdgeInsets.only(left: 16, right: 16, bottom: 32, top: 16),
//       decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(20), topRight: Radius.circular(20))),
//       child: ListView(
//         shrinkWrap: true,
//         padding:
//             EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
//         physics: BouncingScrollPhysics(),
//         children: [
//           Align(
//             alignment: Alignment.center,
//             child: Container(
//               width: MediaQuery.of(context).size.width * 35 / 100,
//               margin: EdgeInsets.only(bottom: 20),
//               height: 6,
//               decoration: BoxDecoration(
//                   color: Colors.grey[300],
//                   borderRadius: BorderRadius.circular(20)),
//             ),
//           ),
//           // header
//           Container(
//             margin: EdgeInsets.only(bottom: 24),
//             child: Text(
//               'Nuevo Inventario',
//               style: TextStyle(
//                   color: Colors.black,
//                   fontSize: 22,
//                   fontWeight: FontWeight.w700,
//                   fontFamily: 'inter'),
//             ),
//           ),
//           CustomTextField(
//             title: 'Nombre:',
//             hint: 'nombre inventario',
//             controller: _nombreController,
//           ),
//           Container(
//             margin: EdgeInsets.only(top: 32, bottom: 6),
//             width: MediaQuery.of(context).size.width,
//             height: 60,
//             child: ElevatedButton(
//               onPressed: () async {
//                 final req = CrearInventarioModel();
//                 req.nombre = _nombreController.text;
//                 final r = await _service.crearInventario(req);
//                 if (r == null) {
//                   _showMyDialog('Error', 'Inventario ya existe',
//                       'pruebe con otro nombre', false);
//                 } else {
//                   _showMyDialog('Correcto', 'inventario creado', '', true);
//                 }
//               },
//               child: Text('Guardar',
//                   style: TextStyle(
//                       color: AppColor.secondary,
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                       fontFamily: 'inter')),
//               style: ElevatedButton.styleFrom(
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10)),
//                 backgroundColor: AppColor.primarySoft,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> _showMyDialog(
//       String titulo, String tituloTexto, String texto, bool confirm) async {
//     return showDialog<void>(
//       context: context,
//       barrierDismissible: false, // user must tap button!
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text(titulo),
//           content: SingleChildScrollView(
//             child: ListBody(
//               children: <Widget>[
//                 Text(tituloTexto),
//                 Text(texto),
//               ],
//             ),
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: const Text('OK'),
//               onPressed: () {
//                 if (confirm) {
//                   Navigator.of(context).pop();
//                   Navigator.of(context).pushReplacement(MaterialPageRoute(
//                       builder: (context) => EscanearproductoPage()));
//                 } else {
//                   Navigator.of(context).pop();
//                 }
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
