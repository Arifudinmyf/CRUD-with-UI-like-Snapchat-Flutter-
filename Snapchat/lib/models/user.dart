// ignore: import_of_legacy_library_into_null_safe
import 'package:bson/bson.dart' show ObjectId;

class User {
  ObjectId id;
  String firstName;
  String lastName;
  String birthday;
  String username;
  String password;
  String email;
  String mobilePhone;

  User(
      {this.birthday,
      this.email,
      this.firstName,
      this.id,
      this.lastName,
      this.mobilePhone,
      this.password,
      this.username});
}
