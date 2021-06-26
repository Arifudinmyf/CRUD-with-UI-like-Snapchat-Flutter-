import 'package:equatable/equatable.dart';

abstract class AllUsersEvent extends Equatable {
  const AllUsersEvent();
}

class GetAllUsersEvent extends AllUsersEvent {
  @override
  List<Object> get props => [];
}
