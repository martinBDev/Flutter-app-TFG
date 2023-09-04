
import 'package:flutter/material.dart';

class  MyFormField extends StatefulWidget{


  ///Controller to get the text of the field
  final TextEditingController editingController;
  ///Text to show in the button
   final String labelText;
  ///Boolean to know if the button is loading
   final bool obscureText;


   ///Constructor, the [editingController] to get the text of the field,
  /// the [labelText] to show in the button and the
  ///[obscureText] to know if the button is loading
   const MyFormField({
    super.key,
    required this.editingController,
    required this.labelText,
   required this.obscureText});

  @override
  State<MyFormField> createState() => _MyFormFieldState();



}


class _MyFormFieldState extends State<MyFormField>{



  @override
  Widget build(BuildContext context) {



   return  TextFormField(
     decoration:  InputDecoration(
       fillColor: Colors.white,
       filled: true,
       border: const UnderlineInputBorder(),
       label: Text(
           semanticsLabel: widget.labelText,
           widget.labelText,
            style: const TextStyle(
              color: Color.fromARGB(255, 1, 117, 228),
            )
       ),

     ),
     controller: widget.editingController,
     obscureText: widget.obscureText,
     //..
   );
  }


}