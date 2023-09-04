import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app_tfg/services/Entities/CustomBLEDevice.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_app_tfg/services/BLEController.dart';
import 'package:flutter_app_tfg/widgets/buttons/LinkButton.dart';

class BluetoothDeviceToList extends StatefulWidget {
  ///[device] to show.
  CustomBLEDevice device;
  ///Name of the device
  String name = "Desconocido";
  ///Boolean to know if the device is loading.
  bool isLoading = false;
  ///Boolean to know if the device is connected.
  bool thisIsConnected = false;

  ///BuildContext context.
  BuildContext context;

  ///Key to identify the device, the [device] to show and the [name].
  BluetoothDeviceToList(this.name, this.device, {super.key, required this.context});

  @override
  State<StatefulWidget> createState() => BluetoothDeviceToListState();
}

class BluetoothDeviceToListState extends State<BluetoothDeviceToList> {

  ///Button to link the device.
  late Widget linkingButton;


  ///Change the button to an unlink button.
  void setUnlinkButton(){
    setState(() {
      linkingButton =
          LinkButton(
              Colors.redAccent,
              Text(
                  semanticsLabel: AppLocalizations.of(widget.context)!.unlink,
                  AppLocalizations.of(widget.context)!.unlink),
              unlink);
      widget.isLoading = false;
    });
  }

  ///Change the button to an error button.
  void setErrorLinkingButton(){
    setState(() {
      linkingButton =
          LinkButton(
              Colors.orangeAccent,
              Text(
                  semanticsLabel: AppLocalizations.of(widget.context)!.errorLinking,
                  AppLocalizations.of(widget.context)!.errorLinking),
              link);
      widget.isLoading = false;
    });
  }

  ///Change the button to a link button.
  void setLinkButton(){
    setState(() {
      linkingButton =
          LinkButton(
              Colors.greenAccent,
              Text(
                  semanticsLabel: AppLocalizations.of(widget.context)!.link,
                  AppLocalizations.of(widget.context)!.link),
              link);
      widget.isLoading = false;
    });
  }

  /// Connects the device to the app
  /// - BLEController : links to the device.
  /// - Render button to unlink if it connects correctly.
  /// - Render button to retry if it doesn't connect correctly.
  void link() async {

    if(BLEController().isDeviceConnected()
        &&
        BLEController().getConnectedDevice()?.name != widget.name){
      setErrorLinkingButton();
      return;
    }

    //Se renderiza animacion de carga hasta q se conecte (o no) el dispositivo.
    setState(() {
      widget.isLoading = true;
    });

    bool success = false;
    try{
      success = await BLEController().connectToDevice(widget.device);

    } on TimeoutException catch(e){
      success = false;
    }

    widget.thisIsConnected = true;

    if (success && BLEController().isDeviceConnected() && widget.thisIsConnected) {
      //Si se conecta bien: renderizar boton para desconectar
      setUnlinkButton();
      return;
      //Si no se conecta bien: renderizar boton para reintentar
    } else {
      widget.thisIsConnected = false;
      setErrorLinkingButton();
      return;
    }

  }

  /// Disconnects the device from the app.
  /// - BLEController : disconnects from the device.
  /// - Render button to link if it disconnects correctly.
  void unlink() async {
    setState(() {
      widget.isLoading = true;
    });

    await BLEController().disconnectFromDevice();
    widget.thisIsConnected = false;
    if (!BLEController().isDeviceConnected() && !widget.thisIsConnected) {
      //desconectamos correctamente
      //renderizamos boton de conectar
      setLinkButton();
      return;
    } //Si no se desconecta correctamente, dejar boton para desconectar
  }


  @override
  void initState() {
    super.initState();

    if (BLEController().getConnectedDevice() == null) {
      linkingButton =
          LinkButton(Colors.greenAccent, Text(
              semanticsLabel: AppLocalizations.of(widget.context)!.link,
              AppLocalizations.of(widget.context)!.link), link);
    } else if (BLEController().getConnectedDevice()?.name == widget.name) {
      linkingButton =
          LinkButton(Colors.redAccent, Text(
              semanticsLabel: AppLocalizations.of(widget.context)!.unlink,
              AppLocalizations.of(widget.context)!.unlink), unlink);
    } else {
      linkingButton =
          LinkButton(Colors.greenAccent, Text(
              semanticsLabel: AppLocalizations.of(widget.context)!.link,
              AppLocalizations.of(widget.context)!.link), link);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(15),
        height: 100,
        child: Stack(
          children: [
            Positioned.fill(
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset('public/images/blue.jpg',
                        fit: BoxFit.cover))),
            Row(
              children: [
                Container(
                    padding: const EdgeInsets.all(10),
                    child: const Icon(
                      Icons.bluetooth,
                      color: Colors.white,
                      size: 25,
                    )),
                Text(
                semanticsLabel:  " ${AppLocalizations.of(context)!.device}: ${widget.name}",
                  " ${AppLocalizations.of(context)!.device}: ${widget.name}",
                  style: const TextStyle(color: Colors.white),
                )
              ],
            ),
            renderLinkButton()
          ],
        ));
  }

  Widget renderLinkButton() {
    if (widget.isLoading) {
      return const Positioned(
          right: 10,
          bottom: 10,
          child: SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 1.5,
              )));
    } else {
      return linkingButton;
    }
  }
}
