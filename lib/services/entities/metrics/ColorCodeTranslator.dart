import 'package:flutter/material.dart';
class ColorCodeTranslator{



  ///Return the color associated with the [code]
  static Color getColorOnCode(ColorCode code){
    switch(code){
      case ColorCode.RED:
        return Colors.redAccent.shade700;
      case ColorCode.GREEN:
        return Colors.limeAccent.shade700;
      case ColorCode.ORANGE:
        return Colors.deepOrange.shade400;
    }

  }

}

///Enum that represents the color code of a metric
enum ColorCode { RED, GREEN, ORANGE}