import 'package:flutter/material.dart';
import 'package:flutter_app_tfg/services/BLEController.dart';
import 'package:flutter_app_tfg/widgets/waves/CellBlock.dart';
import 'package:wave/config.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../services/HeartDataController.dart';
import '../services/Entities/Metrics/ColorCodeTranslator.dart';
import '../widgets/IndividualComponents/BottomNavBar.dart';
import '../widgets/waves/BpmCircle.dart';
import 'InfoScreen.dart';

class StatusScreen extends StatefulWidget {
  const StatusScreen({super.key});

  @override
  State<StatusScreen> createState() => StatusScreenState();
}

class StatusScreenState extends State<StatusScreen> {

  ///Variables to store the values of the metrics to be displayed
  int bpm = 0;
  int o2Level = 0;
  int pressure = 0;
  int sugar = 0;
  bool connected = false;

  ///Function to be called when the widget is created
  ///It sets the onDataChanged function to be called when a notification
  ///from Simulator is received
  ///It also loads the default values from HeartData module
  @override
  void initState() {
    super.initState();
    //Once a notification from Simulator is received,
    // the onDataChanged function is called
    BLEController().setOnDataChanged(onDataChanged);

    //Load default values from HeartData module
    bpm = HeartDataController().getBpmValue();
    o2Level = HeartDataController().getO2Value();
    pressure = HeartDataController().getPressureValue();
    sugar = HeartDataController().getSugarValue();
    connected = HeartDataController().connected;
  }


  ///This function will be called when a notification from Simulator is received
  void onDataChanged() {
    ///If the widget is mounted, update the state
    if(mounted){
      setState(() => {
        ///Update values from HeartData module
        bpm = HeartDataController().getBpmValue(),
        o2Level = HeartDataController().getO2Value(),
        pressure = HeartDataController().getPressureValue(),
        sugar = HeartDataController().getSugarValue(),
        connected = HeartDataController().connected
      });
    }

  }

  /// Function to get the color of the block, green if there is a connected
  /// device, red if not
  Color getColorOnConnect() {
    if (HeartDataController().connected) {
      return ColorCodeTranslator.getColorOnCode(ColorCode.GREEN);
    } else {
      return ColorCodeTranslator.getColorOnCode(ColorCode.RED);
    }
  }


  /// Function to generate a cell block with the given content and color
  CellBlock generateCellBlock(String content, Color color){

    return CellBlock(
              label: content,
              backgroundColor: Colors.black,
              config: CustomConfig(
                gradients: [
                  [color, Color(color.value+color.alpha+343)],
                  [color, Color(color.alpha+33)],
                  [color, Color(color.alpha+100)],
                  [color, color],
                ],
                durations: [35000, 19440, 10800, 6000],
                heightPercentages: [0.20, 0.23, 0.25, 0.30],
                gradientBegin: Alignment.bottomLeft,
                gradientEnd: Alignment.topRight,
              ),
              height: 90,
            );
  }



  @override
  Widget build(BuildContext context) {
    int localBpm = HeartDataController().getBpmValue();
    int localO2Level = HeartDataController().getO2Value();
    int localPressure = HeartDataController().getPressureValue();
    int localSugar = HeartDataController().getSugarValue();
    bool localConnected = HeartDataController().connected;

    return Scaffold(
      appBar: AppBar(
        title: Text(
            semanticsLabel:  AppLocalizations.of(context)!.status.toUpperCase(),
            AppLocalizations.of(context)!.status.toUpperCase()),

        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => InfoScreen()),
              );
            },
          ),
        ],
      ),

      body: ListView(

        children: [
          const SizedBox(height: 20.0),
          //Aqui componente gif
          BpmCircle("$localBpm ${AppLocalizations.of(context)!.bpm}",
              300,
              HeartDataController().getColorBpm()),


          const SizedBox(height: 16.0),
          generateCellBlock(
              "${AppLocalizations.of(context)!.pressure}: $localPressure mmHg",
              HeartDataController().getColorPressure()
          ),
          /*3*/ //O2 block
          generateCellBlock(
              "${AppLocalizations.of(context)!.o2level}: $localO2Level %",
              HeartDataController().getColorO2Level()
          ),
          // /*4*/ //Sugar block
          generateCellBlock(
              "${AppLocalizations.of(context)!.sugar}: $localSugar mg/dl",
              HeartDataController().getColorSugarLevel()
          ),
          // /*5*/ //Bluetooth state block, render only if connected, else render a false
          generateCellBlock(localConnected ?
          AppLocalizations.of(context)!.connected :
          AppLocalizations.of(context)!.disconnected,
                getColorOnConnect()),


        ],
      ),
      /*2*/ //Pressure block

      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
