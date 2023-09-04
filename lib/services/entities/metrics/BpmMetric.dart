
import 'package:flutter/material.dart';

import '../../Notifications.dart';
import 'ColorCodeTranslator.dart';
import 'GenericMetric.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class BpmMetric extends GenericMetric{


  ///TAQUICARDIA is the maximum value of bpm that is considered normal
  final int TAQUICARDIA = 120;
  ///BRADICARDIA is the minimum value of bpm that is considered normal
  final int BRADICARDIA = 60;

  ///BPM in sport
  final int BPM_SPORT = 180;

  ///Constructor, set the initial [value] and the [colorCode], you can
  ///also set if you want to show a notification.
  BpmMetric(this._value, [bool notify = true]) : super(ColorCode.GREEN){
    setValue(_value,notify);
  }

  ///Current value of the metric
  int _value;

  @override
  String get name => "bpm";
  @override
  int get value => _value;
  @override
  String get unit => "bpm";

  ///Set the bpm and show a notification if it is too low or too high
  ///After setting the value, set the corresponding [colorCode]
  @override
  Color setValue(int value, [bool notify = true]) {
    _value = value;

    if(_value < BRADICARDIA){
      if (notify) {
        showNotification('Bracicardia', 'Su ritmo cardiaco es muy bajo');
      }
      colorCode = ColorCode.RED;
    }else if(_value > BRADICARDIA && _value < TAQUICARDIA){
      colorCode = ColorCode.GREEN;
    }else if(_value > TAQUICARDIA && _value < BPM_SPORT){
      if (notify) {
        showNotification('Taquicardia', 'Su ritmo cardiaco es alto');
      }
      colorCode = ColorCode.ORANGE;
    }else{
      if (notify) {
       showNotification("Peligro", "Su ritmo cardiaco es muy alto");
      }
      colorCode = ColorCode.RED;
    }

    return color;

  }

}
