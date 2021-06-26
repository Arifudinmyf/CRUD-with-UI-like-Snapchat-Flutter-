import 'package:equatable/equatable.dart';

abstract class PasswordState extends Equatable {
  const PasswordState();

  @override
  List<Object> get props => [];
}

class PasswordInitialState extends PasswordState {}

class FormIsValidate extends PasswordState {
  final String password;

  FormIsValidate(this.password);
  @override
  List<Object> get props => [password];
}

class PasswordInvalid extends PasswordState {
  @override
  List<Object> get props => [];
}
