import 'package:flutter/material.dart';
import 'package:hungry/views/compararPage.dart';
import 'package:hungry/views/filepicker.dart';
import 'package:hungry/views/screens/nueva_inventario.dart';
import 'package:hungry/views/utils/AppColor.dart';
import 'package:hungry/views/widgets/appBar.dart';
import 'package:hungry/views/widgets/drawer_page.dart';

class HomePage extends StatelessWidget {
  Widget _elevatedButton(BuildContext context, String buttonText,
      IconData buttonIcon, Function buttonFunction) {
    return SizedBox(
      width: 0.8 * MediaQuery.of(context).size.width,
      height: 64,
      child: ElevatedButton.icon(
        icon: Icon(
          buttonIcon,
          color: Colors.white,
          size: 24,
        ),
        label: Text(
          buttonText,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: 'inter',
          ),
        ),
        onPressed: buttonFunction,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarWidget().appBar('Inventarios Ecostone'),
      drawer: MyDrawerWidget(),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Inventario de Bodega',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Inter',
                  ),
                ),
                SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: _card(
                        context,
                        'Inventario Bodega',
                        Icons.system_update_tv,
                        NuevoInventarioPage(),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: _card(
                        context,
                        'Inventario Sistema',
                        Icons.file_upload,
                        FilePickerpage(),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                _card(
                  context,
                  'Comparar inventarios',
                  Icons.compare,
                  CompararPage(),
                  fullWidth: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _card(BuildContext context, String title, IconData icon, Widget page,
      {bool fullWidth = false}) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        },
        child: Container(
          width: fullWidth ? double.infinity : null,
          height: 200,
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                icon,
                size: 64,
                color: AppColor.primary,
              ),
              SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
