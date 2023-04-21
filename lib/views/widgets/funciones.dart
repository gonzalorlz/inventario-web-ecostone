import 'package:flutter/material.dart';

class funcionesWidget{

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