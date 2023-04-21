// import 'package:flutter/material.dart';
// import 'package:hungry/views/utils/AppColor.dart';

// class RegisterModal extends StatefulWidget {
//   @override
//   State<RegisterModal> createState() => _RegisterModalState();
// }

// class _RegisterModalState extends State<RegisterModal> {
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
//               'Ingresar',
//               style: TextStyle(
//                   color: Colors.black,
//                   fontSize: 22,
//                   fontWeight: FontWeight.w700,
//                   fontFamily: 'inter'),
//             ),
//           ),
//           // Form
//           // CustomTextField(title: 'Codigo', hint: 'youremail@email.com'),
//           // CustomTextField(
//           //     title: 'Full Name',
//           //     hint: 'Your Full Name',
//           //     margin: EdgeInsets.only(top: 16)),
//           // CustomTextField(
//           //     title: 'Password',
//           //     hint: '**********',
//           //     obsecureText: true,
//           //     margin: EdgeInsets.only(top: 16)),
//           // CustomTextField(
//           //     title: 'Retype Password',
//           //     hint: '**********',
//           //     obsecureText: true,
//           //     margin: EdgeInsets.only(top: 16)),
//           // Register Button
//           Container(
//             margin: EdgeInsets.only(top: 32, bottom: 6),
//             width: MediaQuery.of(context).size.width,
//             height: 60,
//             child: ElevatedButton(
//               onPressed: () async {
//                 // Navigator.of(context).pop();
//                 // Navigator.of(context).pushReplacement(MaterialPageRoute(
//                 //     builder: (context) => NuevoInventarioModal()));
//                 showModalBottomSheet(
//                   context: context,
//                   backgroundColor: Colors.white,
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.only(
//                           topLeft: Radius.circular(20),
//                           topRight: Radius.circular(20))),
//                   isScrollControlled: true,
//                   builder: (context) {
//                     return NuevoInventarioModal();
//                   },
//                 );
//               },
//               child: Text('Nuevo',
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
//           Container(
//             margin: EdgeInsets.only(top: 32, bottom: 6),
//             width: MediaQuery.of(context).size.width,
//             height: 60,
//             child: ElevatedButton(
//               onPressed: () async {
//                 // Navigator.of(context).pop();
//                 // Navigator.of(context).pushReplacement(MaterialPageRoute(
//                 //     builder: (context) => PageSwitcher()));
//               },
//               child: Text('Seguir anterior',
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
//           // Login textbutton
//           // TextButton(
//           //   onPressed: () {
//           //     Navigator.of(context).pop();
//           //     showModalBottomSheet(
//           //       context: context,
//           //       backgroundColor: Colors.white,
//           //       shape: RoundedRectangleBorder(
//           //           borderRadius: BorderRadius.only(
//           //               topLeft: Radius.circular(20),
//           //               topRight: Radius.circular(20))),
//           //       isScrollControlled: true,
//           //       builder: (context) {
//           //         return LoginModal();
//           //       },
//           //     );
//           //   },
//           //   style: TextButton.styleFrom(
//           //     foregroundColor: Colors.white,
//           //   ),
//           //   child: RichText(
//           //     text: TextSpan(
//           //       text: 'Have an account? ',
//           //       style: TextStyle(color: Colors.grey),
//           //       children: [
//           //         TextSpan(
//           //             style: TextStyle(
//           //               color: AppColor.primary,
//           //               fontWeight: FontWeight.w700,
//           //               fontFamily: 'inter',
//           //             ),
//           //             text: 'Log in')
//           //       ],
//           //     ),
//           //   ),
//           // ),
//         ],
//       ),
//     );
//   }
// }
