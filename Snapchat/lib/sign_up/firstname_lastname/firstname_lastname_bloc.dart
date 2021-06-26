import 'package:task1/models/user.dart';
import 'package:task1/utils/validator_repository.dart';
import 'firstname_lastname_event.dart';
import 'firstname_lastname_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FirstnameLastnameBloc
    extends Bloc<FirstnameLastnameEvent, FirstnameLastnameState> {
  FirstnameLastnameBloc(UserValidorRepository validator)
      : super(FirstnameLastnameInitialState()) {
    _user = new User();
    _validator = validator;
  }
  UserValidorRepository _validator;

  User _user;
  User get user => _user;

  @override
  Stream<FirstnameLastnameState> mapEventToState(
      FirstnameLastnameEvent event) async* {
    if (event is SignupButtonFirstnameLastnameValidationEvent) {
      yield* mapEventFormValidateToState(event);
    }
  }

  Stream<FirstnameLastnameState> mapEventFormValidateToState(
      SignupButtonFirstnameLastnameValidationEvent event) async* {
    String firstname = event.firstname;
    String lastname = event.lastname;

    if (!_validator.isValidFirstname(firstname)) {
      yield FirstnameInvalid();
    } else if (!_validator.isValidLastname(lastname)) {
      yield LastnameInvalid();
    } else {
      yield FormIsValidate(firstname, lastname);
    }
  }
}
