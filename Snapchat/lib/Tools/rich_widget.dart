import 'package:flutter/material.dart';
import 'package:task1/utils/string_extensions.dart';

class RichWidget extends StatelessWidget {
  RichWidget({@required this.title, this.color = Colors.black87});
  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: title.localizeString(context),
        style: TextStyle(
          color: color,
          fontSize: 15,
        ),
      ),
    );
  }
}
