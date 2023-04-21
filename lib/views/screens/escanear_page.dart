import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:hungry/views/utils/AppColor.dart';
import 'package:hungry/views/widgets/user_info_tile.dart';

class EscanearproductoPage extends StatefulWidget {
  @override
  State<EscanearproductoPage> createState() => _EscanearproductoPageState();
}

class _EscanearproductoPageState extends State<EscanearproductoPage> {
  //var _scan = BarCodeScan();
  final code = String;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primary,
        elevation: 0,
        centerTitle: true,
        title: Text('Escanear producto',
            style: TextStyle(
                fontFamily: 'inter',
                fontWeight: FontWeight.w400,
                fontSize: 16)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              '',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600),
            ),
            style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100))),
          ),
        ],
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: ListView(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        children: [
          // Section 1 - Profile Picture Wrapper
          Container(
            color: AppColor.primary,
            padding: EdgeInsets.symmetric(vertical: 24),
            child: GestureDetector(
              onTap: () {
                print('Code to open file manager');
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Container(
                  //   width: 130,
                  //   height: 130,
                  //   margin: EdgeInsets.only(bottom: 15),
                  //   decoration: BoxDecoration(
                  //     color: Colors.grey,
                  //     borderRadius: BorderRadius.circular(100),
                  //     // Profile Picture
                  //     // image: DecorationImage(image: AssetImage('assets/images/profile.jpg'), fit: BoxFit.cover),
                  //   ),
                  // ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     Text('Change Profile Picture',
                  //         style: TextStyle(
                  //             fontFamily: 'inter',
                  //             fontWeight: FontWeight.w600,
                  //             color: Colors.white)),
                  //     SizedBox(width: 8),
                  //     SvgPicture.asset('assets/icons/camera.svg',
                  //         color: Colors.white),
                  //   ],
                  // )
                ],
              ),
            ),
          ),
          // Section 2 - User Info Wrapper
          Container(
            margin: EdgeInsets.only(top: 32, bottom: 6),
            width: MediaQuery.of(context).size.width,
            height: 60,
            child: ElevatedButton(
              onPressed: () async {
                scanBarcodeNormal();
                // _scan.scanBarcodeNormal();
                //_categorias.obtenerCategoria();

                // Navigator.of(context).pop();
                // Navigator.of(context).pushReplacement(
                //     MaterialPageRoute(builder: (context) => ProfilePage()));
              },
              child: Text('Escanear',
                  style: TextStyle(
                      color: AppColor.secondary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'inter')),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                backgroundColor: AppColor.primarySoft,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 24),
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UserInfoTile(
                  margin: EdgeInsets.only(bottom: 16),
                  label: 'Codigo FSL',
                  value: barcodeScanRes,
                ),
                UserInfoTile(
                  margin: EdgeInsets.only(bottom: 16),
                  label: 'Codigo ECOSTONE',
                  value: '123456',
                ),
                UserInfoTile(
                  margin: EdgeInsets.only(bottom: 16),
                  label: 'Modleo',
                  value: 'ampolleta 10w',
                ),
                UserInfoTile(
                  margin: EdgeInsets.only(bottom: 16),
                  label: 'cabtidad',
                  value: 'Premium Subscription',
                  valueBackground: AppColor.secondary,
                ),
                UserInfoTile(
                  margin: EdgeInsets.only(bottom: 16),
                  label: 'Categoria',
                  value: 'Until 22 Oct 2021',
                ),
                Container(
                  padding: EdgeInsets.zero,
                  margin: EdgeInsets.only(
                      top: 32,
                      bottom: 6,
                      left: MediaQuery.of(context).size.width / 4),
                  width: MediaQuery.of(context).size.width / 2,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () async {
                      // Navigator.of(context).pop();
                      // Navigator.of(context).pushReplacement(MaterialPageRoute(
                      //     builder: (context) => ProfilePage()));
                    },
                    child: Text('Guardar',
                        style: TextStyle(
                            color: AppColor.secondary,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'inter')),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      backgroundColor: AppColor.primarySoft,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  String barcodeScanRes = 'nada';
  Future<void> scanBarcodeNormal() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);

      setState(() {
        barcodeScanRes = barcodeScanRes;
      });
      print('el codigo es : $barcodeScanRes');
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
  }
}
