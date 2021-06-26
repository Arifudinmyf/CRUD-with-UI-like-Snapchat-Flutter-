import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:task1/models/user.dart';

abstract class UsernameEvent extends Equatable {
  const UsernameEvent();
}

class SignupButtonUsernameValidationEvent extends UsernameEvent {
  final String username;

  const SignupButtonUsernameValidationEvent({@required this.username});

  @override
  List<Object> get props => [username];
}

class CheckUsernameInDBEvent extends UsernameEvent {
  final User user;
  const CheckUsernameInDBEvent({@required this.user});
  @override
  List<Object> get props => [];
}
