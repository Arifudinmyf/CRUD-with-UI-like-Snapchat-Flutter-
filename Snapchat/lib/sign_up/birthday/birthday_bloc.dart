import 'package:task1/utils/validator_repository.dart';
import 'birthday_event.dart';
import 'birthday_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BirthdayBloc extends Bloc<BirthdayEvent, BirthdayState> {
  BirthdayBloc(UserValidorRepository validator)
      : super(BirthdayInitialState()) {
    _validator = validator;
  }
  UserValidorRepository _validator;

  @override
  Stream<BirthdayState> mapEventToState(BirthdayEvent event) async* {
    if (event is SignupButtonBirthdayValidationEvent) {
      yield* mapEventFormValidateToState(event);
    }
  }

  Stream<BirthdayState> mapEventFormValidateToState(
      SignupButtonBirthdayValidationEvent event) async* {
    String birthday = event.birthday;
    if (!_validator.isValidBirthday(birthday)) {
      yield BirthdayInvalid();
    } else {
      yield FormIsValidate(birthday);
    }
  }
}
