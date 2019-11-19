import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:github_client_app/common/Git.dart';
import 'package:github_client_app/common/cache.dart';
import "../models/index.dart";
import 'package:shared_preferences/shared_preferences.dart';

const _themes = <MaterialColor>[
  Colors.blue,
  Colors.cyan,
  Colors.teal,
  Colors.green,
  Colors.red,
];

class Global {
  static SharedPreferences _prefs;
  static Profile profile = Profile();
  //网络缓存对象
  static NetCache netCache = NetCache();
  static List<MaterialColor> get themes => _themes;
  //是否是release版
  static bool get isRelease => bool.fromEnvironment("dart.vm.product");

  //初始化全局信息，会在app启动时执行
  static Future init() async {
    _prefs = await SharedPreferences.getInstance(); //获取实例
    var _profile = _prefs.getString("profile");
    print(_profile);
    if (_profile != null) {
      try {
        profile = Profile.fromJson(jsonDecode(_profile));
      } catch (e) {
        print(e);
      }
    }
    profile.cache = profile.cache??CacheConfig()..enable = true..maxAge = 3600..maxCount = 100;
    //初始化网络请求配置
    Git.init();
  }

  static saveProfile()=>_prefs.setString("profile", jsonEncode(profile.toJson()));
}


class ProfileChangeNotifier extends ChangeNotifier{
  Profile get _profile=>Global.profile;
  @override
  void notifyListeners() {
    Global.saveProfile();
    super.notifyListeners();//通知依赖的Widget更新
  }
}

class UserModel extends ProfileChangeNotifier{
  User get user=>_profile.user;
  bool get isLogin=>user!=null;

  set user(User user){
    if(user?.login !=_profile.user?.login){
      _profile.lastLogin = _profile.user?.login;
      _profile.user = user;
      notifyListeners();
    }
  }
}

class ThemeModel extends ProfileChangeNotifier{
  ColorSwatch get theme =>Global.themes.firstWhere((e)=>e.value==_profile.theme,orElse: ()=>Colors.blue);
  set theme(ColorSwatch color){
    if(color!=theme){
      _profile.theme = color[500].value;
      notifyListeners();
    }
  }
}

class LocalModel extends ProfileChangeNotifier{
  Locale getLocale(){
    if(_profile.locale ==null) return null;
    var t = _profile.locale.split("-");
    return Locale(t[0],t[1]);
  }

  String get locale => _profile.locale;
  set locale(String locale){
    if(locale!= _profile.locale){
      _profile.locale = locale;
      notifyListeners();
    }
  }
}