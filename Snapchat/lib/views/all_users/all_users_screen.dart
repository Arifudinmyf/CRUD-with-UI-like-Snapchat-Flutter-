import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:task1/Repositories/user_repository.dart';
import 'package:task1/models/user.dart';
import 'package:task1/tools/buttons.dart';
import 'package:task1/tools/loading_animation.dart';
import 'package:task1/views/show_user_data_screen.dart';
import 'package:task1/utils/string_extensions.dart';
import 'all_users_bloc.dart';
import 'all_users_event.dart';
import 'all_users_state.dart';

class UsersPage extends StatefulWidget {
  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  List<User> _users = [];
  AllUsersBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = AllUsersBloc(UserRepository());
    _bloc.add(GetAllUsersEvent());
  }

  Widget build(BuildContext context) {
    return BlocProvider<AllUsersBloc>(
        create: (context) {
          return _bloc;
        },
        child: BlocListener<AllUsersBloc, AllUsersState>(
          listener: _blocListener,
          child: _render(),
        ));
  }

  Widget _render() {
    return BlocBuilder<AllUsersBloc, AllUsersState>(builder: (context, state) {
      return Scaffold(
        appBar: AppBar(
          bottomOpacity: 0.0,
          elevation: 0.0,
          iconTheme: IconThemeData(
            color: Colors.blue,
          ),
          backgroundColor: Colors.white,
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _fieldsOnScreen(),
                _renderUsers(),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _renderUsers() {
    if (_users == null)
      return Container();
    else
      return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: _users.length,
        itemBuilder: (BuildContext context, int index) {
          return _renderUserFirstname(index);
        },
      );
  }

  Widget _renderUserFirstname(int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: rectangularRaisedButton(
        label: _users[index].firstName,
        color: Colors.blue,
        onPress: () => _navigationToShowUserScreen(index),
      ),
    );
  }

  void _navigationToShowUserScreen(int index) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: _bloc,
          child: ShowUserDataPage(
            user: _users[index],
          ),
        ),
      ),
    );
  }

  _fieldsOnScreen() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "users".localizeString(context).toUpperCase(),
          style: TextStyle(
            color: Colors.black87,
            fontSize: 25,
          ),
        ),
      ],
    );
  }

  void _blocListener(BuildContext context, AllUsersState state) {
    if (state is AllUsersLoadedState) {
      Navigator.pop(context);
      _users = state.users;
      setState(() {});
    }
    if (state is AllUsersLoadingState) {
      LoadingScreen.showLoadingDialog(context);
    }
  }
}
