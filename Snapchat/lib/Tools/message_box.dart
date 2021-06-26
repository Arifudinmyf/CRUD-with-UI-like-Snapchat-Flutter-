import 'package:flutter/material.dart';
import 'package:task1/utils/string_extensions.dart';

void messageBox(BuildContext context, String massege) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: new Text("error".localizeString(context)),
        content: new Text(massege),
        actions: <Widget>[
          new TextButton(
            child: new Text("close".localizeString(context)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
