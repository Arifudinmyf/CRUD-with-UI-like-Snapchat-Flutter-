import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

class SignupButtonLoginValidationEvent extends LoginEvent {
  final String login;
  final String password;

  const SignupButtonLoginValidationEvent(
      {@required this.login, @required this.password});

  @override
  List<Object> get props => [login, password];
}

class IdenitficationEvent extends LoginEvent {
  final String login;
  final String password;

  const IdenitficationEvent({@required this.login, @required this.password});

  @override
  List<Object> get props => [login, password];
}
