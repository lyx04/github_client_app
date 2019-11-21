import "package:flutter/material.dart";

class LoginRoute extends StatefulWidget {
  @override
  _LoginRouteState createState() => _LoginRouteState();
}

class _LoginRouteState extends State<LoginRoute> {
  TextEditingController username = TextEditingController();
  TextEditingController pwd = TextEditingController();
  bool autovalidate = false;
  GlobalKey _formKey = new GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key:_formKey,
      child:Column(
        children: <Widget>[
          TextFormField(
            controller: username,
            autofocus: true,
            decoration: InputDecoration(
              labelText: "用户名",
              hintText:"用户名或者邮箱"
            ),
          )
        ],
      )
    );
  }
}