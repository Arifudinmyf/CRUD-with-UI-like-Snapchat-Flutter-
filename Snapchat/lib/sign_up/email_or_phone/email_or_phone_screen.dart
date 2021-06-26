import 'package:country_codes/country_codes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task1/Repositories/user_repository.dart';
import 'package:task1/country/country_screen.dart';
import 'package:task1/models/country.dart';
import 'package:task1/models/user.dart';
import 'package:task1/tools/buttons.dart';
import 'package:task1/tools/header.dart';
import 'package:task1/tools/input_field.dart';
import 'package:task1/tools/loading_animation.dart';
import 'package:task1/tools/message_box.dart';
import 'package:task1/utils/validator_repository.dart';
import 'package:task1/views/show_user_data_screen.dart';
import 'email_or_phone_bloc.dart';
import 'email_or_phone_event.dart';
import 'email_or_phone_state.dart';
import 'package:task1/utils/string_extensions.dart';

class EmailOrPhonePage extends StatefulWidget {
  EmailOrPhonePage({@required this.user});
  final User user;
  @override
  _EmailOrPhonePageState createState() => _EmailOrPhonePageState();
}

class _EmailOrPhonePageState extends State<EmailOrPhonePage> {
  String _emailOrPhone = "";
  EmailOrPhoneBloc _bloc;
  User currentUser = new User();
  final CountryDetails details = CountryCodes.detailsForLocale();
  ValueNotifier<Country> country;

  bool isEmailScreenVisible = false;
  @override
  void initState() {
    super.initState();
    _bloc = EmailOrPhoneBloc(UserValidorRepository(), UserRepository());
    country = ValueNotifier(_bloc.initilizeCountry());
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EmailOrPhoneBloc>(
      create: (context) {
        return _bloc;
      },
      child: BlocListener<EmailOrPhoneBloc, EmailOrPhoneState>(
        listener: _emailOrPhoneBlocListener,
        child: _render(),
      ),
    );
  }

  Widget _render() {
    return BlocBuilder<EmailOrPhoneBloc, EmailOrPhoneState>(
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
                    _phoneFieldOnScreen(state),
                    _emailFieldOnScreen(state)
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

  Widget _nextButton(EmailOrPhoneState state) {
    return RoundButton(
      color: state is FormIsValidate ||
              state is UserWithThisEmailOrPhoneIsNotExistsState
          ? Colors.blue
          : Colors.grey,
      text: "continue".localizeString(context),
      onPress: () {
        _nextButtonPressAction(state);
      },
    );
  }

  void _nextButtonPressAction(EmailOrPhoneState state) {
    if (state is UserWithThisEmailOrPhoneIsNotExistsState) {
      if (!isEmailScreenVisible)
        widget.user.mobilePhone = _emailOrPhone;
      else
        widget.user.email = _emailOrPhone;
      LoadingScreen.showLoadingDialog(context);
      _bloc.add(FinalValidationEvent(widget.user));
    }
  }

  Widget _phoneFieldOnScreen(EmailOrPhoneState state) {
    return Visibility(
      maintainState: true,
      child: Column(
        children: [
          Header(title: "phone_title"),
          _renderSignUpWithEmail(),
          _phoneInputField(state),
          _renderSendVerifyCode(),
        ],
      ),
      visible: !isEmailScreenVisible,
    );
  }

  Widget _emailFieldOnScreen(EmailOrPhoneState state) {
    return Visibility(
      maintainState: true,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 15),
            child: Header(title: "email_title"),
          ),
          _renderSignUpWithPhone(),
          _emailInputField(state),
        ],
      ),
      visible: isEmailScreenVisible,
    );
  }

  //Email Fields
  Widget _renderSignUpWithEmail() {
    return TextButton(
        onPressed: () {
          _bloc.add(ChangingScreenEvent(isEmailScreen: true));
        },
        child: RichText(
            text: TextSpan(
          text: "sign_up_with_email_instead".localizeString(context),
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        )));
  }

  Widget _emailInputField(EmailOrPhoneState state) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: InputFieldForScreen(
        label: "email".localizeString(context).toUpperCase(),
        obscure: false,
        txtType: TextInputType.emailAddress,
        validator: (val) => _emailValidator(val, state),
        onChange: (val) {
          _emailOrPhone = val;
          currentUser.email = _emailOrPhone;
          _bloc.add(SignupButtonEmailValidationEvent(email: _emailOrPhone));
        },
      ),
    );
  }

  String _emailValidator(String val, EmailOrPhoneState state) {
    if (state is EmailInvalid) {
      return "email".localizeString(context).toUpperCase();
    }
    if (state is UserWtihThisEmailOrPhoneIsExistsState) {
      return "user_is_exists".localizeString(context).toUpperCase();
    }
    return null;
  }

  //Phone fields
  Widget _phoneInputField(EmailOrPhoneState state) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: InputFieldForScreen(
        txtType: TextInputType.number,
        prefix: _countryCodeButton(),
        label: "mobile_number".localizeString(context).toUpperCase(),
        obscure: false,
        validator: (val) =>
            _phoneValidator("+${country.value.e164_cc}" + val, state),
        onChange: (val) {
          _emailOrPhone = "+${country.value.e164_cc}" + val;
          currentUser.mobilePhone = _emailOrPhone;
          _bloc.add(SignupButtonPhoneValidationEvent(phone: _emailOrPhone));
        },
      ),
    );
  }

  Widget _countryCodeButton() {
    return ValueListenableBuilder(
        valueListenable: country,
        builder: (context, value, child) {
          return TextButton(
              onPressed: () {
                _routeToCountryCodeScreen();
              },
              child: Text(
                "${country.value.iso2_cc} +${country.value.e164_cc}",
                style: TextStyle(fontSize: 17),
              ));
        });
  }

  void _routeToCountryCodeScreen() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => CountryPage(
              country: country,
            )));
  }

  String _phoneValidator(String val, EmailOrPhoneState state) {
    if (state is PhoneInvalid) {
      return "mobile_number".localizeString(context).toUpperCase();
    }
    if (state is UserWtihThisEmailOrPhoneIsExistsState) {
      return "user_is_exists".localizeString(context).toUpperCase();
    }
    return null;
  }

  Widget _renderSignUpWithPhone() {
    return Padding(
        padding: EdgeInsets.only(top: 10),
        child: TextButton(
            onPressed: () {
              _bloc.add(ChangingScreenEvent(isEmailScreen: false));
            },
            child: RichText(
                text: TextSpan(
              text: "sign_up_with_phone_instead".localizeString(context),
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ))));
  }

  Widget _renderSendVerifyCode() {
    return Padding(
      padding: EdgeInsets.only(top: 15, bottom: 30),
      child: RichText(
        text: TextSpan(
          text: "send_verify_code".localizeString(context),
          style: TextStyle(
            color: Colors.black,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  void _emailOrPhoneBlocListener(
      BuildContext context, EmailOrPhoneState state) {
    if (state is FormIsValidate) {
      if (isEmailScreenVisible) {
        _bloc.add(CheckEmailInDBEvent(user: currentUser));
      } else {
        _bloc.add(CheckPhoneInDBEvent(user: currentUser));
      }
    }
    if (state is UserIsAddedSuccessfulyState) {
      Navigator.pop(context);
      widget.user.id = state.id;
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ShowUserDataPage(user: widget.user)));
    }
    if (state is UserExists) {
      Navigator.pop(context);
      String _error_message = "exists".localizeString(context);
      _error_message =
          "${state.error_massege.localizeString(context)} ${_error_message} ";
      messageBox(context, _error_message);
    }
    if (state is EmailScreenVisibleState) {
      isEmailScreenVisible = true;
    }
    if (state is PhoneScreenVisibleState) {
      isEmailScreenVisible = false;
    }
  }
}
