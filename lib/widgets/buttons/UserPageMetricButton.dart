import 'package:flutter/material.dart';
import 'package:flutter_app_tfg/screens/StatisticDataScreen.dart';
import 'package:flutter_app_tfg/services/Entities/Metrics/BpmMetric.dart';

import '../../services/Entities/Metrics/GenericMetric.dart';
class UserPageMetricButton extends StatelessWidget {
  ///Image to show in the button.
  String imageAsset;
  ///Text to show in the button.
  String text;
  ///Metric to filter the data.
  GenericMetric metricToFilter;

  ///Key to identify the button, the [imageAsset] to show in the button,
  ///the [text] to show in the button and the [metricToFilter] to filter the data.
  UserPageMetricButton(
      this.imageAsset, this.text,
      {super.key, required this.metricToFilter});

  @override
  Widget build(BuildContext context) {



    return SizedBox(
      width: 150,
      height: 150,

        child: Stack(
          children: [
              Positioned.fill(
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset('public/images/blue.jpg',
                          fit: BoxFit.fill)
                  )
              ),

            ElevatedButton(
              onPressed: () {

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => GraphDataScreen(metricToFilter: metricToFilter,)
                    ),
                   // ModalRoute.withName("/status")
                );

              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20), // Radio de las esquinas redondeadas
                ),
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,

                padding: const EdgeInsets.all(0),
              ),
                child: Stack(
                  children: [
                    Image.asset(imageAsset, fit: BoxFit.cover),
                    Positioned.fill(
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5), // Color semitransparente
                            borderRadius: BorderRadius.circular(10), // Bordes redondeados
                          ),
                          child: Text(
                            semanticsLabel: text,
                            text,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )

              ),
          ],
        ),

    );
  }
}
