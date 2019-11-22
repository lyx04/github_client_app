import 'dart:convert';
import 'dart:io';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:github_client_app/common/global.dart';
import 'package:github_client_app/models/index.dart';

class Git {
  Git([this.context]) {
    _options = Options(extra: {"context": context});
  }

  BuildContext context;
  Options _options;

  static Dio dio = new Dio(
    BaseOptions(
      baseUrl: "https://api.github.com/",
    ),
  );

  static void init() {
    //添加缓存插件
    // dio.interceptors.add(Global.netCache);
    //设置用户token(可能是null，代表未登录)
    dio.options.headers[HttpHeaders.authorizationHeader] = Global.profile.token;
    dio.options.headers.addAll({"User-Agent":Global.profile.user.login});
    if (!Global.isRelease) {
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (client) {
        // client.findProxy = (uri) {
        //   return "PROXY 10.1.10.250:8888";
        // };
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) {
          print(cert);
          print(host);
          print(port);
          return true;
        };
      };
    }
  }

  //获取用户信息
  Future<User> login(String login, String pwd) async {
    String basic = 'Basic' + base64.encode(utf8.encode("$login:$pwd"));
    var r = await dio.get(
      "users/$login",
      options: Options(
        headers: {
          HttpHeaders.authorizationHeader: basic,
        },
        extra: {
          "noCache": true, //接口禁止缓存
        },
      ),
    );
    dio.options.headers[HttpHeaders.authorizationHeader] = basic;
    Global.netCache.cache.clear();
    Global.profile.token = basic;
    return User.fromJson(r.data);
  }

  //获取项目列表
  Future<List<Repo>> getRepos(
      {Map<String, dynamic> queryParameters, refresh = false}) async {
    dio.interceptors.add(LogInterceptor(responseBody: false)); //开启请求日志

    if (refresh) {
      _options.extra.addAll({"refresh": true, "list": true});
    }
    var r = await dio.get<List>(
      "user/repos",
      queryParameters: queryParameters,
      options: _options,
    );
    return r.data.map((e) => Repo.fromJson(e)).toList();
  }
}
