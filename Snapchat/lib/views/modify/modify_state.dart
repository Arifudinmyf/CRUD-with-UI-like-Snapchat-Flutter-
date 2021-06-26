import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:task1/views/modify/modify_screen.dart';
import 'package:uuid/uuid.dart';

abstract class ModifyState extends Equatable {
  const ModifyState();

  @override
  List<Object> get props => [];
}

class ModifyInitialState extends ModifyState {}

class FormIsValidate extends ModifyState {
  final String key = Uuid().v4();
  @override
  List<Object> get props => [key];
}

class FormIsValidatedForUpdate extends ModifyState {}

class FormIsFinalInvalid extends ModifyState {
  final String invalid_error_massege;
  FormIsFinalInvalid({@required this.invalid_error_massege});
  final String key = Uuid().v4();
  @override
  List<Object> get props => [key];
}

class FormInvalid extends ModifyState {
  final String key = Uuid().v4();
  final InputType inputType;
  FormInvalid({@required this.invalid_error_massege, @required this.inputType});
  final String invalid_error_massege;
  @override
  List<Object> get props => [inputType, key];
}

class UserIsUpdated extends ModifyState {
  @override
  List<Object> get props => [];
}

class UserWithThisDataNotExists extends ModifyState {
  @override
  List<Object> get props => [];
}
