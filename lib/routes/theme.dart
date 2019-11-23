import "package:flutter/material.dart";
import 'package:github_client_app/common/global.dart';
import 'package:provider/provider.dart';

class ThemeChangeRoute extends StatefulWidget {
  @override
  _ThemeChangeRouteState createState() => _ThemeChangeRouteState();
}

class _ThemeChangeRouteState extends State<ThemeChangeRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Theme"),
      ),
      body: ListView(
        children: Global.themes.map<Widget>((e){
          return GestureDetector(
            child:Padding(
              padding: EdgeInsets.symmetric(vertical: 5,horizontal: 16),
              child:Container(
                color: e,
                height:40,
              )
            ),
            onTap: (){
              Provider.of<ThemeModel>(context).theme = e;
            },
          );
        }).toList(),
      ),
    );
  }
}
