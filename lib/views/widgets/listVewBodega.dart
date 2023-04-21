import 'package:flutter/material.dart';

class ListVewBodega {
  var selectedCardBodega;
  ListView guestructor(dataBodega, itemBodega) {
    return ListView.builder(
      itemCount: dataBodega.length,
      itemBuilder: (context, index) {
        final item = dataBodega[index];
        return GestureDetector(
          onTap: () {
            final selectedItem = dataBodega[index];
            showDialog(
              context: context,
              builder: (_) {
                bool isGuardado = dataBodega[index]['guardado'] ?? false;
                return AlertDialog(
                  title: Text('Detalles del inventario'),
                  content: Container(
                    width: double.maxFinite,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Nombre: ${item['nombre']}'),
                        SizedBox(height: 8),
                        Text('Fecha: ${item['fecha']}'),
                      ],
                    ),
                  ),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Cerrar'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                      
                        itemBodega = selectedItem;
                        selectedCardBodega = index;
                        Navigator.pop(context);
                      },
                      child: Text('Guardar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                    ),
                  ],
                );
              },
            );
          },
          child: Card(
            elevation: 5,
            margin: EdgeInsets.symmetric(
              horizontal: 50,
              vertical: 10,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            color: selectedCardBodega == index
                ? Colors.lightBlue.shade100
                : Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    'Nombre: ${item['nombre']}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Fecha: ${item['fecha']}',
                  ),
                ),
                SizedBox(height: 16),
                Divider(),
              ],
            ),
          ),
        );
      },
    );
  }
}




