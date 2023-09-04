import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

///Component to show a cell with a wave inside
class CellBlock extends StatefulWidget{



  ///Label to show in the cell
  final String label;
  ///Configuration of the wave
  late Config config;
  ///Color of the background of the cell
  late Color? backgroundColor = Colors.transparent;
  ///Height of the cell
  late double height = 12;

  ///Constructor, the [label] to show in the cell, the [config] of the wave,
  ///the [backgroundColor] of the cell and the [height] of the cell.
  CellBlock({super.key,
    required this.label,
    required this.config,
    this.backgroundColor = Colors.transparent,
    required this.height});

  @override
  State<CellBlock> createState() => CellBlockState();



}

class CellBlockState extends State<CellBlock>{



  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: double.infinity,
      child: Card(
        margin: const EdgeInsets.only(
            right: 16, left: 16, bottom: 16.0),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        //clipBehavior: Clip.antiAlias,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.0))),
        child: Stack(
          children: [
            WaveWidget(
              config: widget.config,
              backgroundColor: widget.backgroundColor,
              size: const Size(double.infinity, double.infinity),
              waveAmplitude:0,
            ),

            Container(
                alignment: Alignment.bottomCenter,
                child: Text(
                  widget.label,
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 30.0),
                )),


          ],
        )
      ),
    );
  }
}






