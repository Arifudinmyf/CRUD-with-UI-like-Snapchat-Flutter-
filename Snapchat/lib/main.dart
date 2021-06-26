import 'package:country_codes/country_codes.dart';
import 'package:flutter/material.dart';
import 'package:task1/home/home_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'app_localizations.dart';
import 'package:flutter_mongodb_realm/flutter_mongo_realm.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await RealmApp.init('snapchat_app-ordkl').timeout(Duration(seconds: 5),
      onTimeout: () {
    return;
  });
  await CountryCodes.init();
  await RealmApp().login(Credentials.anonymous());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final MongoRealmClient client = MongoRealmClient();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      supportedLocales: [
        Locale('en', 'US'),
        Locale('ru', 'RU'),
      ],
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale.languageCode &&
              supportedLocale.countryCode == locale.countryCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
      home: MyHomePage(),
    );
  }
}
