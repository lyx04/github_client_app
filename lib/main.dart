import 'package:flutter/material.dart';
import 'package:github_client_app/common/global.dart';
import 'package:provider/provider.dart';

void main() => Global.init().then((e) => runApp(MyApp()));

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers:<SingleChildCloneableWidget> [
        ChangeNotifierProvider.value(value: ThemeModel()),
        ChangeNotifierProvider.value(value:UserModel()),
        ChangeNotifierProvider.value(value:LocalModel())
      ],
      child:Consumer2<ThemeModel,LocalModel>(
        builder: (BuildContext context,themeModel,localeModel,Widget child){
          return MaterialApp(
            theme:ThemeData(
              primarySwatch:themeModel.theme,
            ),
            routes: <String,WidgetBuilder>{
              "login": (context) => LoginRoute(),
              "themes": (context) => ThemeChangeRoute(),
              "language": (context) => LanguageRoute(),
            },
          );
        },
      )
    );
  }
}
