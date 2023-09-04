import 'package:flutter_app_tfg/services/Entities/HeartReading.dart';


///Class to show in the expansion tile.
class ExpandMap {

  ///HeartReading to show in the expansion tile.
  final HeartReading heartMedition;

  ///True if the expansion tile is expanded.
  bool isExpanded;


  ///Constructor, requires the HeartReading to show and if the expansion tile is expanded.
  ExpandMap({
    required this.heartMedition,
    required this.isExpanded
  });
}