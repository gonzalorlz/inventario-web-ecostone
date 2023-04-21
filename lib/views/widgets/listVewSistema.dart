import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class ListVewSistema {

  
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

  loading() {
return LoadingIndicator(
            indicatorType: Indicator.ballClipRotateMultiple,

            /// Required, The loading type of the widget
            colors: const [Colors.white],

            /// Optional, The color collections
            strokeWidth: 2,

            /// Optional, The stroke of the line, only applicable to widget which contains line
            backgroundColor: Colors.black,

            /// Optional, Background of the widget
            pathBackgroundColor: Colors.black,);

            /// Optional, the stroke backgroundColor
            
  }

  titulo(texto) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white24,
            borderRadius: BorderRadius.circular(10.0),
          ),
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Text(
            texto,
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
        ),
        Icon(Icons.inventory),
      ],
    );
  }
}
