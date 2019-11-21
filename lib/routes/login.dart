import "package:flutter/material.dart";

class LoginRoute extends StatefulWidget {
  @override
  _LoginRouteState createState() => _LoginRouteState();
}

class _LoginRouteState extends State<LoginRoute> {
  TextEditingController username = TextEditingController();
  TextEditingController pwd = TextEditingController();
 bool pwdShow = false; //密码是否显示明文
  GlobalKey _formKey = new GlobalKey<FormState>();
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
                autofocus: true,
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
                validator: (v){
                  return v.trim().isNotEmpty?null:"";
                },
                obscureText: !pwdShow,
                decoration: InputDecoration(
                  labelText: "密码",
                  hintText: "密码",
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon:GestureDetector(
                    onTapDown: (TapDownDetails details){
                      setState(() {
                        pwdShow = true;
                      });
                    },
                    onTapUp: (TapUpDetails details){
                      setState(() {
                        pwdShow = false;
                      });
                    },
                    child: Icon(pwdShow?Icons.visibility_off:Icons.visibility),
                  )
                ),
              ),
              Padding(
                padding:EdgeInsets.only(top:25),
                child:ConstrainedBox(
                  constraints: BoxConstraints.expand(height: 55.0),
                  child: RaisedButton(
                    color:Theme.of(context).primaryColor,
                    child:Text("登录"),
                    onPressed: _login,
                    textColor: Colors.white,
                  ),
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}
void _login() async{

}