import 'package:flutter/cupertino.dart';

class Country {
  int id;
  String e164_cc;
  String iso2_cc;
  String name;
  String example;
  String display_name;
  String full_example_with_plus_sign;
  String display_name_no_e164_cc;
  String e164_key;

  Country({
    this.id,
    @required this.e164_cc,
    @required this.iso2_cc,
    this.name,
    this.example,
    this.display_name,
    this.full_example_with_plus_sign,
    this.display_name_no_e164_cc,
    this.e164_key,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return new Country(
        e164_cc: json['e164_cc'] as String,
        iso2_cc: json['iso2_cc'] as String,
        name: json['name'] as String,
        example: json['example'] as String,
        display_name: json['display_name'] as String,
        full_example_with_plus_sign:
            json['full_example_with_plus_sign'] as String,
        display_name_no_e164_cc: json['display_name_no_e164_cc'] as String,
        e164_key: json['e164_key'] as String);
  }
}
