import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:task1/models/user.dart';
import 'package:task1/tools/buttons.dart';
import 'package:task1/tools/view_form.dart';
import 'package:task1/utils/string_extensions.dart';
import 'modify/modify_screen.dart';

class ShowUserDataPage extends StatefulWidget {
  ShowUserDataPage({@required this.user});
  final User user;
  @override
  _ShowUserDataPageState createState() => _ShowUserDataPageState();
}

class _ShowUserDataPageState extends State<ShowUserDataPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget build(BuildContext context) {
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
                  children: [_fieldsOnScreen(), _buttonOk(), _buttonModify()],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buttonModify() {
    return Padding(
        padding: EdgeInsets.only(bottom: 50),
        child: RoundButton(
          color: Colors.red,
          text: "modify".localizeString(context),
          onPress: () async {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ModifyPage(user: widget.user)));
          },
        ));
  }

  Widget _buttonOk() {
    return Padding(
        padding: EdgeInsets.only(bottom: 50),
        child: RoundButton(
          color: Colors.blue,
          text: "ok".localizeString(context),
          onPress: () async {
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
        ));
  }

  Widget _fieldsOnScreen() {
    return Container(
      child: Column(
        children: [
          _renderUserField("firstname", widget.user.firstName),
          _renderUserField("lastname", widget.user.lastName),
          _renderUserField("username", widget.user.username),
          _renderUserField("birthday", widget.user.birthday),
          _renderUserField("email", widget.user.email),
          _renderUserField("mobile_number", widget.user.mobilePhone),
        ],
      ),
    );
  }

  Widget _renderUserField(String text, String value) {
    return ViewUser(
      head: text.localizeString(context).toUpperCase(),
      val: value,
    );
  }
}
