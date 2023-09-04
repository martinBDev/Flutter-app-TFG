import 'package:flutter_blue/flutter_blue.dart';

class CustomBLEDevice{


  ///Encapsulates a bluetooth [_device] with the location of the service
  final BluetoothDevice _device;

  BluetoothDevice get device => _device;

  //The index location where the expected service is located
  late int serviceLocation;


  ///Name of the device
  final String _name;
  String get name => _name;

  ///Constructor, set the encapsulated [_device], the [serviceLocation] and the [_name]
  CustomBLEDevice(this._device, this.serviceLocation, this._name);


  ///Override equals method to compare devices by their mac address
  @override
  bool operator == (Object other) =>
      identical(this, other) ||
          other is CustomBLEDevice &&
              runtimeType == other.runtimeType &&
              _device.id == other._device.id;


  ///Override hashCode method to compare devices by their mac address
  @override
  int get hashCode => _device.id.hashCode;
}