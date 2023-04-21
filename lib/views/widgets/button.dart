import 'package:flutter/material.dart';
import 'package:hungry/views/utils/AppColor.dart';

class ButtonP{
  botonVerde(onPress,text){
   return  ElevatedButton(
                      onPressed: onPress,
                      child: Text(
                        text,
                        style: TextStyle(
                          color: AppColor.secondary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'inter',
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: AppColor.primarySoft,
                      ),
                    );
  }
}