import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class Loading{
    Widget loadingIndicator() {
    return SizedBox(
      height: 50,
      width: 50,
      child: LoadingIndicator(
        indicatorType: Indicator.lineScalePulseOut,strokeWidth: 10,
        
      ),
    );
  }
}