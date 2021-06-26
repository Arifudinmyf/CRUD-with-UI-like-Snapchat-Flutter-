import 'package:country_codes/country_codes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task1/Repositories/user_repository.dart';
import 'package:task1/models/country.dart';
import 'package:task1/models/user.dart';
import 'package:task1/utils/validator_repository.dart';
import 'email_or_phone_event.dart';
import 'email_or_phone_state.dart';
import 'package:bson/bson.dart' show ObjectId;

class EmailOrPhoneBloc extends Bloc<EmailOrPhoneEvent, EmailOrPhoneState> {
  EmailOrPhoneBloc(
      UserValidorRepository validator, UserRepository userRepository)
      : super(EmailOrPhoneInitialState()) {
    _validator = validator;
    _userRepository = userRepository;
  }
  UserValidorRepository _validator;
  UserRepository _userRepository;

  @override
  Stream<EmailOrPhoneState> mapEventToState(EmailOrPhoneEvent event) async* {
    if (event is SignupButtonEmailValidationEvent) {
      yield* mapEventEmailValidateToState(event);
    }
    if (event is CheckEmailInDBEvent) {
      yield* mapEventCheckEmailFromDBToState(event);
    }
    if (event is SignupButtonPhoneValidationEvent) {
      yield* mapEventPhoneValidateToState(event);
    }
    if (event is CheckPhoneInDBEvent) {
      yield* mapEventCheckPhoneFromDBToState(event);
    }
    if (event is ChangingScreenEvent) {
      yield* mapEventChangeScreenToState(event);
    }
    if (event is FinalValidationEvent) {
      yield* mapEventFinalValidationToState(event);
    }
  }

  Stream<EmailOrPhoneState> mapEventFinalValidationToState(
      FinalValidationEvent event) async* {
    event.user.id = null;
    bool isEmailExists = await _userRepository.checkEmail(event.user);
    bool isPhoneExists = await _userRepository.checkMobilePhone(event.user);
    bool isUsernameExists = await _userRepository.checkUsername(event.user);
    if (isEmailExists) {
      String _error_massege = "email";
      yield UserExists(_error_massege);
    } else if (isPhoneExists) {
      String _error_massege = "mobile_number";
      yield UserExists(_error_massege);
    } else if (isUsernameExists) {
      String _error_massege = "username";
      yield UserExists(_error_massege);
    } else {
      yield* mapEventAddUserToState(event.user);
    }
  }

  Stream<EmailOrPhoneState> mapEventAddUserToState(User user) async* {
    ObjectId _id = await _userRepository.insertUserToDB(user);
    yield UserIsAddedSuccessfulyState(_id);
  }

  Stream<EmailOrPhoneState> mapEventChangeScreenToState(
      ChangingScreenEvent event) async* {
    if (event.isEmailScreen) {
      yield EmailScreenVisibleState();
    } else {
      yield PhoneScreenVisibleState();
    }
  }

  Stream<EmailOrPhoneState> mapEventCheckPhoneFromDBToState(
      CheckPhoneInDBEvent event) async* {
    UserRepository _userRepository = new UserRepository();
    bool isPhoneExists = await _userRepository.checkMobilePhone(event.user);
    if (isPhoneExists) {
      yield UserWtihThisEmailOrPhoneIsExistsState();
    } else {
      yield UserWithThisEmailOrPhoneIsNotExistsState();
    }
  }

  Stream<EmailOrPhoneState> mapEventPhoneValidateToState(
      SignupButtonPhoneValidationEvent event) async* {
    String phone = event.phone;

    if (!_validator.isValidPhone(phone)) {
      yield PhoneInvalid();
    } else {
      yield FormIsValidate(phone);
    }
  }

  Stream<EmailOrPhoneState> mapEventCheckEmailFromDBToState(
      CheckEmailInDBEvent event) async* {
    UserRepository _userRepository = new UserRepository();
    bool isEmailExists = await _userRepository.checkEmail(event.user);
    if (isEmailExists) {
      yield UserWtihThisEmailOrPhoneIsExistsState();
    } else {
      yield UserWithThisEmailOrPhoneIsNotExistsState();
    }
  }

  Stream<EmailOrPhoneState> mapEventEmailValidateToState(
      SignupButtonEmailValidationEvent event) async* {
    String email = event.email;

    if (!_validator.isValidEmail(email)) {
      yield EmailInvalid();
    } else {
      yield FormIsValidate(email);
    }
  }

  Country initilizeCountry() {
    final CountryDetails details = CountryCodes.detailsForLocale();
    Country country = Country(e164_cc: '', iso2_cc: '');
    country.e164_cc = details.dialCode.substring(1);
    country.iso2_cc = details.alpha2Code;
    return country;
  }
}
