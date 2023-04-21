import 'package:flutter/material.dart';

class InventoryDetail{
  static const double _itemSpacing = 8.0;
  void showInventoryDetails(BuildContext context, Map<String, dynamic> inventory) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(inventory['nombre']),
          content: SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildDateText(inventory['fecha']),
                SizedBox(height: 16),
               // _buildProductsList(inventory['arrayDetalle']),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cerrar',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDateText(String date) {
    return Text(
      'Fecha: $date',
      style: TextStyle(
        fontSize: 16,
      ),
    );
  }

  Widget _buildProductsList(List<dynamic> products) {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: products.length,
        itemBuilder: (BuildContext context, int index) {
          final product = products[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: _itemSpacing),
              Text(
                '• Código: ${product['codigo']}',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              Text(
                '  Descripción: ${product['descripcion']}',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              Text(
                '  Stock: ${product['stock']}',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
