import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:task1/models/user.dart';
import 'package:task1/views/modify/modify_screen.dart';

abstract class ModifyEvent extends Equatable {}

class ValidationEvent extends ModifyEvent {
  final User user;
  final InputType inputType;

  ValidationEvent({
    @required this.user,
    @required this.inputType,
  });
  @override
  List<Object> get props => [inputType];
}

class FinalValidationEvent extends ModifyEvent {
  final User user;
  FinalValidationEvent({@required this.user});
  @override
  List<Object> get props => [];
}

class UpdateEvent extends ModifyEvent {
  final User user;
  final String username;
  UpdateEvent({@required this.user, this.username});
  @override
  List<Object> get props => [];
}
