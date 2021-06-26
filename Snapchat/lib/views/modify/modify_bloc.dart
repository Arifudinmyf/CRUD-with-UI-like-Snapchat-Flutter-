import 'package:task1/Repositories/user_repository.dart';
import 'package:task1/models/user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task1/utils/validator_repository.dart';
import 'package:task1/views/modify/modify_screen.dart';
import 'package:task1/views/modify/modify_state.dart';
import 'modify_event.dart';
import 'modify_state.dart';

class ModifyBloc extends Bloc<ModifyEvent, ModifyState> {
  ModifyBloc(UserValidorRepository validator, UserRepository userRepository)
      : super(ModifyInitialState()) {
    _user = new User();
    _validator = validator;
    _userRepository = userRepository;
  }
  UserRepository _userRepository;
  User _user;
  User get user => _user;
  UserValidorRepository _validator;

  @override
  Stream<ModifyState> mapEventToState(ModifyEvent event) async* {
    if (event is ValidationEvent) {
      yield* mapEventFormValidateToState(event);
    }
    if (event is FinalValidationEvent) {
      yield* mapEventFinalValidationToState(event);
    }
    if (event is UpdateEvent) {
      yield* mapEventUpdateToState(event);
    }
  }

  Stream<ModifyState> mapEventCheckPhoneToState(User user) async* {
    bool isUserExists = await _userRepository.checkMobilePhone(user);
    if (isUserExists)
      yield FormInvalid(
          invalid_error_massege: "user_is_exists", inputType: InputType.phone);
    else
      yield FormIsValidate();
  }

  Stream<ModifyState> mapEventCheckEmailToState(User user) async* {
    bool isUserExists = await _userRepository.checkEmail(user);
    if (isUserExists)
      yield FormInvalid(
          invalid_error_massege: "user_is_exists", inputType: InputType.email);
    else
      yield FormIsValidate();
  }

  Stream<ModifyState> mapEventCheckUsernameToState(User user) async* {
    bool isUserExists = await _userRepository.checkUsername(user);
    if (isUserExists)
      yield FormInvalid(
          invalid_error_massege: "user_is_exists",
          inputType: InputType.username);
    else
      yield FormIsValidate();
  }

  Stream<ModifyState> mapEventCheckUserToState(User user) async* {
    bool isPhoneExists = await _userRepository.checkMobilePhone(user);
    bool isEmailExists = await _userRepository.checkEmail(user);
    bool isUsernameExists = await _userRepository.checkUsername(user);
    if (isPhoneExists)
      yield FormIsFinalInvalid(invalid_error_massege: "mobile_number");
    else if (isEmailExists)
      yield FormIsFinalInvalid(invalid_error_massege: "email");
    else if (isUsernameExists)
      yield FormIsFinalInvalid(invalid_error_massege: "username");
    else
      yield UserWithThisDataNotExists();
  }

  Stream<ModifyState> mapEventUpdateToState(UpdateEvent event) async* {
    await _userRepository.update(user: event.user, username: event.username);
    yield UserIsUpdated();
  }

  Stream<ModifyState> mapEventFinalValidationToState(
      FinalValidationEvent event) async* {
    bool isValidForm = true;
    bool isValidEmail = true;
    bool isValidPhone = true;
    String invalid_error_massege = "";
    if (event.user.email == null ||
        !_validator.isValidEmail(event.user.email)) {
      invalid_error_massege = "email";
      isValidEmail = false;
    }
    if (event.user.mobilePhone == null ||
        !_validator.isValidPhone(event.user.mobilePhone)) {
      invalid_error_massege = "mobile_number";
      isValidPhone = false;
    }
    if (event.user.password == null ||
        !_validator.isValidPassword(event.user.password)) {
      invalid_error_massege = "password";

      isValidForm = false;
    }
    if (event.user.username == null ||
        !_validator.isValidUsername(event.user.username)) {
      invalid_error_massege = "username";

      isValidForm = false;
    }
    if (event.user.birthday == null ||
        !_validator.isValidBirthday(event.user.birthday)) {
      invalid_error_massege = "birthday";

      isValidForm = false;
    }

    if (event.user.lastName == null ||
        !_validator.isValidLastname(event.user.lastName)) {
      invalid_error_massege = "lastname";
      isValidForm = false;
    }
    if (event.user.firstName == null ||
        !_validator.isValidFirstname(event.user.firstName)) {
      invalid_error_massege = "firstname";
      isValidForm = false;
    }

    if (event.user.mobilePhone != null &&
        isValidPhone == false &&
        event.user.mobilePhone.isNotEmpty) {
      isValidForm = false;
    }
    if (event.user.email != null &&
        isValidEmail == false &&
        event.user.email.isNotEmpty) {
      isValidForm = false;
    }

    if (isValidEmail == false && isValidPhone == false) {
      isValidForm = false;
    }
    if (isValidForm == false) {
      yield FormIsFinalInvalid(invalid_error_massege: invalid_error_massege);
    } else {
      yield* mapEventCheckUserToState(event.user);
    }
  }

  Stream<ModifyState> mapEventFormValidateToState(
      ValidationEvent event) async* {
    InputType inputType = event.inputType;
    User value = event.user;
    switch (inputType) {
      case InputType.firstname:
        if (!_validator.isValidFirstname(value.firstName))
          yield FormInvalid(
              invalid_error_massege: "firstname",
              inputType: InputType.firstname);
        else
          yield FormIsValidate();
        break;
      case InputType.lastname:
        if (!_validator.isValidLastname(value.lastName))
          yield FormInvalid(
              invalid_error_massege: "lastname", inputType: InputType.lastname);
        else
          yield FormIsValidate();
        break;
      case InputType.birthday:
        if (!_validator.isValidBirthday(value.birthday))
          yield FormInvalid(
              invalid_error_massege: "birthday", inputType: InputType.birthday);
        else
          yield FormIsValidate();
        break;
      case InputType.username:
        if (!_validator.isValidUsername(value.username))
          yield FormInvalid(
              invalid_error_massege: "username", inputType: InputType.username);
        else
          yield* mapEventCheckUsernameToState(value);
        break;
      case InputType.password:
        if (!_validator.isValidPassword(value.password))
          yield FormInvalid(
              invalid_error_massege: "password", inputType: InputType.password);
        else
          yield FormIsValidate();
        break;
      case InputType.email:
        if (!_validator.isValidEmail(value.email))
          yield FormInvalid(
              invalid_error_massege: "email", inputType: InputType.email);
        else
          yield* mapEventCheckEmailToState(value);
        break;
      case InputType.phone:
        if (!_validator.isValidPhone(value.mobilePhone))
          yield FormInvalid(
              invalid_error_massege: "mobile_number",
              inputType: InputType.phone);
        else
          yield* mapEventCheckPhoneToState(value);
        break;
      default:
        yield FormIsValidate();
    }
  }
}
