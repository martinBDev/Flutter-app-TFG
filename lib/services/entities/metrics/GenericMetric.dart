import 'dart:ui';

import 'package:flutter/material.dart';

import 'ColorCodeTranslator.dart';
abstract class GenericMetric{


  ///Set the bpm and show a notification if it is too low or too high
  ///After setting the value, set the corresponding [colorCode]
  Color setValue(int value, [bool notify = true]);
  ///Current name of the metric
  String get name;
  ///Current value of the metric
  int get value;
  ///Current unit of the metric
  String get unit;
  ///Current color of the metric
  ColorCode _colorCode;

  ///Constructor, set the initial [colorCode]
  GenericMetric(this._colorCode);


  ///Set the [colorCode]
  set colorCode(ColorCode colorCode) => _colorCode = colorCode;
  ///Get the flutter color associated with the color code
  Color get color => ColorCodeTranslator.getColorOnCode(_colorCode);
  ///Get the color code
  ColorCode get colorCode => _colorCode;
}
