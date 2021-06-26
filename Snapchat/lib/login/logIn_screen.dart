import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task1/Repositories/user_repository.dart';
import 'package:task1/login/login_bloc.dart';
import 'package:task1/login/login_event.dart';
import 'package:task1/login/login_state.dart';
import 'package:task1/tools/buttons.dart';
import 'package:task1/tools/header.dart';
import 'package:task1/tools/input_field.dart';
import 'package:task1/tools/message_box.dart';
import 'package:task1/utils/validator_repository.dart';
import 'package:task1/views/show_user_data_screen.dart';
import 'package:task1/utils/string_extensions.dart';

class LogInPage extends StatefulWidget {
  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  String _login = "";
  String _password = "";
  bool _passwordVisible = false;
  LoginBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = LoginBloc(UserValidorRepository(), UserRepository());
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginBloc>(
        create: (context) {
          return _bloc;
        },
        child: BlocListener<LoginBloc, LoginState>(
          listener: _blocListener,
          child: _render(),
        ));
  }

  Widget _render() {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _fieldsOnScreen(state),
              _nextButton(state),
            ],
          ),
        ),
      );
    });
  }

  Widget _fieldsOnScreen(LoginState state) {
    return Padding(
        padding: const EdgeInsets.only(
          top: 80,
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Column(
                  children: [
                    Header(title: "login"),
                    _inputLoginField(state),
                    _inputPasswordField(state),
                    _renderForgotPassword()
                  ],
                ),
              ),
            ]));
  }

  void _navigateToShowUserScreen(BuildContext context, LoginState state) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ShowUserDataPage(user: _bloc.user)));
  }

  Widget _inputPasswordField(state) {
    return InputFieldForScreen(
      label: "password".localizeString(context).toUpperCase(),
      obscure: !_passwordVisible,
      suffixIcon: _visibilityButton(),
      validator: (val) {
        if (state is PasswordInvalid) {
          return "invalid_value".localizeString(context).toUpperCase();
        }
        return null;
      },
      onChange: (val) => _validation(_password = val),
    );
  }

  Widget _visibilityButton() {
    return IconButton(
      icon: Icon(
        _passwordVisible ? Icons.visibility : Icons.visibility_off,
        color: Colors.grey,
      ),
      onPressed: () {
        setState(() {
          _passwordVisible = !_passwordVisible;
        });
      },
    );
  }

  Widget _inputLoginField(state) {
    return InputFieldForScreen(
      label: "username_or_email".localizeString(context).toUpperCase(),
      obscure: false,
      validator: (val) {
        if (state is LoginInvalid) {
          return "invalid_value".localizeString(context).toUpperCase();
        }
        return null;
      },
      onChange: (val) => _validation(_login = val),
    );
  }

  void _validation(val) {
    _bloc.add(
        SignupButtonLoginValidationEvent(login: _login, password: _password));
  }

  Widget _nextButton(LoginState state) {
    return RoundButton(
      color: state is FormIsValidate ? Colors.blue : Colors.grey,
      text: "login".localizeString(context).toUpperCase(),
      onPress: () => _identify(state),
    );
  }

  void _identify(state) {
    if (state is FormIsValidate) {
      _bloc.add(IdenitficationEvent(login: _login, password: _password));
    }
  }

  Widget _renderForgotPassword() {
    return Padding(
      padding: EdgeInsets.only(top: 15, bottom: 30),
      child: Text(
        "forgot_your_password".localizeString(context).toUpperCase(),
        style: TextStyle(
          color: Colors.blue,
          fontSize: 12,
        ),
      ),
    );
  }

  void _blocListener(context, state) {
    if (state is SuccessIdentificationState) {
      _navigateToShowUserScreen(context, state);
    }
    if (state is FailIdentificationState) {
      messageBox(context, "user_is_exists".localizeString(context));
    }
  }
}
