
import 'package:flutter/material.dart';

import '../../Notifications.dart';
import 'ColorCodeTranslator.dart';
import 'GenericMetric.dart';

class O2Metric extends GenericMetric{


  ///LOW_O2LEVEL is the maximum value of bpm that is considered normal
  final int LOW_O2LEVEL = 90;


  ///Constructor, set the initial [value] and the [colorCode], you can
  ///also set if you want to show a notification.
  O2Metric(this._value, [bool notify = true]) : super(ColorCode.GREEN){
    setValue(_value,notify);
  }

  ///Current value of the metric
  int _value;

  ///Current name of the metric
  @override
  String get name => "o2";

  ///Current value of the metric
  @override
  int get value => _value;

  ///Current unit of the metric
  @override
  String get unit => "%";



  ///Set the o2 and show a notification if it is too low or too high
  ///After setting the value, set the corresponding [colorCode]
  @override
  Color setValue(int value,[bool notify = true]) {
    _value = value;


    if(_value < LOW_O2LEVEL){
      if (notify) {
        showNotification(
            'Bajo nivel de oxigeno', 'Su nivel de oxigeno es muy bajo');
      }
      colorCode = ColorCode.RED;
    }else{
      colorCode = ColorCode.GREEN;
    }


    return color;

  }


}