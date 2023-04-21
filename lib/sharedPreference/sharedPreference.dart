

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';


class SharedPreference{
  
// Función para guardar el JSON en Shared Preferences
void guardarJsonEnSharedPreferences(Map<String, dynamic> json) async {
  final prefs = await SharedPreferences.getInstance();
  final jsonString = jsonEncode(json);
  await prefs.setString('json', jsonString);
}

// Función para leer el JSON de Shared Preferences
Future<Map<String, dynamic>> leerJsonDesdeSharedPreferences() async {
  final prefs = await SharedPreferences.getInstance();
  final jsonString = prefs.getString('json');
  if (jsonString == null) {
    return null;
  }
  final json = jsonDecode(jsonString);
  return json;
}
}