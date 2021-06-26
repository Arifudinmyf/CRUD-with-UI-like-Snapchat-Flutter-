import 'package:task1/Repositories/user_repository.dart';
import 'package:task1/models/user.dart';
import 'all_users_event.dart';
import 'all_users_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AllUsersBloc extends Bloc<AllUsersEvent, AllUsersState> {
  AllUsersBloc(UserRepository userRepository) : super(AllUsersInitialState()) {
    _userRepository = userRepository;
  }
  UserRepository _userRepository;
  User _user = null;
  User get user => _user;
  @override
  Stream<AllUsersState> mapEventToState(AllUsersEvent event) async* {
    if (event is GetAllUsersEvent) {
      yield* mapEvenGetAllUsersToState(event);
    }
  }

  Stream<AllUsersState> mapEvenGetAllUsersToState(
      GetAllUsersEvent event) async* {
    List<User> _users = [];
    yield AllUsersLoadingState();
    _users = await _userRepository.getUsersFromDB();
    yield AllUsersLoadedState(users: _users);
  }
}
