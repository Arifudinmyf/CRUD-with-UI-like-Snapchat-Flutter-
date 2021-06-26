import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task1/models/user.dart';
import 'package:task1/sign_up/email_or_phone/email_or_phone_screen.dart';
import 'package:task1/sign_up/password/password_bloc.dart';
import 'package:task1/sign_up/password/password_event.dart';
import 'package:task1/sign_up/password/password_state.dart';
import 'package:task1/tools/buttons.dart';
import 'package:task1/tools/header.dart';
import 'package:task1/tools/input_field.dart';
import 'package:task1/tools/rich_widget.dart';
import 'package:task1/utils/string_extensions.dart';
import 'package:task1/utils/validator_repository.dart';

class PasswordPage extends StatefulWidget {
  PasswordPage({@required this.user});
  final User user;
  @override
  _PasswordPageState createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  String _password = "";
  PasswordBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = PasswordBloc(UserValidorRepository());
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PasswordBloc>(
      create: (context) {
        return _bloc;
      },
      child: _render(),
    );
  }

  Widget _render() {
    return BlocBuilder<PasswordBloc, PasswordState>(builder: (context, state) {
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

  Widget _inputPasswordField(PasswordState state) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: InputFieldForScreen(
        label: "password".localizeString(context).toUpperCase(),
        obscure: true,
        validator: (val) => state is PasswordInvalid
            ? "password".localizeString(context).toUpperCase()
            : null,
        onChange: (val) {
          _password = val;
          _bloc.add(SignupButtonPasswordValidationEvent(password: _password));
        },
      ),
    );
  }

  Widget _fieldsOnScreen(PasswordState state) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 0,
      ),
      child: Column(
        children: [
          Header(title: "password_title"),
          RichWidget(title: "password_error_message1"),
          RichWidget(title: "password_error_message2"),
          _inputPasswordField(state)
        ],
      ),
    );
  }

  void _navigateToPhoneScreen(PasswordState state) {
    if (state is FormIsValidate) {
      widget.user.password = _password;
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => EmailOrPhonePage(user: widget.user)));
    }
  }

  Widget _nextButton(PasswordState state) {
    return RoundButton(
      color: state is FormIsValidate ? Colors.blue : Colors.grey,
      text: "continue".localizeString(context),
      onPress: () {
        _navigateToPhoneScreen(state);
      },
    );
  }
}
