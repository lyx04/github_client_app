import 'package:flukit/flukit.dart';
import "package:flutter/material.dart";
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
      appBar: AppBar(
        leading: MyDrawer(),
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
    return Drawer();
  }
}

class RepoItem extends StatefulWidget {
  RepoItem(this.repo):super(key:ValueKey(repo.id));
  final Repo repo;
  @override
  _RepoItemState createState() => _RepoItemState();
}

class _RepoItemState extends State<RepoItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top:8.0),
      child:Material(
        color:Colors.white,
        shape: BorderDirectional(
          bottom: BorderSide(
            color:Theme.of(context).dividerColor,
            width: .5,
          )
        ),
        child:Padding(
          padding: EdgeInsets.only(top:0.0,bottom: 16),
          child:Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ListTile(
                leading: gmAvater(
                  widget.repo.owner.avatar_url,
                  width:24.0,
                  borderRadius:BorderRadius.circular(12)
                ),
                title: Text(
                  widget.repo.owner.login,
                  textScaleFactor: 0.9,
                ),
                trailing:Text(widget.repo.language??""),
              ),
            ],
          ),
        ),
      ),
    );
  }
}