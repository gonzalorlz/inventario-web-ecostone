import 'package:hungry/interfaces/login_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EscanearController {
  final services = ILogin();

  Future<void> setSelectedInventory(String inventory) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('currentInventory', inventory);

    return inventory;
  }
}
