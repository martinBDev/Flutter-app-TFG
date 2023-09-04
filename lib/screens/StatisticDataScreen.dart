

import 'package:flutter_app_tfg/l10n/MyLocalizer.dart';
import 'package:flutter_app_tfg/services/HeartDataController.dart';
import 'package:flutter_app_tfg/widgets/StatisticsComponents/RowMinAvgMax.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../services/Entities/HeartReading.dart';
import '../services/Entities/Metrics/ColorCodeTranslator.dart';
import '../services/Entities/Metrics/GenericMetric.dart';
import '../widgets/IndividualComponents/BottomNavBar.dart';
import '../widgets/StatisticsComponents/ExpansionMapsList.dart';

class GraphDataScreen extends StatefulWidget{

  ///Constructor for GraphDataScreen, it receives a [GenericMetric] to filter the data
  GraphDataScreen( {required this.metricToFilter, super.key});

  ///Metric to filter the data
  GenericMetric metricToFilter;




  @override
  State<GraphDataScreen> createState() => GraphDataScreenState();

}

class GraphDataScreenState extends State<GraphDataScreen> {

  ///Boolean to know if the data is loaded
  bool _isLoaded = false;

  ///Lists to store the data, one contains all the data, the others are filtered
  ///by color
  List<HeartReading> _heartReadings = [];
  List<HeartReading> _redHeartReadings = [];
  List<HeartReading> _orangeHeartReadings = [];
  List<HeartReading> _greenHeartReadings = [];

  ///Average, max and min values
  int _avg = 0;
  //Max integer Dart can generate
  int _max = -2147483648;
  //Min integer Dart can generate
  int _min = 2147483647;






  ///Asks HeartDataController for the metrics in the last 30 days
  ///and then filters the data by color
  void readData() async {
    final data = await HeartDataController().getAllMetricsIn30Days();
    _treatData(data,  widget.metricToFilter);
    setState(() {
      _greenHeartReadings;
      _orangeHeartReadings;
      _redHeartReadings;

      _heartReadings = data;
     _isLoaded = true;
    });
  }


  ///Filter the data by color and calculates the max, min and avg
  void _treatData(List<HeartReading> allReadings, GenericMetric metric) async{

    List<List<HeartReading>> toReturn= [];

    Color curColor;
    int tempAvg = 0;

    if(allReadings.isEmpty){
      _avg = 0;
      _max = 0;
      _min = 0;
      return;
    }

    for (var reading in allReadings) {
      curColor = metric.setValue(reading.getMetricByName(metric.name), false);

      if(curColor == ColorCodeTranslator.getColorOnCode(ColorCode.RED)){
        _redHeartReadings.add(reading);
      }else if(curColor == ColorCodeTranslator.getColorOnCode(ColorCode.ORANGE)){
        _orangeHeartReadings.add(reading);
      }else if(curColor == ColorCodeTranslator.getColorOnCode(ColorCode.GREEN)){
        _greenHeartReadings.add(reading);
      }

      //Calculate the max, min and avg
      if(metric.value > _max){
        _max = metric.value;
      }
      if(metric.value < _min){
        _min = metric.value;
      }
      tempAvg += metric.value;

    }


    //Calculate the avg
    //Equal to 0 if there are no meditions
    _avg = allReadings.isEmpty ? 0 : tempAvg ~/ allReadings.length;



  }

  @override
  Widget build(BuildContext context) {

    DateTime now = DateTime.now();
    String formattedDate = '${now.day}/${now.month}/${now.year}';

    //Get date from 30 days ago
    DateTime thirtyDaysAgo = DateTime(now.year, now.month, now.day - 30);
    String formattedDate30DaysAgo =
        '${thirtyDaysAgo.day}/${thirtyDaysAgo.month}/${thirtyDaysAgo.year}';





    List<ChartData> chartData = [];

    if(_isLoaded){

      int total = _heartReadings.isEmpty ? 1 : _heartReadings.length;
      int red = _redHeartReadings.length;
      int orange = _orangeHeartReadings.length;
      int green = _greenHeartReadings.length;


      chartData = [
        ChartData('${AppLocalizations.of(context)!.acceptable} ${(green*100/total).toStringAsFixed(2)}%',
            _greenHeartReadings.length,
            ColorCodeTranslator.getColorOnCode(ColorCode.GREEN)),
        ChartData('${AppLocalizations.of(context)!.risky} ${(orange*100/total).toStringAsFixed(2)}%',
            _orangeHeartReadings.length,
            ColorCodeTranslator.getColorOnCode(ColorCode.ORANGE)),
        ChartData('${AppLocalizations.of(context)!.dangerous} ${(red*100/total).toStringAsFixed(2)}%',
            _redHeartReadings.length,
            ColorCodeTranslator.getColorOnCode(ColorCode.RED))
      ];
    }else{
      readData();

      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
            semanticsLabel:AppLocalizations.of(context)!.lapseDays,
            AppLocalizations.of(context)!.lapseDays),
        backgroundColor: Colors.lightBlue,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[

            SfCircularChart(
                //Legend on lower part of the graph
                legend: Legend(
                  itemPadding: 10,
                  isVisible: true,
                  position: LegendPosition.right,
                  overflowMode: LegendItemOverflowMode.wrap,
                  shouldAlwaysShowScrollbar: true,
                  borderColor: Colors.white,
                  borderWidth: 2,
                  backgroundColor: Colors.lightBlue,
                  iconHeight: 20,
                  iconWidth: 20,
                  toggleSeriesVisibility: true,
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                  title: LegendTitle(
                    text: MyLocalizer.translate(
                       widget.metricToFilter.name.toUpperCase(),
                      context,),
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                ),


                series: <CircularSeries>[
                  DoughnutSeries<ChartData, String>(
                    dataSource: chartData,
                    pointColorMapper:(ChartData data,  _) => data.color,
                    xValueMapper: (ChartData data, _) => data.colorCode,
                    yValueMapper: (ChartData data, _) => data.numberMeditions,
                    // startAngle: 270,
                    //endAngle: 90
                  ),
                ],
              ),

            Text(
              semanticsLabel: '$formattedDate30DaysAgo - $formattedDate',
              '$formattedDate30DaysAgo - $formattedDate',
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.lightBlue,
                borderRadius: BorderRadius.circular(10),
              ),
              child: RowMinAvgMax(
                min:  _min,
                avg:  _avg,
                max:  _max,
              ),
            ),
            const SizedBox(height: 20),

            //If there are no meditions, show a message
             _redHeartReadings.isEmpty ? Text(
                semanticsLabel: AppLocalizations.of(context)!.noBadReadings,
              AppLocalizations.of(context)!.noBadReadings,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.normal,
                color: Colors.white,
                decoration: TextDecoration.underline,
              ),
            ) : Text(
                semanticsLabel: AppLocalizations.of(context)!.latestBadReadings,
              AppLocalizations.of(context)!.latestBadReadings,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            ExpansionMap(
              readings:  _redHeartReadings, metricToFilter:  widget.metricToFilter,
            ),


          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }



}

class ChartData {
  ChartData(this.colorCode, this.numberMeditions,this.color);
  final String colorCode;
  final int numberMeditions;
  final Color color;
}