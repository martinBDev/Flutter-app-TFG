
import 'package:flutter/material.dart';

class LinkButton extends StatelessWidget{

  ///Color of the button.
  Color color;
  ///Text to show in the button.
  Text contentText;
  ///Function to execute when the button is clicked.
  Function onclick;

  ///Key to identify the button, the [color] of the button,
  ///the [contentText] to show in the button and the.
  LinkButton(this.color, this.contentText, this.onclick, {super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
        bottom: 0,
        right: 0,
        child: Material(
          color: color,
          borderRadius: BorderRadius.circular(20),
          child: InkWell(

            onTap: (){
              onclick();
            },
            borderRadius: BorderRadius.circular(50),
            child: Container(
              width: 200,
              height: 50,
              alignment: Alignment.center,
              child: contentText,
            ),
          ),
        )

    );
  }

}