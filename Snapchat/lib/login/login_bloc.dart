import 'package:task1/Repositories/user_repository.dart';
import 'package:task1/models/user.dart';
import 'package:task1/utils/validator_repository.dart';
import 'login_event.dart';
import 'login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc(UserValidorRepository validator, UserRepository userRepository)
      : super(LoginInitialState()) {
    _validator = validator;
    _userRepository = userRepository;
  }
  User _user;
  User get user => _user;
  UserValidorRepository _validator;
  UserRepository _userRepository;
  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is SignupButtonLoginValidationEvent) {
      yield* mapEventFormValidateToState(event);
    }
    if (event is IdenitficationEvent) {
      yield* mapEventIdentificationToState(event);
    }
  }

  Stream<LoginState> mapEventIdentificationToState(
      IdenitficationEvent event) async* {
    String login = event.login;
    String password = event.password;
    _user = (await _userRepository.identification_realmDB(login, password));
    if (_user == null) {
      yield FailIdentificationState();
    } else {
      yield SuccessIdentificationState();
    }
  }

  Stream<LoginState> mapEventFormValidateToState(
      SignupButtonLoginValidationEvent event) async* {
    String login = event.login;
    String password = event.password;

    if (login.isEmpty) {
      yield LoginInvalid();
    } else if (!_validator.isValidPassword(password)) {
      yield PasswordInvalid();
    } else {
      yield FormIsValidate(login, password);
    }
  }
}
