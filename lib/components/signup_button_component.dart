import 'package:flutter/material.dart';
import 'package:gas_check_app/screens/base_screen.dart';

class SingUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ButtonStyle style =
      ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));

    return SizedBox(
      width: 250,
      height: 60,
      child: ElevatedButton(
          child: Text(
            'Cadastrar cliente',
            style: TextStyle(fontSize: 20),
          ),
          style: style,
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => BaseScreen(title: 'Home Page',)));
          }),
    );
  }
}
