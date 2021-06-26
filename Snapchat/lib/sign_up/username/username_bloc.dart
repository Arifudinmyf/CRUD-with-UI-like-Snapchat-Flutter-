import 'package:task1/Repositories/user_repository.dart';
import 'package:task1/utils/validator_repository.dart';
import 'username_event.dart';
import 'username_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UsernameBloc extends Bloc<UsernameEvent, UsernameState> {
  UsernameBloc(UserValidorRepository validator)
      : super(UsernameInitialState()) {
    _validator = validator;
  }
  UserValidorRepository _validator;

  @override
  Stream<UsernameState> mapEventToState(UsernameEvent event) async* {
    if (event is SignupButtonUsernameValidationEvent) {
      yield* mapEventFormValidateToState(event);
    }
    if (event is CheckUsernameInDBEvent) {
      yield* mapEventCheckUsernameFromDBToState(event);
    }
  }

  Stream<UsernameState> mapEventCheckUsernameFromDBToState(
      CheckUsernameInDBEvent event) async* {
    UserRepository _userRepository = new UserRepository();
    bool isUsernameExists = await _userRepository.checkUsername(event.user);
    if (isUsernameExists) {
      yield UserWtihThisUsernameIsExistsState();
    } else {
      yield UserWithThisUsernameIsNotExistsState();
    }
  }

  Stream<UsernameState> mapEventFormValidateToState(
      SignupButtonUsernameValidationEvent event) async* {
    String username = event.username;

    if (!_validator.isValidUsername(username)) {
      yield UsernameInvalid();
    } else {
      yield FormIsValidate(username);
    }
  }
}
