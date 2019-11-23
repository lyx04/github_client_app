import 'package:flukit/flukit.dart';
import "package:flutter/material.dart";
import 'package:github_client_app/common/cached_img.dart';
import 'package:provider/provider.dart';

import '../common/Git.dart';
import '../common/global.dart';
import '../models/index.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        title: Text("Github客户端"),
      ),
      body: bodybuild(),
    );
  }

  Widget bodybuild() {
    UserModel userModel = Provider.of<UserModel>(context);
    if (!userModel.isLogin) {
      return Center(
        child: RaisedButton(
          child: Text("登陆"),
          onPressed: () => Navigator.of(context).pushNamed("login"),
        ),
      );
    } else {
      return InfiniteListView<Repo>(
        onRetrieveData: (int page, List<Repo> items, bool refresh) async {
          var data = await Git(context).getRepos(
            refresh: refresh,
            queryParameters: {
              "page": page,
              "page_size": 20,
            },
          );
          items.addAll(data);
          return data.length == 20;
        },
        itemBuilder: (List list, int index, BuildContext context) {
          return RepoItem(list[index]);
        },
      );
    }
  }
}

class MyDrawer extends StatefulWidget {
  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Builder(
        builder: (context) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildHeader(),
              Expanded(
                child: _buiildMenus(),
              ),
            ],
          );
        },
      ),
    );
  }
}

Widget _buildHeader() {
  return Consumer<UserModel>(
    builder: (BuildContext context, UserModel value, Widget child) {
      return GestureDetector(
        child: Container(
          color: Theme.of(context).primaryColor,
          padding: EdgeInsets.only(top: 40, bottom: 20),
          child: Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: ClipOval(
                  child: value.isLogin
                      ? gmAvater(value.user.avatar_url, width: 80)
                      : Image.asset(
                          "imgs/acatar-default.png",
                          width: 80,
                        ),
                ),
              ),
              Text(value.isLogin ? value.user.login : "登录",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white)),
            ],
          ),
        ),
        onTap: () {
          if (!value.isLogin) Navigator.of(context).pushNamed("login");
        },
      );
    },
  );
}

Widget _buiildMenus() {
  return Consumer<UserModel>(
    builder: (BuildContext context, UserModel value, Widget child) {
      return ListView(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.color_lens),
            title: Text("主题"),
            onTap: () => Navigator.of(context).pushNamed("themes"),
          ),
          // ListTile(
          //   leading: Icon(Icons.language),
          //   title: Text("语言"),
          //   onTap: () => Navigator.of(context).pushNamed("language"),
          // ),
          if (value.isLogin)
            ListTile(
              leading: Icon(Icons.power_settings_new),
              title: Text("注销"),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("确定退出么"),
                        actions: <Widget>[
                          FlatButton(
                            child: Text("确定"),
                            onPressed: () {
                              value.user = null;
                              Navigator.pop(context);
                            },
                          ),
                          FlatButton(
                            child: Text("取消"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          )
                        ],
                      );
                    });
              },
            )
        ],
      );
    },
  );
}

class RepoItem extends StatefulWidget {
  RepoItem(this.repo) : super(key: ValueKey(repo.id));
  final Repo repo;
  @override
  _RepoItemState createState() => _RepoItemState();
}

class _RepoItemState extends State<RepoItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Material(
        color: Colors.white,
        shape: BorderDirectional(
            bottom: BorderSide(
          color: Theme.of(context).dividerColor,
          width: .5,
        )),
        child: Padding(
          padding: EdgeInsets.only(top: 0.0, bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ListTile(
                leading: gmAvater(widget.repo.owner.avatar_url,
                    width: 24.0, borderRadius: BorderRadius.circular(12)),
                title: Text(
                  widget.repo.owner.login,
                  textScaleFactor: 0.9,
                ),
                trailing: Text(widget.repo.language ?? ""),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.repo.fork
                          ? widget.repo.full_name
                          : widget.repo.name,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontStyle: widget.repo.fork
                              ? FontStyle.italic
                              : FontStyle.normal),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 8, bottom: 12),
                      child: Text(
                        widget.repo.description ?? "暂无",
                        maxLines: 3,
                        style: TextStyle(
                            height: 1.5,
                            color: Colors.blueGrey[700],
                            fontSize: 13),
                      ),
                    ),
                    _buildBottom()
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottom() {
    const paddingWidth = 10;
    return IconTheme(
        data: IconThemeData(color: Colors.grey, size: 15),
        child: DefaultTextStyle(
            style: TextStyle(color: Colors.grey, fontSize: 12),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Builder(
                builder: (context) {
                  var children = <Widget>[
                    Icon(Icons.star),
                    Text(
                      "" +
                          widget.repo.stargazers_count
                              .toString()
                              .padRight(paddingWidth),
                    ),
                    Text(" " +
                        widget.repo.open_issues_count
                            .toString()
                            .padRight(paddingWidth)),

                    // Icon(MyIcons.fork), //我们的自定义图标
                    Text(
                      widget.repo.forks_count.toString().padRight(paddingWidth),
                    ),
                  ];
                  if (widget.repo.private == true) {
                    children.addAll(<Widget>[
                      Icon(Icons.lock),
                      Text(
                        " private".padRight(paddingWidth),
                      ),
                    ]);
                  }
                  return Row(children: children);
                },
              ),
            )));
  }
}
