import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task1/models/user.dart';
import 'package:task1/sign_up/birthday/birthday_screen.dart';
import 'package:task1/tools/buttons.dart';
import 'package:task1/tools/header.dart';
import 'package:task1/tools/input_field.dart';
import 'package:task1/utils/validator_repository.dart';
import 'firstname_lastname_bloc.dart';
import 'firstname_lastname_event.dart';
import 'firstname_lastname_state.dart';
import 'package:task1/utils/string_extensions.dart';

class FirstName_LastNamePage extends StatefulWidget {
  @override
  _FirstName_LastNamePageState createState() => _FirstName_LastNamePageState();
}

class _FirstName_LastNamePageState extends State<FirstName_LastNamePage> {
  FirstnameLastnameBloc _bloc;
  String _firstname = "";
  String _lastname = "";
  User get user => _bloc.user;

  @override
  void initState() {
    super.initState();
    _bloc = FirstnameLastnameBloc(UserValidorRepository());
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FirstnameLastnameBloc>(
      create: (context) {
        return _bloc;
      },
      child: _render(),
    );
  }

  Widget _render() {
    return BlocBuilder<FirstnameLastnameBloc, FirstnameLastnameState>(
        builder: (context, state) {
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

  Widget _fieldsOnScreen(FirstnameLastnameState state) {
    return Padding(
        padding: const EdgeInsets.only(
          top: 0,
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Column(
                  children: [
                    Header(title: "whats_your_name"),
                    _inputFirstnameField(state),
                    _inputLastnameField(state),
                    _renderPrivacyPolicy(),
                  ],
                ),
              ),
            ]));
  }

  Widget _inputLastnameField(FirstnameLastnameState state) {
    return InputFieldForScreen(
      label: "lastname".localizeString(context).toUpperCase(),
      obscure: false,
      validator: (val) {
        if (state is LastnameInvalid) {
          return "invalid_value".localizeString(context);
        }
        return null;
      },
      onChange: (val) {
        _lastname = val;
        _bloc.add(SignupButtonFirstnameLastnameValidationEvent(
            firstname: _firstname, lastname: val));
      },
    );
  }

  Widget _inputFirstnameField(FirstnameLastnameState state) {
    return InputFieldForScreen(
      label: "firstname".localizeString(context).toUpperCase(),
      obscure: false,
      validator: (_) {
        if (state is FirstnameInvalid) {
          return "invalid_value".localizeString(context);
        }
        return null;
      },
      onChange: (val) {
        _firstname = val;
        _bloc.add(SignupButtonFirstnameLastnameValidationEvent(
            firstname: val, lastname: _lastname));
      },
    );
  }

  Widget _renderPrivacyPolicy() {
    return Padding(
        padding: EdgeInsets.only(top: 15, bottom: 30),
        child: RichText(
            text: TextSpan(
                text: "privacy_policy1".localizeString(context),
                style: TextStyle(fontSize: 10, color: Colors.black),
                children: <TextSpan>[
              TextSpan(
                text: "privacy_policy2".localizeString(context),
                style: TextStyle(fontSize: 10, color: Colors.blue),
              ),
              TextSpan(
                text: "privacy_policy3".localizeString(context),
                style: TextStyle(fontSize: 10, color: Colors.black),
              ),
              TextSpan(
                text: "privacy_policy4".localizeString(context),
                style: TextStyle(fontSize: 10, color: Colors.blue),
              ),
            ])));
  }

  void _navigateToBirthdayScreen(FirstnameLastnameState state) {
    if (state is FormIsValidate) {
      user.firstName = _firstname;
      user.lastName = _lastname;
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => BirthdayPage(user: user)));
    }
  }

  Widget _nextButton(FirstnameLastnameState state) {
    return RoundButton(
      color: state is FormIsValidate ? Colors.blue : Colors.grey,
      text: "sign_up_and_accept".localizeString(context),
      onPress: () => _navigateToBirthdayScreen(state),
    );
  }
}
