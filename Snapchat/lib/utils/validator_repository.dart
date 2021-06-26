import 'package:intl/intl.dart';

class UserValidorRepository {
  bool isValidPhone(String value) {
    RegExp _phoneRegExp = RegExp(r'(^(?:[+)])?[0-9]{11,16}$)');
    if (_phoneRegExp.hasMatch(value) && !value.contains(" ")) {
      return true;
    }
    return false;
  }

  RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );

  bool isValidEmail(String value) {
    return _emailRegExp.hasMatch(value) && !value.contains(" ");
  }

  bool isValidPassword(String value) {
    if (value.length < 8 || value.contains(" ")) return false;
    return true;
  }

  bool isValidFirstname(String value) {
    if (value.isEmpty || value.contains(" ")) return false;
    return true;
  }

  bool isValidLastname(String value) {
    if (value.isEmpty || value.contains(" ")) return false;
    return true;
  }

  bool isValidUsername(String value) {
    if (value.length < 6 || value.contains(" ")) return false;
    return true;
  }

  bool _isAdult(String birthday) {
    String datePattern = "dd/MM/yyyy";
    DateTime today = DateTime.now();
    DateTime birthDate = DateFormat(datePattern).parse(birthday);
    DateTime adultDate = DateTime(
      birthDate.year + 16,
      birthDate.month,
      birthDate.day,
    );
    return adultDate.isBefore(today);
  }

  bool isValidBirthday(String value) {
    if (_isAdult(value) && value.isNotEmpty && !value.contains(" ")) {
      return true;
    } else {
      return false;
    }
  }
}
