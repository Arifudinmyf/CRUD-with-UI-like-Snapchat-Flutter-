import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';
import 'package:bson/bson.dart' show ObjectId;

abstract class EmailOrPhoneState extends Equatable {
  const EmailOrPhoneState();

  @override
  List<Object> get props => [];
}

class EmailOrPhoneInitialState extends EmailOrPhoneState {}

class FormIsValidate extends EmailOrPhoneState {
  final String email_or_phone;

  FormIsValidate(this.email_or_phone);
  @override
  List<Object> get props => [email_or_phone];
}

class EmailInvalid extends EmailOrPhoneState {
  @override
  List<Object> get props => [];
}

class PhoneInvalid extends EmailOrPhoneState {
  @override
  List<Object> get props => [];
}

class UserWtihThisEmailOrPhoneIsExistsState extends EmailOrPhoneState {
  @override
  List<Object> get props => [];
}

class UserWithThisEmailOrPhoneIsNotExistsState extends EmailOrPhoneState {
  @override
  List<Object> get props => [];
}

class UserExists extends EmailOrPhoneState {
  final String error_massege;
  UserExists(this.error_massege);
  @override
  List<Object> get props => [];
}

class EmailScreenVisibleState extends EmailOrPhoneState {
  final String key = Uuid().v4();
  @override
  List<Object> get props => [key];
}

class PhoneScreenVisibleState extends EmailOrPhoneState {
  final String key = Uuid().v4();
  @override
  List<Object> get props => [key];
}

class UserIsAddedSuccessfulyState extends EmailOrPhoneState {
  final String key = Uuid().v4();
  final ObjectId id;
  UserIsAddedSuccessfulyState(this.id);
  @override
  List<Object> get props => [key];
}
