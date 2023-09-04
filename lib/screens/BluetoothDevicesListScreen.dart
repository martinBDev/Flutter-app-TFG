import 'package:flutter/material.dart';
import 'package:flutter_app_tfg/services/Entities/CustomBLEDevice.dart';
import 'package:location/location.dart';
import 'package:flutter_app_tfg/services/BLEController.dart';
import 'package:flutter_app_tfg/widgets/IndividualComponents/BottomNavBar.dart';
import '../widgets/IndividualComponents/BluetoothDeviceToList.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart'
as bluetooth_for_permissions;

class BluetoothDevicesListScreen extends StatefulWidget {
  const BluetoothDevicesListScreen({super.key});



  @override
  State<StatefulWidget> createState() => BluetoothDevicesListScreenState();
}

class BluetoothDevicesListScreenState extends State<BluetoothDevicesListScreen> {
  ///List of devices to show
  List<CustomBLEDevice> devices = BLEController().getDevices();

  ///Icon to show when scanning for devices
  Widget searchIcon = const Icon(Icons.search);

  ///Location object to check if geolocation is enabled
  Location location = Location();

  ///Booleans to check if geolocation and bluetooth are enabled
  bool _locationEnabled = false;
  bool _bleEnabled = false;


  @override
  void initState() {
    super.initState();


    ///Check if bluetooth is enabled, if not, ask for it
    bluetooth_for_permissions.FlutterBluetoothSerial.instance.isEnabled.then((value) {
      setState(() {
        _bleEnabled = value!;
      });
    });

    ///If geolocation is not enabled, ask for it
    location.serviceEnabled().then((value) {
      setState(() {
        _locationEnabled = value;
      });
    });



  }

  @override
  Widget build(BuildContext context) {


    ///If bluetooth is not enabled, show a red button
    if(!_bleEnabled && !_locationEnabled){
      devices = [];
    }

    ///If a device is connected, add it to the list, to be
    ///able to disconnect from it
    if(BLEController().isDeviceConnected()
        && !devices.contains(BLEController().getConnectedDevice()!)){
      devices.add(BLEController().getConnectedDevice()!);
    }

    return Scaffold(
      //drawer: Drawer(),
      appBar: AppBar(
        title: Text(
            semanticsLabel: AppLocalizations.of(context)!.deviceListTitle,
            AppLocalizations.of(context)!.deviceListTitle),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [

          Expanded(
              child: ListView.builder(
                //Build a list of detected bluetooth devices
                  itemCount: devices.length,
                  itemBuilder: (BuildContext ctx, int index) {
                    return BluetoothDeviceToList(
                      devices[index].name,
                      devices[index],
                      context: ctx,
                    );
                  })),

        ],
      ),
      //Button to start scanning for devices, if geolocation is not enabled, show a red button
      //If bluetooth is not enabled, show a red button
      floatingActionButton: FloatingActionButton(
        key: const Key("scan_button"),
        onPressed: doScan,
        backgroundColor: _locationEnabled && _bleEnabled ?  Colors.lightBlue : Colors.redAccent,
        child: _locationEnabled && _bleEnabled ? searchIcon : const Icon(Icons.location_off),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }


  ///Method to start scanning for devices
  ///If geolocation is not enabled, ask for it
  ///If bluetooth is not enabled, ask for it
  ///If both are enabled, start scanning for devices
  void doScan() async{
    if (!_locationEnabled) {
      _locationEnabled = await location.requestService();
      if (!_locationEnabled) {
        return;
      }
    }

    if(!_bleEnabled){
      _bleEnabled = (await bluetooth_for_permissions.FlutterBluetoothSerial.instance.requestEnable())!;

      if(!_bleEnabled){
        return;
      }
    }

    if(!_bleEnabled && !_locationEnabled){
      devices = [];
    }

    if(BLEController().isDeviceConnected()
        && !devices.contains(BLEController().getConnectedDevice()!)){
      devices.add(BLEController().getConnectedDevice()!);
    }

    //If bluetooth phone sevice is not enabled, ask for it

    BLEController().scanForDevices(updateScannedDevices,onEndOfScan,  6);
    //Show loading icon for 4 seconds
    setState(() {
      searchIcon = const CircularProgressIndicator(
        color: Colors.white,
        strokeWidth: 1.5,
      );
    });
  }

  ///Function to be passed as parameter to BLEController.scanForDevices
  ///to update the list of devices every time a new device is found
  void updateScannedDevices() {
    if(mounted){
      devices.clear();

      setState(() {
        if(BLEController().isDeviceConnected()){
          devices.add(BLEController().getConnectedDevice()!);
        }
        BLEController().getDevices().forEach((element) {
          devices.add(element);
        });

      });
    }
  }

  ///Function to be passed as parameter to BLEController.scanForDevices
  ///to update the list of devices when the scan is finished
  void onEndOfScan() {
    //If user still in the screen, show search icon
    if(mounted){
      setState(() {
        searchIcon = const Icon(Icons.search);
      });
    }
  }
}
