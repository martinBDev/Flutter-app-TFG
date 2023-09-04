import 'package:flutter/material.dart';

class FormButton extends StatefulWidget {
  ///Text to show in the button.
  final String text;

  ///Function to execute when the button is pressed.
  final Future<void> Function() onPressed;

  ///Key to identify the button, the [text] to show in the button and the
  ///function to execute when the button is [onPressed].
  const FormButton({Key? key, required this.text, required this.onPressed})
      : super(key: key);

  @override
  FormButtonState createState() => FormButtonState();
}

class FormButtonState extends State<FormButton> {

  ///Boolean to know if the button is loading.
  final ValueNotifier<bool> _isLoading = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: _isLoading.value
          ? null
          : () async {
        _isLoading.value = true;
        await widget.onPressed();
        _isLoading.value = false;
      },
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.lightBlueAccent,
        textStyle: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      child: ValueListenableBuilder<bool>(
        valueListenable: _isLoading,
        builder: (context, isLoading, _) {
          return isLoading
              ? const CircularProgressIndicator(
            color: Colors.white,
          )
              : Text(
              semanticsLabel: widget.text,
              widget.text);
        },
      ),
    );
  }
}
