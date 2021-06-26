import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:task1/models/user.dart';

abstract class EmailOrPhoneEvent extends Equatable {
  const EmailOrPhoneEvent();
}

class SignupButtonEmailValidationEvent extends EmailOrPhoneEvent {
  final String email;

  const SignupButtonEmailValidationEvent({@required this.email});

  @override
  List<Object> get props => [email];
}

class CheckEmailInDBEvent extends EmailOrPhoneEvent {
  final User user;
  const CheckEmailInDBEvent({@required this.user});
  @override
  List<Object> get props => [];
}

class SignupButtonPhoneValidationEvent extends EmailOrPhoneEvent {
  final String phone;

  const SignupButtonPhoneValidationEvent({@required this.phone});

  @override
  List<Object> get props => [phone];
}

class CheckPhoneInDBEvent extends EmailOrPhoneEvent {
  final User user;
  const CheckPhoneInDBEvent({@required this.user});
  @override
  List<Object> get props => [];
}

class ChangingScreenEvent extends EmailOrPhoneEvent {
  final bool isEmailScreen;
  const ChangingScreenEvent({@required this.isEmailScreen});
  @override
  List<Object> get props => [isEmailScreen];
}

class FinalValidationEvent extends EmailOrPhoneEvent {
  final User user;
  FinalValidationEvent(this.user);
  @override
  List<Object> get props => [];
}
