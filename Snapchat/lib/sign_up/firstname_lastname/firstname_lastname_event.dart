import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class FirstnameLastnameEvent extends Equatable {
  const FirstnameLastnameEvent();
}

class SignupButtonFirstnameLastnameValidationEvent
    extends FirstnameLastnameEvent {
  final String firstname;
  final String lastname;

  const SignupButtonFirstnameLastnameValidationEvent(
      {@required this.firstname, @required this.lastname});

  @override
  List<Object> get props => [firstname, lastname];
}
