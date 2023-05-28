/// A file to configure app theme

import 'package:flutter/material.dart';

const blackColor = Color(0xFF202020);
const whiteColor = Color(0xFFFFFFFF);
const lightGreyColor = Color(0xFFF4F4F2);
const greyColor = Colors.grey;
const darkGreyColor = Color(0xFF515151);
const yellowColor = Color(0xFFFFD84E);

final ThemeData appThemeData = ThemeData(
  colorScheme:
      const ColorScheme.light(primary: yellowColor, secondary: blackColor),
  scaffoldBackgroundColor: lightGreyColor,
  appBarTheme: const AppBarTheme(elevation: 0),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: blackColor, unselectedItemColor: whiteColor),
  fontFamily: "Roboto",
  iconTheme: const IconThemeData(weight: 200.0),
);
