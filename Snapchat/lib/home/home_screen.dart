import 'package:flutter/material.dart';
import 'package:task1/Login/logIn_screen.dart';
import 'package:task1/sign_up/firstname_lastname/firstname_lastname_screen.dart';
import 'package:task1/tools/buttons.dart';
import 'package:task1/views/all_users/all_users_screen.dart';
import 'package:task1/utils/string_extensions.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Color yellow = const Color(0xFFFFFC00);

  @override
  Widget build(BuildContext context) {
    return _render();
  }

  Widget _render() {
    return Scaffold(
      backgroundColor: yellow,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 150),
            child: Stack(
              children: <Widget>[
                Image.asset(
                  "assets/images/logo.jpg",
                ),
              ],
            ),
          ),
          Container(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _renderButton(
                    label: "users".localizeString(context).toUpperCase(),
                    color: Colors.grey,
                    toRoute: UsersPage(),
                  ),
                  _renderButton(
                    label: "login".localizeString(context).toUpperCase(),
                    color: Colors.red,
                    toRoute: LogInPage(),
                  ),
                  _renderButton(
                    label: "signup".localizeString(context).toUpperCase(),
                    color: Colors.blue,
                    toRoute: FirstName_LastNamePage(),
                  )
                ],
              )),
        ],
      ),
    );
  }

  void _navigateTo(Widget navigationScreen) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => navigationScreen));
  }

  Widget _renderButton({String label, Color color, @required Widget toRoute}) {
    return rectangularRaisedButton(
      label: label,
      color: color,
      onPress: () => _navigateTo(toRoute),
    );
  }
}
