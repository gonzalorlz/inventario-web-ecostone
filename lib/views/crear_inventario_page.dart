import 'package:flutter/material.dart';
import 'package:hungry/interfaces/login_interface.dart';
import 'package:hungry/views/widgets/appBar.dart';
import 'package:hungry/views/widgets/drawer_page.dart';

class CrearInventarioPage extends StatefulWidget {
  @override
  _CrearInventarioPageState createState() => _CrearInventarioPageState();
}

class _CrearInventarioPageState extends State<CrearInventarioPage> {
  String _nombreInventario;
  List<String> _productos = [];
  bool _inventarioCreado = false;
  final services = ILogin();

  final TextEditingController _nombreInventarioController =
      TextEditingController();

  Future<void> _crearInventario() async {
    setState(() {
      _inventarioCreado = false;
    });

    setState(() {
      _inventarioCreado = true;
    });
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Inventario creado"),
        content: Text("El inventario se ha creado exitosamente"),
        actions: [
          TextButton(
            child: Text("OK"),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nombreInventarioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget().appBar('Crear Inventario Bodega'),
      drawer: MyDrawerWidget(),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 24),
            Text(
              "Crear inventario",
              style: TextStyle(
                fontSize: 36,
                color: Colors.blue[900],
              ),
            ),
            SizedBox(height: 24),
            TextField(
              decoration: InputDecoration(
                labelText: 'Nombre del inventario',
                hintText: 'Ingresa el nombre del inventario a crear',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => _nombreInventario = value,
              controller: _nombreInventarioController,
            ),
            SizedBox(height: 48),
            ElevatedButton(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Crear Inventario",
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
              ),
              onPressed: () async {
                // Verificar si se ha ingresado el valor del campo de texto.
                if (_nombreInventarioController.text.isNotEmpty) {
                  final data = {'nombre': _nombreInventarioController.text};
                  await services.crearInventarioBodega(data);

                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: Text("Inventario creado"),
                      content: Text("El inventario se ha creado exitosamente"),
                      actions: [
                        TextButton(
                          child: Text("OK"),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                  );
                } else {
                  // Mostrar una alerta si no se ha ingresado un valor en el campo de texto.
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: Text("Campo vacío"),
                      content:
                          Text("Por favor ingresa el nombre del inventario."),
                      actions: [
                        TextButton(
                          child: Text("OK"),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                  );
                }
              },
              style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.blue[900]),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Volver",
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.blue[900],
                  ),
                ),
              ),
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(
                    color: Colors.blue[900],
                    width: 2,
                  ),
                ),
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
