import 'package:flutter/material.dart';

Widget rectangularRaisedButton(
    {String label,
    Color color,
    @required final Function() onPress,
    obscureText = false}) {
  return SizedBox(
      width: double.infinity,
      height: 60,
      child: TextButton(
        onPressed: () {
          onPress();
        },
        child: Text(
          label,
          style: TextStyle(
            fontSize: 25.0,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(primary: color),
      ));
}

//Circular Button
class RoundButton extends StatelessWidget {
  final Color color;
  final Function() onPress;
  final String text;

  RoundButton({
    this.color,
    @required this.onPress,
    this.text,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPress();
      },
      child: Container(
        height: 50,
        width: 260,
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(50)),
        child: Center(
          child: Text(text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              )),
        ),
      ),
    );
  }
}
