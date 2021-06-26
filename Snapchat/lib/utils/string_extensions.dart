import 'package:flutter/material.dart';
import '../app_localizations.dart';

extension ST on String {
  String localizeString(BuildContext context) {
    return AppLocalizations.of(context).translate(this);
  }
}
