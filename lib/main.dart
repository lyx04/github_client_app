import 'package:flutter/material.dart';
import 'package:github_client_app/common/global.dart';
import 'package:provider/provider.dart';
import 'routes/home_page.dart';
import 'routes/login.dart';
import "routes/theme.dart";

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Global.init().then((e) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: <SingleChildCloneableWidget>[
        ChangeNotifierProvider.value(value: ThemeModel()),
        ChangeNotifierProvider.value(value: UserModel()),
        ChangeNotifierProvider.value(value: LocalModel())
      ],
      child: Consumer2<ThemeModel, LocalModel>(
        builder: (BuildContext context, themeModel, localeModel, Widget child) {
          return MaterialApp(
            theme: ThemeData(
              primarySwatch: themeModel.theme,
            ),
            home: Home(),
            routes: <String, WidgetBuilder>{
              "login": (context) => LoginRoute(),
              "themes": (context) => ThemeChangeRoute(),
              // "language": (context) => LanguageRoute(),
            },
          );
        },
      ),
    );
  }
}
