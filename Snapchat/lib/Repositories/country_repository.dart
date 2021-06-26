import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_mongodb_realm/flutter_mongo_realm.dart';
import 'package:task1/models/country.dart';
import 'package:http/http.dart' as http;

class CountryRepository {
  final MongoRealmClient client = MongoRealmClient();

  List<Country> _countries = [];
  var collection;
  CountryRepository() {
    collection = client.getDatabase("SnapchatDB").getCollection("Country");
  }

//load countries from assets folder

  Future<List<Country>> loadCountry() async {
    String jsonString = await _loadACountryAsset();
    List<dynamic> data = json.decode(jsonString);
    data.forEach((element) {
      Country country = Country.fromJson(element);
      _countries.add(country);
    });

    return _countries;
  }

// load countries from api

  Future<List<Country>> fetchCountries() async {
    final response = await _loadCountryFromAPI();
    if (response.statusCode == 200) {
      List<dynamic> list = json.decode(response.body) as List<dynamic>;
      _countries = list.map((model) => Country.fromJson(model)).toList();
      return _countries;
    }
    throw Exception("Request API Error");
  }

  //search country

  List<Country> filterSearchResults(String query) {
    if (query.isNotEmpty) {
      return List<Country>.from(_countries.where(
          (item) => item.name.toLowerCase().contains(query.toLowerCase())));
    } else {
      return _countries;
    }
  }

//Get countries from database

  Future<List<Country>> getCountries() async {
    int quantity = await collection.count();
    if (quantity == 0) {
      _countries = await fetchCountries();
      insertAllCountries();
      return _countries;
    }
    var docs = await collection.find();
    var countries = await _fromMongoDocumentToCountry(docs);
    return countries;
  }

  void insertAllCountries() {
    _countries.forEach((element) {
      _insertCountrytoDB(element);
    });
  }

  Future<void> _insertCountrytoDB(Country country) async {
    collection.insertOne(MongoDocument({
      "e164_cc": country.e164_cc,
      "iso2_cc": country.iso2_cc,
      "name": country.name,
      "example": country.example,
      "display_name": country.display_name,
      "full_example_with_plus_sign": country.full_example_with_plus_sign,
      "display_name_no_e164_cc": country.display_name_no_e164_cc,
      "e164_key": country.e164_key,
    }));
  }

  Future<String> _loadACountryAsset() async {
    return await rootBundle
        .loadString('assets/international_phone_codes/country-codes.json');
  }

  Future<List<Country>> _fromMongoDocumentToCountry(
      List<MongoDocument> docs) async {
    List<Country> countries = [];
    docs.forEach((element) {
      Country country = new Country(e164_cc: '', iso2_cc: '');
      country.e164_cc = element.get("e164_cc");
      country.iso2_cc = element.get("iso2_cc");
      country.name = element.get("name");
      country.example = element.get("example");
      country.display_name = element.get("display_name");
      country.full_example_with_plus_sign =
          element.get("full_example_with_plus_sign");
      country.display_name_no_e164_cc = element.get("display_name_no_e164_cc");
      country.e164_key = element.get("e164_key");
      countries.add(country);
    });
    _countries = countries;
    return countries;
  }

  Future<http.Response> _loadCountryFromAPI() async {
    return await http.get(Uri.parse(
        'https://drive.google.com/uc?id=1SuvADk8EeyXU0vjQ159W9Kuxw4Mi_dGA&exprt=download'));
  }
}
