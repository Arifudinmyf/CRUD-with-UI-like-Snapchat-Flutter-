import 'package:equatable/equatable.dart';

abstract class FirstnameLastnameState extends Equatable {
  const FirstnameLastnameState();

  @override
  List<Object> get props => [];
}

class FirstnameLastnameInitialState extends FirstnameLastnameState {}

class FormIsValidate extends FirstnameLastnameState {
  final String firstName;
  final String lastName;

  FormIsValidate(this.firstName, this.lastName);
  @override
  List<Object> get props => [firstName, lastName];
}

class FirstnameInvalid extends FirstnameLastnameState {
  @override
  List<Object> get props => [];
}

class LastnameInvalid extends FirstnameLastnameState {
  @override
  List<Object> get props => [];
}
