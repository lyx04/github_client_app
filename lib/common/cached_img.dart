import 'package:cached_network_image/cached_network_image.dart';
import "package:flutter/material.dart";

Widget gmAvater(String url,
    {double width = 30, double height, BoxFit fit, BorderRadius borderRadius}) {
  var placeholder =
      Image.asset("imgs/acatar-default.png", width: width, height: height);
  return ClipRRect(
    borderRadius: borderRadius ?? BorderRadius.circular(2),
    child: CachedNetworkImage(
      imageUrl: url,
      width: width,
      height: height,
      placeholder: (context, url) => placeholder,
      errorWidget: (context, url, err) => placeholder,
    ),
  );
}
