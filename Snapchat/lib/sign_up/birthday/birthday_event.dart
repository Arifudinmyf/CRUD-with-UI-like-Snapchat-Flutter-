import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class BirthdayEvent extends Equatable {
  const BirthdayEvent();
}

class SignupButtonBirthdayValidationEvent extends BirthdayEvent {
  final String birthday;
  const SignupButtonBirthdayValidationEvent({@required this.birthday});
  @override
  List<Object> get props => [birthday];
}
