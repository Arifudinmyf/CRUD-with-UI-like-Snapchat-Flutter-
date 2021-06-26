import 'package:flutter/material.dart';
import 'package:task1/utils/string_extensions.dart';

class Header extends StatelessWidget {
  Header({@required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(bottom: 15),
        child: Text(
          title.localizeString(context),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black87,
            fontSize: 25,
          ),
        ));
  }
}
