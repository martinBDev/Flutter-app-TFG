import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

class HeartReading{



  ///The value of the bpm metric
  final int _bpmMetric;
  ///The value of the o2 metric
  final int _o2Metric;
  ///The value of the sugar metric
  final int _sugarMetric;
  ///The value of the pressure metric
  final int _pressureMetric;
  ///The timestamp of the reading
  final Timestamp _timestamp;
  ///The position of the reading
  final Position _position;

  ///Constructor, set the initial values for the metrics,
  ///the timestamp and the position.
  HeartReading(this._bpmMetric, this._o2Metric, this._sugarMetric,
      this._pressureMetric, this._timestamp, this._position);

  Position get position => _position;

  Timestamp get timestamp => _timestamp;


  ///Get the value of the metric with the given [name]
  int getMetricByName(String name){
    switch(name){
      case "bpm":
        return _bpmMetric;
      case "o2":
        return _o2Metric;
      case "sugar":
        return _sugarMetric;
      case "pressure":
        return _pressureMetric;
      default:
        return -1;
    }
  }
}