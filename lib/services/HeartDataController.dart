import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app_tfg/services/Entities/Metrics/BpmMetric.dart';
import 'package:flutter_app_tfg/services/Entities/Metrics/O2Metric.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../l10n/MyLocalizer.dart';
import 'Entities/AlertCoolDown.dart';
import 'Entities/HeartReading.dart';
import 'Firebase/FirebaseFunctionsCaller.dart';
import 'Firebase/FirestoreAccess.dart';
import 'Notifications.dart';
import 'Entities/Metrics/PressureMetric.dart';
import 'Entities/Metrics/SugarMetric.dart';
import 'Entities/Response.dart';

class HeartDataController{

  ///Singleton
  HeartDataController._privateConstructor();
  static final HeartDataController instance = HeartDataController._privateConstructor();
  factory HeartDataController(){
    return instance;
  }

  ///BPM METRIC [BpmMetric]
  final BpmMetric _bpmMetric = BpmMetric(0);
  ///O2 METRIC [O2Metric]
  final O2Metric  _o2Metric = O2Metric(0);
  ///PRESSURE METRIC [PressureMetric]
  final PressureMetric _pressureMetric = PressureMetric(0);
  ///SUGAR METRIC [SugarMetric]
  final SugarMetric _sugarMetric = SugarMetric(0);


  ///CONNECTED STATUS [bool]
  bool _connected = false;


  ///Ask FirebaseFunctionsCaller to save the metrics.
  void _saveToFirebase()async{
    if ( _connected ){



      Response res = await FirebaseFunctionsCaller().saveMetrics(
          [_bpmMetric,
          _o2Metric,
          _pressureMetric,
          _sugarMetric],
          await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
      );


    }
  }

  //GETTERS FOR METRICS VALUES
  int getBpmValue(){
    return _bpmMetric.value;
  }

  int getO2Value(){
    return _o2Metric.value;
  }

  int getPressureValue(){
    return _pressureMetric.value;
  }

  int getSugarValue(){
    return _sugarMetric.value;
  }



  //SETTERS FOR METRICS VALUES
  void setO2Level(int o2Level){
    _o2Metric.setValue(o2Level);
  }

  void setBpm(int bpm){
    _bpmMetric.setValue(bpm);
  }

  ///Set the [pressure].
  ///Always the last to be updated, so it calls [_saveToFirebase].
  void setPressure(int pressure){

    _pressureMetric.setValue(pressure);
    //Always the last to be updated.
    _saveToFirebase();
  }


  ///Set the [sugar].
  void setSugar(int sugar){
    _sugarMetric.setValue(sugar);
  }

  ///Set the [connected] status.
  void setConnected(bool connected){
    _connected = connected;
  }
  bool get connected => _connected;



  //GETTERS FOR METRICS COLORS
  Color getColorBpm(){
    return _bpmMetric.color;
  }

  Color getColorO2Level(){
    return _o2Metric.color;
  }

  Color getColorPressure(){
    return _pressureMetric.color;
  }

  Color getColorSugarLevel(){
    return _sugarMetric.color;
  }


  ///Generate an alert with the current metrics.
  ///If the user is not connected, it will show an error message.
  ///If the user is connected, it will call [FirebaseFunctionsCaller.generateAlert]
  ///and show the response message.
  ///If needs the [context] to translate the response message.
  void generateAlert(BuildContext context) async{
    if (HeartDataController().connected) {

      final Response completed = await FirebaseFunctionsCaller().generateAlert([
        _bpmMetric,
        _o2Metric,
        _sugarMetric,
        _pressureMetric
      ],
          await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high));

      //Only way to trnaslate without giving the functions module the context of the app

      String translatedMessage =
      MyLocalizer.translate(completed.message, context) ?? completed.message;

      launchNotificationInApp(translatedMessage, context);

      if (!completed.success) {
        AlertCoolDown().resetCountdown();
      }

    }else{

      await launchNotificationInApp(
          AppLocalizations.of(context)!.alertErrorNoDevice,
          context
      );
      AlertCoolDown().resetCountdown();

    }
  }

  ///Get all the metrics in the last 30 days.
  Future<List<HeartReading>> getAllMetricsIn30Days() async {
    return (await FirestoreAccess().getAllMetricsIn30Days());
  }
}