import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<DateTime> dateTimePicker(BuildContext context) async {
  return await showModalBottomSheet<DateTime>(
    context: context,
    builder: (context) {
      DateTime tempPickedDate = DateTime.now();
      return Container(
        height: 250,
        child: Column(
          children: <Widget>[
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  CupertinoButton(
                    child: Text("cancel"),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  CupertinoButton(
                    child: Text("done"),
                    onPressed: () => Navigator.of(context).pop(tempPickedDate),
                  ),
                ],
              ),
            ),
            Divider(
              height: 0,
              thickness: 1,
            ),
            Expanded(
              child: Container(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  onDateTimeChanged: (DateTime dateTime) {
                    tempPickedDate = dateTime;
                  },
                  maximumDate: DateTime.now(),
                  initialDateTime: DateTime(DateTime.now().year - 16,
                      DateTime.now().month, DateTime.now().day),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
