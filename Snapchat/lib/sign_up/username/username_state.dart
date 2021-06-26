import 'package:equatable/equatable.dart';

abstract class UsernameState extends Equatable {
  const UsernameState();

  @override
  List<Object> get props => [];
}

class UsernameInitialState extends UsernameState {}

class FormIsValidate extends UsernameState {
  final String username;

  FormIsValidate(this.username);
  @override
  List<Object> get props => [username];
}

class UsernameInvalid extends UsernameState {
  @override
  List<Object> get props => [];
}

class UserWtihThisUsernameIsExistsState extends UsernameState {
  @override
  List<Object> get props => [];
}

class UserWithThisUsernameIsNotExistsState extends UsernameState {
  @override
  List<Object> get props => [];
}
