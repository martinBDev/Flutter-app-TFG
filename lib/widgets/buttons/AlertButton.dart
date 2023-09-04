import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_tfg/services/Entities/AlertCoolDown.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../services/Entities/Metrics/ColorCodeTranslator.dart';

class AlertButton extends StatefulWidget {

  ///Key to identify the button. Also receives the [functionOnLongPressStart] to
  ///execute when the button is pressed for 5 seconds.
  AlertButton({super.key, required this.functionOnLongPressStart});

  ///Function to execute when the button is pressed for 5 seconds.
  Function() functionOnLongPressStart;


  @override
  AlertButtonState createState() => AlertButtonState();
}

class AlertButtonState extends State<AlertButton> {
  ///Progress of the button.
  int _progress = 0;
  ///Boolean to know if the button is pressed.
  bool _isPressed = false;
  ///Seconds to launch the action.
  int secondsToLaunch = 5;
  ///AlertCoolDown to manage the cooldown of the button.
  final AlertCoolDown _alertCooldown = AlertCoolDown();

  @override
  void initState() {
    super.initState();
    _alertCooldown.periodicExecution = _updateOnCountdown;
    _alertCooldown.onCountdownEnd = _resetButton;
  }

  ///Update the progress of the button every second.
  void _updateProgress() {
    if (_isPressed && !_alertCooldown.isActive) {
      if (_progress < secondsToLaunch) {
        setState(() {
          _progress += 1;
        });
        Future.delayed(const Duration(milliseconds: 1000), _updateProgress);
      }
      else if (_progress >= secondsToLaunch && !_alertCooldown.isActive) {
        _performAction();
      }
    }
      if (!_isPressed || _alertCooldown.isActive) {
        setState(() {
          _progress = 0;
        });
      }
    }


  ///Execute the function passed as parameter when
  ///the button is pressed for 5 seconds.
  void _performAction() {
    widget.functionOnLongPressStart();
    setState(() {
      _alertCooldown.startCountdown();
    });

  }


  ///Callback function to execute by the AlertCoolDown every second, it
  ///updates the button with the seconds left.
  void _updateOnCountdown(int secondsLeft){

    if(mounted){
      setState(() {

      });
    }

  }
  //After the action is performed, cool down the button for 60 seconds


  ///Callback function to execute by the AlertCoolDown when the countdown ends.
  void _resetButton() {

    if(mounted){
      setState(() {

        _progress = 0;

      });
    }

  }

  @override
  Widget build(BuildContext context) {

    if(_alertCooldown.isActive){
      _progress = 0;
    }



    return GestureDetector(
      onTapDown: (_) {
        if (!_alertCooldown.isActive){
          _isPressed = true;
          _updateProgress();
        }
      },
      onTapCancel: () {
        _isPressed = false;
        _updateProgress();
      },
      onTapUp: (_) {
        _isPressed = false;
        _updateProgress();
      },
      child: CircularPercentIndicator(
        radius: 80.0,
        lineWidth: 20.0,
        animation: true,
        percent: _progress /secondsToLaunch,
        center: _alertCooldown.isActive
            ? Text(
          semanticsLabel: "${_alertCooldown.currentCountDown}",
                "${_alertCooldown.currentCountDown}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 50,
                ),
              )
            : Icon(
                Icons.warning,
                size: 50.0,
                //The color of the icon is a gradient
                color: ColorCodeTranslator.getColorOnCode(ColorCode.RED),

              ),
        footer: Text(
          semanticsLabel: AppLocalizations.of(context)!.alertButton,
          AppLocalizations.of(context)!.alertButton,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            height: 2,
            fontSize: 17.0,
            color: Colors.white,
          ),
        ),
        circularStrokeCap: CircularStrokeCap.round,
        progressColor: ColorCodeTranslator.getColorOnCode(ColorCode.RED),
      ),
    );
  }
}
