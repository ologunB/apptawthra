import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Styles {
  static Color yellowColor = Color(0xffFFD839);
  static Color whiteColor = Colors.white;

  static Color appPrimaryColor =yellowColor;
  static Color appBackground = Colors.black12;
  static Color appCanvasColor =whiteColor;
  static Color colorBlack = Colors.black;
  static Color appLightPrimaryColor = Color(0xa19EB7FF);

  static Color tintColor1 = Color(0xa1d0d0f5);
  static Color tintColor2 = Color(0xa1CDEDFF);
  static Color tintColor3 = Color(0xa1CCF6F3);
  static Color tintColor4 = Color(0xa1FDE2DE);
  static Color tintColor5 = Color(0xa15050eb);
  static Color tintColor6 = Color(0xa155b9f2);
  static Color tintColor7 = Color(0xa157ebe1);
  static Color tintColor8 = Color(0xa1f23d30);

  static InputDecoration input = InputDecoration(
    fillColor: Colors.white,
    focusColor: Colors.grey[900],
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.blue, width: 2.0),
    ),
    border: OutlineInputBorder(
      gapPadding: 1.0,
      borderSide: BorderSide(color: Colors.grey[600], width: 1.0),
    ),
    hintStyle: TextStyle(
      color: Colors.grey[600],
    ),
  );
}