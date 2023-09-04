import 'package:flutter/material.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

///Component to show a circle with a wave inside.
class BpmCircle extends StatefulWidget {
  ///Label to show in the circle.
  String label = " BPM";
  ///Radius of the circle.
  double radius = 300;

  ///Color of the circle
  Color color = Colors.red;

  ///Constructor, the [label] to show in the circle and the [radius] of the circle.
  BpmCircle(this.label,
      this.radius,
      this.color,
      {Key? key}) : super(key: key);

  @override
  BpmCircleState createState() => BpmCircleState();
}

class BpmCircleState extends State<BpmCircle> {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Align(
        child: Container(

          height: widget.radius,
          width: widget.radius,
          decoration:  BoxDecoration(
              shape: BoxShape.circle, boxShadow: [
            BoxShadow(
              color: widget.color,
              blurRadius: 6.0,
              spreadRadius: -3.0,
              offset: const Offset(0.0, 8.0),
            ),
          ]),
          child: ClipOval(
            child: WaveWidget(
              config: CustomConfig(
                colors: [
                  widget.color,
                  widget.color,
                ],
                durations: [
                  5000,
                  4000,
                ],
                heightPercentages: [
                  0.65,
                  0.66,
                ],
              ),
              backgroundColor: Colors.lightBlue,
              size: const Size(double.infinity, double.infinity),
              waveAmplitude: 0,
            ),
          ),
        ),
      ),
      Positioned.fill(
          child:
      Container(
          alignment: Alignment.center,
          height: widget.radius,
          child: Text(
            semanticsLabel: widget.label,
            widget.label,
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 50.0),
          )),
      )]);
  }
}
