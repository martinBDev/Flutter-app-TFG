import 'package:flutter/cupertino.dart';

class UserPageButtonGrid extends StatelessWidget{

  ///List of [buttons] to show in the grid.
    List<Widget> buttons;

    ///Key to identify the grid and the [buttons] to show in the grid.
    UserPageButtonGrid(this.buttons, {super.key});

    @override
    Widget build(BuildContext context) {
      return GridView.count(
        crossAxisCount: 2,
        children: buttons,
      );
    }
}