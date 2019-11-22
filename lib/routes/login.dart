import "package:flutter/material.dart";
import 'package:github_client_app/common/Git.dart';
import 'package:github_client_app/common/global.dart';
import 'package:github_client_app/models/index.dart';
import 'package:provider/provider.dart';

class LoginRoute extends StatefulWidget {
  @override
  _LoginRouteState createState() => _LoginRouteState();
}

class _LoginRouteState extends State<LoginRoute> {
  TextEditingController username = TextEditingController();
  TextEditingController pwd = TextEditingController();
  bool pwdShow = false; //密码是否显示明文
  GlobalKey _formKey = new GlobalKey<FormState>();
  bool autoFocus = true;
  @override
  void initState() {
    super.initState();
    username.text = Global.profile.lastLogin;
    if (username.text != null) {
      autoFocus = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("登录")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: username,
                autofocus: autoFocus,
                autovalidate: true,
                decoration: InputDecoration(
                  labelText: "用户名",
                  hintText: "用户名或者邮箱",
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (v) {
                  return v.trim().isNotEmpty ? null : "";
                },
              ),
              TextFormField(
                controller: pwd,
                autovalidate: true,
                validator: (v) {
                  return v.trim().isNotEmpty ? null : "";
                },
                obscureText: !pwdShow,
                decoration: InputDecoration(
                  labelText: "密码",
                  hintText: "密码",
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: GestureDetector(
                    onTapDown: (TapDownDetails details) {
                      setState(() {
                        pwdShow = true;
                      });
                    },
                    onTapUp: (TapUpDetails details) {
                      setState(() {
                        pwdShow = false;
                      });
                    },
                    child:
                        Icon(pwdShow ? Icons.visibility : Icons.visibility_off),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 25),
                child: ConstrainedBox(
                  constraints: BoxConstraints.expand(height: 55.0),
                  child: RaisedButton(
                    color: Theme.of(context).primaryColor,
                    child: Text("登录"),
                    onPressed: _login,
                    textColor: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _login() async {
    if ((_formKey.currentState as FormState).validate()) {
      var userName = (username.text).trim();
      var password = (pwd.text).trim();
      User user;
      try {
        user = await Git(context).login(userName, password);
        Provider.of<UserModel>(context, listen: false).user = user;
      } catch (e) {
        print(e);
        if (e.response?.statusCode == 401) {
          print(e);
        }
      } finally {
        // Navigator.of(context).pop();
      }
      if (user != null) {
        Navigator.of(context).pop();
      }
    }
  }
}
