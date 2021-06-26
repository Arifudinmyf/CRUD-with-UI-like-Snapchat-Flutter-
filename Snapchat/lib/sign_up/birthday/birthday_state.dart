import 'package:equatable/equatable.dart';

abstract class BirthdayState extends Equatable {
  const BirthdayState();

  @override
  List<Object> get props => [];
}

class BirthdayInitialState extends BirthdayState {}

class FormIsValidate extends BirthdayState {
  final String birthday;

  FormIsValidate(this.birthday);
  @override
  List<Object> get props => [birthday];
}

class BirthdayInvalid extends BirthdayState {
  @override
  List<Object> get props => [];
}
