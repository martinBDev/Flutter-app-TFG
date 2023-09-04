
import 'package:flutter/material.dart';

import '../../Notifications.dart';
import 'ColorCodeTranslator.dart';
import 'GenericMetric.dart';

class PressureMetric extends GenericMetric{


  //PRESION
  //Normal: 120/80 mmHg
  ///NORMAL_PRESSURE is the AVERAGE value of bpm that is considered normal
  final int NORMAL_PRESSURE = 120;
  //Prehipertensión: 120-139
  ///HYPER_PRESSURE is the maximum value of bpm that is considered normal
  final int HYPER_PRESSURE = 140;
//Hiperpresión: 140-159



  ///Constructor, set the initial [value] and the [colorCode], you can
  ///also set if you want to show a notification.
  PressureMetric(this._value, [bool notify = true]) : super(ColorCode.GREEN){
    setValue(_value,notify);
  }

  ///Current value of the metric
  int _value;

  ///Current name of the metric
  @override
  String get name => "pressure";

  ///Current value of the metric
  @override
  int get value => _value;

  ///Current unit of the metric
  @override
  String get unit => "mmHg";

  ///Set the pressure and show a notification if it is too low or too high
  ///After setting the value, set the corresponding [colorCode]
  @override
  Color setValue(int value, [bool notify = true]) {
    _value = value;

    if(_value < 50){
      if (notify) {
        showNotification('Hipotensión', 'Su presión es muy baja');
      }
      colorCode = ColorCode.RED;
    }
    else if(_value < NORMAL_PRESSURE*0.75){ //90
      if (notify) {
        showNotification('Hipotensión', 'Su presión es baja');
      }
      colorCode = ColorCode.ORANGE;
    }
    else if(_value > NORMAL_PRESSURE*0.75 && _value < NORMAL_PRESSURE*1.1){

      colorCode = ColorCode.GREEN;
    }
    else if(_value > NORMAL_PRESSURE*1.1 && _value < HYPER_PRESSURE){
      if (notify) {
      showNotification('Prehipertensión', 'Su presión es un poco alta');
      }
      colorCode = ColorCode.ORANGE;
    }else{
      if (notify) {
        showNotification('Hipertension', 'Su presión es muy alta');
      }
      colorCode = ColorCode.RED;
    }

    return color;

  }


}