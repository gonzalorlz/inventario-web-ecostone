import 'package:flutter/material.dart';
import 'package:hungry/views/utils/AppColor.dart';
import '../screens/home_page.dart';
import '../screens/nueva_inventario.dart';
import 'package:hungry/views/compararPage.dart';
import 'package:hungry/views/filepicker.dart';

class MyDrawerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            Container(
              color: AppColor.primary,
              height: MediaQuery.of(context).size.height * 0.15,
              alignment: Alignment.center,
              child: const Text(
                'Menú Principal',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Inter',
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  MediaQuery.of(context).size.width * 0.05,
                  MediaQuery.of(context).size.height * 0.05,
                  MediaQuery.of(context).size.width * 0.05,
                  0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildMenuButton(
                      context,
                      Icons.home,
                      'Inicio',
                      HomePage(),
                    ),
                    _buildMenuButton(
                      context,
                      Icons.local_grocery_store,
                      'Bodega',
                      NuevoInventarioPage(),
                    ),
                    _buildMenuButton(
                      context,
                      Icons.settings,
                      'Sistema',
                      FilePickerpage(),
                    ),
                    _buildMenuButton(
                      context,
                      Icons.compare,
                      'Comparar',
                      CompararPage(),
                    ),
                    const SizedBox(height: 2),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(
      BuildContext context, IconData icon, String label, Widget page) {
    return ElevatedButton.icon(
      icon: Icon(icon),
      label: Text(
        label,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          fontFamily: 'Inter',
        ),
      ),
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => page),
      ),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black87,
        backgroundColor: Colors.white,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: Colors.grey, width: 1),
        ),
      ),
    );
  }
}
