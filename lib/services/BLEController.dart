
import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter_app_tfg/services/Entities/CustomBLEDevice.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_app_tfg/services/HeartDataController.dart';

import '../screens/BluetoothDevicesListScreen.dart';
class BLEController{

  //Singleton
  BLEController._privateConstructor();
  static final BLEController _instance = BLEController._privateConstructor();
  factory BLEController(){
    return _instance;
  }


  final FlutterBlue _flutterBlue = FlutterBlue.instance;

  final List<CustomBLEDevice> _devices = <CustomBLEDevice>[];

  final HeartDataController _heartDataController = HeartDataController();

  //regex to check device names, only devices with names
  final RegExp _regExp = RegExp(r'\w');

  //Init bluetoothDevice to a default value
  CustomBLEDevice? _connectedDevice;


    bool _isDeviceConnected = false;


   BluetoothCharacteristic? _bpm;
   BluetoothCharacteristic? _o2;
   BluetoothCharacteristic? _sugar;
   BluetoothCharacteristic? _pressure;


   ///Function to execute when data is changed
    Function()? _onDataChanged;

    ///Scan for devices for a given [duration]. When the scan ends, execute [endOfScan].
  ///When a device is found, execute [notifyAsker].
  void scanForDevices(Function() notifyAsker, Function() endOfScan, int duration) async{

    // Start scanning; when scan ends, execute endOfScan
    _flutterBlue.startScan(timeout:  Duration(seconds: duration));



    // Listen to scan results
    _devices.clear();

    CustomBLEDevice currDevice;
      //Clear the list in every scan to avoid showing scanned
      //devices that are no longer reachable
      var subscription = _flutterBlue.scanResults.listen((results) {
        // each scanResult contains the BluetoothDevice
        for (ScanResult r in results) {

          BluetoothDevice device = r.device;

          //If device has a service with UUID 180D, add it to the list
          currDevice = CustomBLEDevice(device, -1, device.name);

          //If name is not empty and is not yet in the list
          if(_regExp.hasMatch(device.name.trim()) &&
              !_devices.contains(currDevice) &&
            currDevice != _connectedDevice){

            _devices.add(currDevice);
            notifyAsker();

          }
        }

      });

    Timer( Duration(seconds: duration), () {
      _flutterBlue.stopScan();
      endOfScan();
    });



  }

  CustomBLEDevice? getConnectedDevice() {
     return _connectedDevice;
  }


  List<CustomBLEDevice> getDevices() {
     return _devices;
  }

  /// Connects to the [customDevice].
  Future<bool> connectToDevice(CustomBLEDevice customDevice) async {


    try {
      await customDevice.device.connect(autoConnect: true, timeout: const Duration(seconds: 6));

      _connectedDevice = customDevice;
      _isDeviceConnected = true;
      //False if there was error
      await _discoverServices();


      print("Connected");
      return true;
    }on Exception catch(e){

      _isDeviceConnected = false;
      _heartDataController.setConnected(false);
      await customDevice.device.disconnect();
      print("Timeout while connecting");
      return false;

    }

  }

  /// Disconnects from the device.
  disconnectFromDevice() async{

     try{
       await _connectedDevice?.device.disconnect();
       _connectedDevice = null;
       _isDeviceConnected = false;
       _heartDataController.setConnected(false);
       print("Disconnected");
     }catch(e){
        print("Error while disconnecting");
     }



  }

  bool isDeviceConnected(){
     return _isDeviceConnected;
  }


  void setOnDataChanged(Function() onDataChanged){
    _onDataChanged = onDataChanged;
  }


  ///Discover services and characteristics.
  ///If any service contains 180D, do not allow the connection.
  Future<void> _discoverServices() async {

    if(_connectedDevice == null){
      print("No device connected for discovering services");
      throw Exception("No device connected for discovering services");

    }

    print("Discovering services");
    //Get the services
    List<BluetoothService> services = await _connectedDevice!.device.discoverServices();

    //Get the service that contains the characteristics
    //There must be a service with UUID 180D
    for(BluetoothService service in services){
      if(service.uuid.toString().contains("180d")){
        _connectedDevice!.serviceLocation = services.indexOf(service);
        break;
      }
    }

    if(_connectedDevice!.serviceLocation < 0){
      print("No service found");
      throw Exception("No service found with UUID 180D");
    }

    //Get the characteristics
    //Services[2] is the service that contains the characteristics by default
    int serviceLocation = _connectedDevice?.serviceLocation ?? 2;


    //Standar for UUID characteristics:
    //2a37 -> BPM
    //2a58 -> O2 (not standarized, using free UUID)
    //2a59 -> Sugar (not standarized, using free UUID)
    //2a49 -> Pressure
    //https://www.bluetooth.com/specifications/assigned-numbers/
    for(BluetoothCharacteristic characteristic in services[serviceLocation].characteristics){
      if(characteristic.uuid.toString().contains("2a37")){
        _bpm = characteristic;
      }
      else if(characteristic.uuid.toString().contains("2a58")){
        _o2 = characteristic;
      }
      else if(characteristic.uuid.toString().contains("2a59")){
        _sugar = characteristic;
      }
      else if(characteristic.uuid.toString().contains("2a49")){
        _pressure = characteristic;
      }
    }

    if(_bpm == null || _o2 == null || _sugar == null || _pressure == null){
      print("Not all characteristics found");
      throw Exception("Not all characteristics found");
    }

    //Set notifications
    await _bpm!.setNotifyValue(true);
    await _o2!.setNotifyValue(true);
    await _sugar!.setNotifyValue(true);
    await _pressure!.setNotifyValue(true);

    //Read the data of characteristics as integers
    List<int> bpmData = await _bpm!.read();
    List<int> o2Data = await _o2!.read();
    List<int> sugarData = await _sugar!.read();
    List<int> pressureData = await _pressure!.read();

    //Convert list of hexadecimals to integer
    int finalBpm = ByteData.view((bpmData as Uint8List).buffer).getInt16(0, Endian.little);
    int finalO2 = ByteData.view((o2Data as Uint8List).buffer).getInt16(0, Endian.little);
    int finalSugar = ByteData.view((sugarData as Uint8List).buffer).getInt16(0, Endian.little);
    int finalPressure = ByteData.view((pressureData as Uint8List).buffer).getInt16(0, Endian.little);

    //Set the data to the heartData object
    _heartDataController.setBpm(finalBpm);
    _heartDataController.setO2Level(finalO2);
    _heartDataController.setSugar(finalSugar);
    _heartDataController.setPressure(finalPressure);
    _heartDataController.setConnected(true);


    //Listen to the notifications
    //The functions inside the "listen" are called when a notification is received
    _bpm!.value.listen((value) {
      _heartDataController.setBpm(ByteData.view((value as Uint8List).buffer).getInt16(0, Endian.little));
      _onDataChanged!();
    });
    _o2!.value.listen((value) {
      _heartDataController.setO2Level(ByteData.view((value as Uint8List).buffer).getInt16(0, Endian.little));
      _onDataChanged!();
    });
    _sugar!.value.listen((value) {
      _heartDataController.setSugar(ByteData.view((value as Uint8List).buffer).getInt16(0, Endian.little));
      _onDataChanged!();
    });
    _pressure!.value.listen((value) {
      _heartDataController.setPressure(ByteData.view((value as Uint8List).buffer).getInt16(0, Endian.little));
      _onDataChanged!();
    });


  }


}

