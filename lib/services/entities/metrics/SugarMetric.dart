
import 'package:flutter/material.dart';

import '../../Notifications.dart';
import 'ColorCodeTranslator.dart';
import 'GenericMetric.dart';


class SugarMetric extends GenericMetric{



  //Azucar
  //Normal: 70-100 mg/dl
  ///NORMAL_SUGAR_MIN is the minimum value of bpm that is considered normal
  final int NORMAL_SUGAR_MIN = 70;
  ///NORMAL_SUGAR_MAX is the maximum value of bpm that is considered normal
  final int NORMAL_SUGAR_MAX = 100;
  //Prehiperglucemia: 100-125 mg/dl
  ///HYPER_SUGAR is the MINIMUM value of bpm that is considered HYPER
  final int HYPER_SUGAR = 125;
//Hiperglucemia: 125-200 mg/dl




  ///Constructor, set the initial [value] and the [colorCode], you can
  ///also set if you want to show a notification.
  SugarMetric(this._value, [bool notify = true]) : super(ColorCode.GREEN){
    setValue(_value,notify);
  }


  ///Current value of the metric
  int _value;

  ///Current name of the metric
  @override
  String get name => "sugar";

  ///Current value of the metric
  @override
  int get value => _value;

  ///Current unit of the metric
  @override
  String get unit => "mg/dl";

  ///Set the sugar and show a notification if it is too low or too high
  ///After setting the value, set the corresponding [colorCode]
  @override
  Color setValue(int value, [bool notify = true]) {
    _value = value;
    if(_value < NORMAL_SUGAR_MIN){
      if (notify) {
        showNotification('Hipoglucemia', 'Su nivel de azucar es muy bajo');
      }
      colorCode = ColorCode.RED;
    }
    else if(_value < NORMAL_SUGAR_MAX && _value > NORMAL_SUGAR_MIN){
      colorCode = ColorCode.GREEN;
    }else if(_value > NORMAL_SUGAR_MAX && _value < HYPER_SUGAR){
      if (notify) {
        showNotification(
            'Pre-diabetes', 'Su nivel de azucar es un poco alto');
      }
      colorCode = ColorCode.ORANGE;
    }else{
      if (notify) {
        showNotification('Hiperglucemia', 'Su nivel de azucar es muy alto');
      }
      colorCode = ColorCode.RED;
    }
    return color;

  }



}