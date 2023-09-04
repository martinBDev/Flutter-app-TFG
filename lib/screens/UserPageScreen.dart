
import 'package:flutter/material.dart';
import 'package:flutter_app_tfg/services/HeartDataController.dart';
import 'package:flutter_app_tfg/services/Entities/Metrics/O2Metric.dart';
import 'package:flutter_app_tfg/services/Entities/Metrics/SugarMetric.dart';
import 'package:flutter_app_tfg/services/MyNavigator.dart';
import 'package:flutter_app_tfg/widgets/buttons/UserPageMetricButton.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../services/Entities/Metrics/BpmMetric.dart';
import '../services/Entities/Metrics/PressureMetric.dart';
import '../services/Firebase/MyAuthController.dart';
import '../widgets/IndividualComponents/BottomNavBar.dart';
import '../widgets/buttons/AlertButton.dart';

class UserPageScreen extends StatefulWidget {
  const UserPageScreen({super.key});

  @override
  State<UserPageScreen> createState() => _UserPageScreenState();
}

class _UserPageScreenState extends State<UserPageScreen> {

  ///Get user name
  String name = MyAuthController().getUserName();

  @override
  void initState() {
    super.initState();
  }


  ///Asks HeartDataController to generate an alert. It is called when the user
  ///presses the AlertButton for some seconds
  void functionOnLongPressStart() async {

      HeartDataController().generateAlert(context);
  }



  Widget graph = const SizedBox(height: 35);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            semanticsLabel: AppLocalizations.of(context)!.userPageTitle,
            AppLocalizations.of(context)!.userPageTitle),
      ),
      body: Stack(
        children: [
          Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        UserPageMetricButton(
                          key: const Key("bpm_button"),
                          'public/images/monitor.png',
                          AppLocalizations.of(context)!.heartRate,
                          metricToFilter: BpmMetric(0, false),
                        ),
                        // Reemplaza con la ruta de tus imágenes
                        const SizedBox(width: 20),
                        UserPageMetricButton(
                            key: const Key("o2_button"),
                            'public/images/o2.png',
                            AppLocalizations.of(context)!.o2level,
                            metricToFilter: O2Metric(0, false)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        UserPageMetricButton(
                          key: const Key("sugar_button"),
                          'public/images/sugar.png',
                          AppLocalizations.of(context)!.sugar,
                          metricToFilter: SugarMetric(0, false),
                        ),
                        // Reemplaza con la ruta de tus imágenes
                        const SizedBox(width: 20),
                        UserPageMetricButton(
                            key: const Key("pressure_button"),
                            'public/images/pressure.png',
                            AppLocalizations.of(context)!.pressure,
                            metricToFilter: PressureMetric(0, false)),
                      ],
                    ),
                    const SizedBox(height: 30),
                    AlertButton(functionOnLongPressStart: functionOnLongPressStart),
                  ],
                ),
              )),
          Positioned(
              right: 10,
              top: 10,
              child: Row(
                children: [
                  Text(
                  semanticsLabel: MyAuthController().getUserName(),
                    MyAuthController().getUserName(),
                    style: const TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.account_circle, size: 24, color: Colors.white),
                ],
              )),
        ],
      ),
      floatingActionButton: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10),
        ),
        child: ElevatedButton(
          onPressed: () async {
            await MyAuthController().signOut();
            MyNavigator().navigateTo("/login",context);
          },
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: Text(
              semanticsLabel: AppLocalizations.of(context)!.logout,
              AppLocalizations.of(context)!.logout),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );

  }
}
