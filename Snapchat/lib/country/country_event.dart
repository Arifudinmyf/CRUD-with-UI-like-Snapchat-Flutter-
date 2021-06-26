import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class CountryEvent extends Equatable {}

class FetchCountriesEvent extends CountryEvent {
  @override
  List<Object> get props => [];
}

class SearchEvent extends CountryEvent {
  final String query;
  SearchEvent({@required this.query});
  @override
  List<Object> get props => [];
}
