import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class PasswordEvent extends Equatable {
  const PasswordEvent();
}

class SignupButtonPasswordValidationEvent extends PasswordEvent {
  final String password;

  const SignupButtonPasswordValidationEvent({@required this.password});

  @override
  List<Object> get props => [password];
}
