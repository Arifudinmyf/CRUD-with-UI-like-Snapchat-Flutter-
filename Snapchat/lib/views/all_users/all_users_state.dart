import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:task1/models/user.dart';
import 'package:uuid/uuid.dart';

abstract class AllUsersState extends Equatable {
  const AllUsersState();

  @override
  List<Object> get props => [];
}

class AllUsersInitialState extends AllUsersState {}

class AllUsersLoadedState extends AllUsersState {
  final String key = Uuid().v4();
  final List<User> users;
  AllUsersLoadedState({@required this.users});
  @override
  List<Object> get props => [users];
}

class AllUsersLoadingState extends AllUsersState {
  final String key = Uuid().v4();
  @override
  List<Object> get props => [key];
}
