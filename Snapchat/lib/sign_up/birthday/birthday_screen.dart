import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task1/models/user.dart';
import 'package:task1/sign_up/birthday/birthday_bloc.dart';
import 'package:task1/sign_up/birthday/birthday_event.dart';
import 'package:task1/sign_up/birthday/birthday_state.dart';
import 'package:task1/sign_up/username/username_screen.dart';
import 'package:task1/tools/buttons.dart';
import 'package:task1/tools/header.dart';
import 'package:task1/utils/string_extensions.dart';
import 'package:task1/utils/validator_repository.dart';

class BirthdayPage extends StatefulWidget {
  BirthdayPage({@required this.user});
  final User user;
  @override
  _BirthdayPageState createState() => _BirthdayPageState();
}

class _BirthdayPageState extends State<BirthdayPage> {
  final TextEditingController _birthday = TextEditingController();
  BirthdayBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = BirthdayBloc(UserValidorRepository());
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BirthdayBloc>(
      create: (context) {
        return _bloc;
      },
      child: _render(),
    );
  }

  Widget _render() {
    return BlocBuilder<BirthdayBloc, BirthdayState>(builder: (context, state) {
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
          body: _fieldsOnScreen(state));
    });
  }

  Widget _nextButton(BirthdayState state) {
    return RoundButton(
      color: (state is FormIsValidate ? Colors.blue : Colors.grey),
      text: "continue".localizeString(context),
      onPress: () => _navigateToUsernameScreen(state),
    );
  }

  void _navigateToUsernameScreen(BirthdayState state) {
    if (state is FormIsValidate) {
      widget.user.birthday = _birthday.text;
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => UsernamePage(user: widget.user)));
    }
  }

  Widget _renderBirthday(state) {
    return Container(
      padding: EdgeInsets.only(bottom: 10, left: 35, right: 35, top: 10),
      child: TextField(
        autofocus: false,
        showCursor: false,
        controller: _birthday,
        decoration: InputDecoration(
          labelText: "birthday".localizeString(context),
          errorText: (state is BirthdayInvalid)
              ? "birthday_error_message".localizeString(context)
              : null,
        ),
      ),
    );
  }

  Widget _renderDatePicker() {
    return Container(
        child: CupertinoDatePicker(
            initialDateTime: DateTime(DateTime.now().year - 16,
                DateTime.now().month, DateTime.now().day),
            mode: CupertinoDatePickerMode.date,
            onDateTimeChanged: (DateTime dateTime) =>
                _changeDateTime(dateTime)));
  }

  void _changeDateTime(DateTime dateTime) {
    // ignore: unnecessary_null_comparison
    if (dateTime != null) {
      setState(() => _setDateTime(dateTime));
    }
  }

  void _setDateTime(DateTime dateTime) {
    _birthday.text = DateFormat("dd/MM/yyyy").format(dateTime);
    _bloc.add(SignupButtonBirthdayValidationEvent(birthday: _birthday.text));
  }

  Widget _fieldsOnScreen(BirthdayState state) {
    return SafeArea(
        child: Column(
      children: [
        Header(title: "birthday_title"),
        Expanded(child: _renderBirthday(state)),
        _nextButton(state),
        Container(
            height: 200, width: double.infinity, child: _renderDatePicker())
      ],
    ));
  }
}
