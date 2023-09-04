import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

///Component showing the min, avg and max values of the heart rate
class RowMinAvgMax extends StatefulWidget {

  ///Minimum value of the metric
  final int min;
  ///Average value of the metric
  final int avg;
  ///Maximum value of the metric
  final int max;

  ///Constructor, the [min], [avg] and [max] values of the metric
  const RowMinAvgMax(
      {super.key, required this.min, required this.avg, required this.max});

  @override
  State<StatefulWidget> createState() => _RowMinAvgMaxState();
}

class _RowMinAvgMaxState extends State<RowMinAvgMax> {
  final TextStyle _textStyle = const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  @override
  Widget build(BuildContext context) {
    //Get current date


    return Column(
      children: [

        const SizedBox(height: 10,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Text(
                            semanticsLabel: '${widget.min}',
                            '${widget.min}', style: _textStyle),
                        Text(
                            semanticsLabel: 'MIN',
                            'MIN', style: _textStyle),
                      ],
                    ),
                    const Icon(
                      Icons.arrow_downward,
                      color: Colors.white,
                      size: 30,
                    ),
                  ],
                ),
              ],
            ),
            Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Text(
                            semanticsLabel: '${widget.avg}',
                            '${widget.avg}', style: _textStyle),
                        Text(
                            semanticsLabel: 'AVG',
                            'AVG', style: _textStyle),
                      ],
                    ),
                    const Icon(
                      Icons.av_timer,
                      color: Colors.white,
                      size: 30,
                    ),
                  ],
                ),
              ],
            ),
            Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Text(
                            semanticsLabel: '${widget.max}',
                            '${widget.max}', style: _textStyle),
                        Text(
                            semanticsLabel: 'MAX',
                            'MAX', style: _textStyle),
                      ],
                    ),
                    const Icon(
                      Icons.arrow_upward,
                      color: Colors.white,
                      size: 30,
                    ),
                  ],
                ),
              ],
            ),
          ],
        )
      ],
    );
  }
}
