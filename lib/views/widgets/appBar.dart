import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppBarWidget {
  appBar(title, {bool searchIcon}) {
    return AppBar(
      backgroundColor: Colors.orange[700],
      elevation: 0,
      centerTitle: true,
      title: Text(
        title,
        style: TextStyle(
          fontFamily: 'inter',
          fontWeight: FontWeight.w400,
          fontSize: 16,
        ),
      ),
      systemOverlayStyle: SystemUiOverlayStyle.light,
    );
  }
}
