import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitialState extends LoginState {}

class FormIsValidate extends LoginState {
  final String login;
  final String password;

  FormIsValidate(this.login, this.password);
  @override
  List<Object> get props => [login, password];
}

class LoginInvalid extends LoginState {
  @override
  List<Object> get props => [];
}

class PasswordInvalid extends LoginState {
  @override
  List<Object> get props => [];
}

class FailIdentificationState extends LoginState {
  @override
  List<Object> get props => [];
}

class SuccessIdentificationState extends LoginState {
  final String key = Uuid().v4();
  @override
  List<Object> get props => [key];
}
