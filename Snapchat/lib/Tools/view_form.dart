import 'package:flutter/material.dart';

class ViewUser extends StatelessWidget {
  final String head;
  final String val;
  ViewUser({@required this.head, @required this.val});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(
        head,
        style: TextStyle(
          color: Colors.black87,
          fontSize: 20,
        ),
      ),
      Padding(
        padding: EdgeInsets.only(top: 5, bottom: 20),
        child: Text(
          val == null ? " " : val,
          style: TextStyle(
            color: Colors.blue,
          ),
        ),
      ),
    ]);
  }
}
