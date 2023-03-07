// ignore_for_file: constant_identifier_names

import 'package:lib_x/lib_x.dart';

const Color lightC = Color.fromARGB(255, 230, 226, 247);
const Color lightC1 = Color.fromARGB(255, 241, 239, 253);
const Color darkC = Color.fromARGB(255, 39, 37, 54);
const Color darkC1 = Color.fromARGB(255, 47, 45, 69);
const Color primaryC = Color.fromARGB(255, 255, 0, 212);

final ThemeData myLightTheme = ThemeData.light().copyWith(
  visualDensity: VisualDensity.adaptivePlatformDensity,
  primaryColor: primaryC,
  scaffoldBackgroundColor: lightC,
  canvasColor: transparent,
);

final ThemeData myDarkTheme = ThemeData.dark().copyWith(
  visualDensity: VisualDensity.adaptivePlatformDensity,
  primaryColor: primaryC,
  scaffoldBackgroundColor: darkC,
  canvasColor: transparent,
);

const ThemeMode themeMode = ThemeMode.system;

final List<BoxShadow> myShadow = [
  BoxShadow(
    color: black.withOpacity(0.15),
    spreadRadius: 5,
    blurRadius: 8,
    offset: const Offset(2, 2),
  ),
];

final BorderRadius semiRounded = borderRadius(15);
final BorderRadius rounded = borderRadius(200);

const Duration DefaultDuration = Duration(milliseconds: 333);
const Curve DefaultCurve = Curves.fastOutSlowIn;

final UnderlineInputBorder enabledBorder = UnderlineInputBorder(
  borderSide: BorderSide(color: black.withOpacity(0.2), width: 2),
);
const UnderlineInputBorder focusedBorder = UnderlineInputBorder(
  borderSide: BorderSide(color: blue, width: 2),
);
const UnderlineInputBorder errorBorder = UnderlineInputBorder(
  borderSide: BorderSide(color: red, width: 2),
);
