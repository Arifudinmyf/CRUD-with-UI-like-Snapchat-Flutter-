import 'package:task1/models/user.dart';
import 'package:flutter_mongodb_realm/flutter_mongo_realm.dart';
import 'package:task1/utils/validator_repository.dart';
import 'package:bson/bson.dart' show ObjectId;

class UserRepository {
  UserRepository() {
    _collection = client.getDatabase("SnapchatDB").getCollection("User");
  }
  final MongoRealmClient client = MongoRealmClient();
  List<User> _users = [];
  List<User> get users => _users;
  MongoCollection _collection;
  UserValidorRepository validator = new UserValidorRepository();

  void add(User user) {
    _users.add(user);
  }

  User identification(String login, String password) {
    if (validator.isValidPhone(login)) {
      return _users
          .where((element) =>
              element.mobilePhone == login && element.password == password)
          .first;
    } else if (validator.isValidEmail(login)) {
      return _users
          .where((element) =>
              element.email == login && element.password == password)
          .first;
    } else if (validator.isValidUsername(login)) {
      return _users
          .where((element) =>
              element.username == login && element.password == password)
          .first;
    }
    return null;
  }

  Future<ObjectId> insertUserToDB(User user) async {
    user.id = await _collection.insertOne(MongoDocument({
      "firstName": user.firstName,
      "lastName": user.lastName,
      "birthday": user.birthday,
      "username": user.username,
      "password": user.password,
      "email": user.email,
      "mobilePhone": user.mobilePhone
    }));
    return user.id;
  }

  Future<List<User>> getUsersFromDB() async {
    print("count======= ${_collection.count()}");
    var docs = await _collection.find();
    List<User> _users = [];
    docs.forEach((element) {
      User _user = new User();
      _user.id = element.get("_id");
      _user.firstName = element.get("firstName");
      _user.lastName = element.get("lastName");
      _user.birthday = element.get("birthday");
      _user.username = element.get("username");
      _user.password = element.get("password");
      _user.email = element.get("email");
      _user.mobilePhone = element.get("mobilePhone");
      _users.add(_user);
    });
    return _users;
  }

  Future<void> update({User user, String username}) async {
    await _collection.updateMany(
        filter: {
          "username": username,
        },
        update: UpdateOperator.set({
          "firstName": user.firstName,
          "lastName": user.lastName,
          "birthday": user.birthday,
          "username": user.username,
          "password": user.password,
          "email": user.email,
          "mobilePhone": user.mobilePhone
        }));
  }

  Future<User> identification_realmDB(String login, String password) async {
    _users = await getUsersFromDB();
    if (validator.isValidPhone(login)) {
      return _users
          .where((element) =>
              element.mobilePhone == login && element.password == password)
          .first;
    } else if (validator.isValidEmail(login)) {
      return _users
          .where((element) =>
              element.email == login && element.password == password)
          .first;
    } else if (validator.isValidUsername(login)) {
      return _users
          .where((element) =>
              element.username == login && element.password == password)
          .first;
    }
    return null;
  }

  Future<int> countOfEmails(User user) async {
    List<MongoDocument> _users_with_current_email = [];
    if (user.id == null) {
      _users_with_current_email =
          await _collection.find(filter: {"email": "${user.email}"});
    } else {
      _users_with_current_email = await _collection.find(
          filter: {"email": "${user.email}", "_id": QueryOperator.ne(user.id)});
    }
    int count = _users_with_current_email.length;
    return count;
  }

  Future<bool> checkEmail(User user) async {
    int count = await countOfEmails(user);
    if (count == 0) return false;
    return true;
  }

  Future<int> countOfMobilePhones(User user) async {
    List<MongoDocument> _users_with_current_phone = [];
    if (user.id == null) {
      _users_with_current_phone = await _collection.find(filter: {
        "mobilePhone": "${user.mobilePhone}",
      });
    } else {
      _users_with_current_phone = await _collection.find(filter: {
        "mobilePhone": "${user.mobilePhone}",
        "_id": QueryOperator.ne(user.id)
      });
    }
    int count = _users_with_current_phone.length;
    return count;
  }

  Future<bool> checkMobilePhone(User user) async {
    int count = await countOfMobilePhones(user);
    if (count == 0) return false;
    return true;
  }

  Future<int> countOfUsernames(User user) async {
    List<MongoDocument> _users_with_current_username = [];
    print(_collection.count());

    if (user.id == null) {
      _users_with_current_username = await _collection.find(filter: {
        "username": "${user.username}",
      });
    } else {
      _users_with_current_username = await _collection.find(filter: {
        "username": "${user.username}",
        "_id": QueryOperator.ne(user.id)
      });
    }
    int count = _users_with_current_username.length;
    return count;
  }

  Future<bool> checkUsername(User user) async {
    int count = await countOfUsernames(user);
    if (count == 0) return false;
    return true;
  }
}
