import 'package:flutter/material.dart';

class BotonAzul extends StatelessWidget {
  final String text;
  final Function() onPressed;

  const BotonAzul({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
            // Estados específicos
            if (states.contains(MaterialState.pressed)) {
              // Color cuando el botón está presionado
              return Colors.blue.withOpacity(0.5);
            } else if (states.contains(MaterialState.disabled)) {
              // Color cuando el botón está deshabilitado
              return Colors.grey;
            }
            // Color predeterminado
            return Colors.blue;
          },
        ),
      ),
      onPressed: this.onPressed,
      child: Container(
          width: double.infinity,
          height: 25,
          child: Center(
              child: Text(
            this.text,
            style: TextStyle(color: Colors.white, fontSize: 17),
          ))),
    );
  }
}
