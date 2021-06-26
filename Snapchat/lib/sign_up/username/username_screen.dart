import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task1/models/user.dart';
import 'package:task1/sign_up/password/password_screen.dart';
import 'package:task1/sign_up/username/username_bloc.dart';
import 'package:task1/sign_up/username/username_event.dart';
import 'package:task1/sign_up/username/username_state.dart';
import 'package:task1/tools/buttons.dart';
import 'package:task1/tools/header.dart';
import 'package:task1/tools/input_field.dart';
import 'package:task1/tools/rich_widget.dart';
import 'package:task1/utils/string_extensions.dart';
import 'package:task1/utils/validator_repository.dart';

class UsernamePage extends StatefulWidget {
  UsernamePage({@required this.user});
  final User user;
  @override
  _UsernamePageState createState() => _UsernamePageState();
}

class _UsernamePageState extends State<UsernamePage> {
  String _username = "";
  UsernameBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = UsernameBloc(UserValidorRepository());
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  void _blocListener(context, state) {
    if (state is FormIsValidate) {
      _bloc.add(CheckUsernameInDBEvent(user: widget.user));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UsernameBloc>(
        create: (context) {
          return _bloc;
        },
        child: BlocListener<UsernameBloc, UsernameState>(
          listener: _blocListener,
          child: _render(),
        ));
  }

  Widget _render() {
    return BlocBuilder<UsernameBloc, UsernameState>(builder: (context, state) {
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
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    _fieldsOnScreen(state),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.bottomCenter,
                child: _nextButton(state),
              ),
            ],
          ));
    });
  }

  Widget _fieldsOnScreen(UsernameState state) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 0,
      ),
      child: Column(
        children: [
          Header(title: "username_title"),
          RichWidget(title: "username_subtitle1"),
          RichWidget(title: "username_subtitle2"),
          _inputUsernameField(state)
        ],
      ),
    );
  }

  Widget _nextButton(UsernameState state) {
    return RoundButton(
      color: state is FormIsValidate ||
              state is UserWithThisUsernameIsNotExistsState
          ? Colors.blue
          : Colors.grey,
      text: "continue".localizeString(context),
      onPress: () {
        _navigateToPasswordScreen(state);
      },
    );
  }

  void _navigateToPasswordScreen(UsernameState state) {
    if (state is UserWithThisUsernameIsNotExistsState) {
      widget.user.username = _username;
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => PasswordPage(user: widget.user)));
    }
  }

  String _validator(String val, UsernameState state) {
    if (state is UsernameInvalid) {
      return "username".localizeString(context).toUpperCase();
    }
    if (state is UserWtihThisUsernameIsExistsState) {
      return "user_is_exists".localizeString(context).toUpperCase();
    }
    return null;
  }

  Widget _inputUsernameField(UsernameState state) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: InputFieldForScreen(
        label: "username".localizeString(context),
        obscure: false,
        validator: (val) => _validator(val, state),
        onChange: (val) {
          _username = val;
          widget.user.username = _username;
          _bloc.add(SignupButtonUsernameValidationEvent(username: _username));
        },
      ),
    );
  }
}
