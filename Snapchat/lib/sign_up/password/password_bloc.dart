import 'package:task1/utils/validator_repository.dart';

import 'password_event.dart';
import 'password_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PasswordBloc extends Bloc<PasswordEvent, PasswordState> {
  PasswordBloc(UserValidorRepository validator)
      : super(PasswordInitialState()) {
    _validator = validator;
  }
  UserValidorRepository _validator;

  @override
  Stream<PasswordState> mapEventToState(PasswordEvent event) async* {
    if (event is SignupButtonPasswordValidationEvent) {
      yield* mapEventFormValidateToState(event);
    }
  }

  Stream<PasswordState> mapEventFormValidateToState(
      SignupButtonPasswordValidationEvent event) async* {
    String password = event.password;

    if (!_validator.isValidPassword(password)) {
      yield PasswordInvalid();
    } else {
      yield FormIsValidate(password);
    }
  }
}
