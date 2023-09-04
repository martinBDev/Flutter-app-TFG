

import 'package:flutter/material.dart';
import 'package:flutter_app_tfg/services/Entities/HeartReading.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

import '../../services/Entities/Metrics/GenericMetric.dart';
import 'ExpandMap.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class ExpansionMap extends StatefulWidget {

  ///List of HeartReading to show
  final List<HeartReading> readings;
  ///List of ExpandMap to show
  List<ExpandMap> mostRecentMeditions = [];
  ///GenericMetric to filter
  final GenericMetric metricToFilter;

  ///Key to identify the widget, the [readings] and the [metricToFilter]
  ExpansionMap(
      {super.key, required this.readings, required this.metricToFilter}){

    //Order meditions by timestamp, most recent first
    readings.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    //Showing 3 most recent meditions
    int limit = readings.length > 3 ? 3 : readings.length;

   for(int i = 0; i < limit; i++){
     mostRecentMeditions.add(ExpandMap(heartMedition: readings[i], isExpanded: false));
   }


  }

  @override
  State<StatefulWidget> createState() => ExpansionMapState();
}


///Renders a GoogleMap with the position of the HeartReading and the timestamp
class ExpansionMapState extends State<ExpansionMap>{


  @override
  Widget build(BuildContext context) {

    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {

          //Close all the other panels
          for (var element in widget.mostRecentMeditions)
          {element.isExpanded = false;}

          //Open or close the selected panel
          widget.mostRecentMeditions[index].isExpanded = !isExpanded;
        });
      },
      children: widget.mostRecentMeditions.map<ExpansionPanel>((ExpandMap item) {
        return ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Text(
                  semanticsLabel: '${item.heartMedition.getMetricByName(widget.metricToFilter.name)} '
                      '${widget.metricToFilter.unit}',
                  '${item.heartMedition.getMetricByName(widget.metricToFilter.name)} '
                      '${widget.metricToFilter.unit}',
                  style : const TextStyle(
                      fontSize: 17,
                      color: Colors.black,
                      fontWeight: FontWeight.bold
                  )),
            );
          },
          body: ListTile(

              title: Text(
                  semanticsLabel: '${AppLocalizations.of(context)!.madeOn} ${DateFormat("dd-MM-yyyy - kk:mm:ss")
                      .format(item.heartMedition.timestamp.toDate())}',
                  '${AppLocalizations.of(context)!.madeOn} ${DateFormat("dd-MM-yyyy - kk:mm:ss")
                      .format(item.heartMedition.timestamp.toDate())}'),
              subtitle:
                  SizedBox(
                    height: 200,
                    child: GoogleMap(
                        initialCameraPosition:
                        CameraPosition(target:
                        LatLng(item.heartMedition.position.latitude, item.heartMedition.position.longitude),
                            zoom: 11.0, tilt: 0, bearing: 0),
                        markers: {
                          Marker(
                            markerId: const MarkerId('1'),
                            position: LatLng(item.heartMedition.position.latitude, item.heartMedition.position.longitude),
                            infoWindow: InfoWindow(title: AppLocalizations.of(context)!.infoWindow),
                          )
                        }
                    ),
                  ),

              ),
          isExpanded: item.isExpanded,

        );
      }).toList(),
    );
  }

}