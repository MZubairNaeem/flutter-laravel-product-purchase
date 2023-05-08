import 'dart:ui';

import 'package:flutter/material.dart';

class AppColors {
  var primaryColor = const Color(0xff050406);
  var lightColor = const Color(0xff5aa787);
  var secondaryColor = const Color(0xff354341);
  var greyText = const Color(0xffbdc1c6);
  var lightText = const Color(0xffe4e8ee);
  var gradiant1 = const Color(0xffEE9CA7);
  var gradiant2 = const Color(0xffFFDDE1);
  var blackLight = const Color(0xff404258);
}
var primaryColor = const Color(0xff050406);
var lightColor = const Color(0xff5aa787);
var secondaryColor = const Color(0xff354341);
var greyText = const Color(0xffbdc1c6);
var lightText = const Color(0xffe4e8ee);
var gradiant1 = const Color(0xffEE9CA7);
var gradiant2 = const Color(0xffFFDDE1);
var blackLight = const Color(0xff404258);

final myTheme = ThemeData(
  primaryColor: secondaryColor,
  scaffoldBackgroundColor: greyText,
  shadowColor: greyText,
  highlightColor: Colors.transparent,
  dialogBackgroundColor: greyText,
  cardColor: greyText,
  disabledColor: lightColor,
  dividerColor: lightColor,
  appBarTheme: AppBarTheme(
    elevation: 0,
    color: greyText,
    iconTheme: IconThemeData(color: secondaryColor),
    titleTextStyle:TextStyle(
      color: secondaryColor,
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
  ), colorScheme: ColorScheme.light(primary: lightColor, secondary: lightColor).copyWith(secondary: lightColor).copyWith(background: lightText).copyWith(error: lightColor),
);