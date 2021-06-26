import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:task1/Repositories/user_repository.dart';
import 'package:task1/models/user.dart';
import 'package:task1/tools/buttons.dart';
import 'package:task1/tools/date_time_picker.dart';
import 'package:task1/tools/input_field.dart';
import 'package:task1/tools/loading_animation.dart';
import 'package:task1/tools/message_box.dart';
import 'package:task1/utils/validator_repository.dart';
import 'package:task1/views/modify/modify_event.dart';
import 'modify_bloc.dart';
import 'modify_state.dart';
import 'package:task1/utils/string_extensions.dart';

class ModifyPage extends StatefulWidget {
  ModifyPage({@required this.user});
  final User user;
  @override
  _ModifyPageState createState() => _ModifyPageState();
}

class _ModifyPageState extends State<ModifyPage> {
  ModifyBloc _bloc;
  DateTime _selectedDate;
  String _username;
  TextEditingController _birthday;
  User get user => _bloc.user;
  User _copyUser = User();

  @override
  void initState() {
    super.initState();
    _bloc = ModifyBloc(UserValidorRepository(), UserRepository());
    _birthday = TextEditingController();
    _birthday.text = widget.user.birthday;
    _username = widget.user.username;
    _copyUser = User()
      ..id = widget.user.id
      ..firstName = widget.user.firstName
      ..lastName = widget.user.lastName
      ..birthday = widget.user.birthday
      ..username = widget.user.username
      ..password = widget.user.password
      ..email = widget.user.email
      ..mobilePhone = widget.user.mobilePhone;
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ModifyBloc>(
        create: (context) {
          return _bloc;
        },
        child: BlocListener<ModifyBloc, ModifyState>(
          listener: _blocListener,
          child: _render(),
        ));
  }

  Widget _render() {
    return BlocBuilder<ModifyBloc, ModifyState>(builder: (context, state) {
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
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [_fieldsOnScreen(state), _buttonOk(state)],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  void _renderDateTima() async {
    DateTime pickedDate = (await dateTimePicker(context));
    // ignore: unnecessary_null_comparison
    if (pickedDate != null && pickedDate != _selectedDate) {
      _selectedDate = pickedDate;
      _birthday.text = DateFormat("dd/MM/yyyy").format(pickedDate);
      _copyUser.birthday = _birthday.text;
      _bloc
          .add(ValidationEvent(user: _copyUser, inputType: InputType.birthday));
    }
  }

  Widget _inputBirthdayField(ModifyState state) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 35,
        right: 35,
      ),
      child: GestureDetector(
        onTap: () => _renderDateTima(),
        child: AbsorbPointer(
          child: TextFormField(
            controller: _birthday,
            decoration: InputDecoration(
              labelText: "birthday".localizeString(context).toUpperCase(),
              errorText: (state is FormInvalid &&
                      state.inputType == InputType.birthday)
                  ? state.invalid_error_massege.localizeString(context)
                  : null,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buttonOk(ModifyState state) {
    return Padding(
        padding: EdgeInsets.only(bottom: 50, top: 10),
        child: RoundButton(
          color: Colors.blue,
          text: "ok".localizeString(context),
          onPress: () async {
            LoadingScreen.showLoadingDialog(context);
            _bloc.add(FinalValidationEvent(user: _copyUser));
          },
        ));
  }

  Widget _fieldsOnScreen(ModifyState state) {
    return Container(
      child: Column(
        children: [
          _inputField(
              state, "firstname".localizeString(context), InputType.firstname),
          _inputField(
              state, "lastname".localizeString(context), InputType.lastname),
          _inputBirthdayField(state),
          _inputField(
              state, "username".localizeString(context), InputType.username),
          _inputField(
              state, "password".localizeString(context), InputType.password),
          _inputField(state, "email".localizeString(context), InputType.email),
          _inputField(
              state, "mobile_number".localizeString(context), InputType.phone),
        ],
      ),
    );
  }

  Widget _inputField(
    ModifyState state,
    String text,
    InputType inputType,
  ) {
    return InputFieldForScreen(
      initialValue: _initialText(inputType),
      label: text.toUpperCase(),
      obscure: false,
      validator: (_) => _validation(state, inputType),
      onChange: (val) {
        _initilizeType(inputType, val);
        _bloc.add(ValidationEvent(user: _copyUser, inputType: inputType));
      },
    );
  }

  String _initialText(InputType inputType) {
    switch (inputType) {
      case InputType.firstname:
        return _copyUser.firstName;
      case InputType.lastname:
        return _copyUser.lastName;
      case InputType.username:
        return _copyUser.username;
      case InputType.email:
        return _copyUser.email;
      case InputType.password:
        return _copyUser.password;
      case InputType.phone:
        return _copyUser.mobilePhone;
      default:
        return null;
    }
  }

  void _initilizeType(InputType inputType, String val) {
    if (inputType == InputType.firstname)
      _copyUser.firstName = val;
    else if (inputType == InputType.lastname)
      _copyUser.lastName = val;
    else if (inputType == InputType.password)
      _copyUser.password = val;
    else if (inputType == InputType.username)
      _copyUser.username = val;
    else if (inputType == InputType.email)
      _copyUser.email = val;
    else if (inputType == InputType.phone) _copyUser.mobilePhone = val;
  }

  String _validation(ModifyState state, InputType inputType) {
    if (state is FormInvalid && inputType == state.inputType) {
      switch (inputType) {
        case InputType.firstname:
          return state.invalid_error_massege.localizeString(context);
        case InputType.lastname:
          return state.invalid_error_massege.localizeString(context);
        case InputType.birthday:
          return state.invalid_error_massege.localizeString(context);
        case InputType.username:
          return state.invalid_error_massege.localizeString(context);
        case InputType.password:
          return state.invalid_error_massege.localizeString(context);
        case InputType.email:
          return state.invalid_error_massege.localizeString(context);
        case InputType.phone:
          return state.invalid_error_massege.localizeString(context);
      }
    }
    return null;
  }

  void _blocListener(BuildContext context, ModifyState state) {
    if (state is UserWithThisDataNotExists) {
      _bloc.add(UpdateEvent(user: _copyUser, username: _username));
    }
    if (state is FormIsFinalInvalid) {
      String _error_massege = "invalid".localizeString(context);
      _error_massege =
          "${_error_massege}  ${state.invalid_error_massege.localizeString(context)}";
      Navigator.pop(context);
      messageBox(context, _error_massege);
    }
    if (state is UserIsUpdated) {
      Navigator.pop(context);
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }
}

enum InputType {
  firstname,
  lastname,
  birthday,
  username,
  password,
  email,
  phone
}
