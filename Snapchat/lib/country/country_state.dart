import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';
import '../models/country.dart';

abstract class CountryState extends Equatable {}

class CountryInitialState extends CountryState {
  @override
  List<Object> get props => [];
}

class CountryLoadingState extends CountryState {
  final String key = Uuid().v4();
  @override
  List<Object> get props => [key];
}

class CountryLoadedState extends CountryState {
  final String key = Uuid().v4();

  final List<Country> countries;

  CountryLoadedState({@required this.countries});

  List<Object> get props => [countries, key];
}

class CountryErrorState extends CountryState {
  final String message;
  CountryErrorState({@required this.message});
  @override
  List<Object> get props => [message];
}

class CountrySearchBoxChangedState extends CountryState {
  final String key = Uuid().v4();
  final List<Country> countries;
  CountrySearchBoxChangedState({@required this.countries});
  @override
  List<Object> get props => [key];
}
