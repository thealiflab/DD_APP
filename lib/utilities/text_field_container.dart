import 'package:flutter/material.dart';

class TextFieldContainer extends StatelessWidget {
  final Widget textField;
  const TextFieldContainer({
    @required this.textField,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 30,
          vertical: 10,
        ),
        child: textField,
      ),
    );
  }
}
