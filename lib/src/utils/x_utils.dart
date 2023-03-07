// ignore: depend_on_referenced_packages
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:lib_x/lib_x.dart';

/// XU short for X Utilities
abstract class XUtils {
  /// check if string is url
  static bool isUrl(String url) => Uri.parse(url).host.isNotEmpty;

  /// check if path starts with assets/
  static bool isAsset(String path) => path.startsWith('assets/');

  /// check if path contains .svg
  static bool isSVG(String path) => path.contains('.svg');

  /// returns if system is in dark mode
  static bool get isSysDarkMode =>
      SchedulerBinding.instance.platformDispatcher.platformBrightness ==
      Brightness.dark;

  /// returns the system's current themeMode
  static ThemeMode get sysThemeMode =>
      isSysDarkMode ? ThemeMode.dark : ThemeMode.light;

  /// returns the int value of now timestamp in seconds
  static int get now => DateTime.now().millisecondsSinceEpoch ~/ 1000;

  /// convert timestamp to readable format
  /// if today: returns [Hours:Minutes AM/PM] e.g. 5:30 PM
  /// if yesterday: returns [Yesterday - Hour AM/PM] e.g. Yesterday - 8 AM
  /// if same year: returns [Month Day] e.g. May 29
  /// else: returns [Month Day Year] e.g. Jan. 25 2011
  /// default month format is short e.g. January becomes Jan.
  static String formatTimestamp(int timestamp, {bool shortMonthFormat = true}) {
    late String d12;
    final DateTime now = DateTime.now();
    final DateTime dt = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);

    final int diffdays = dt.day - now.day;
    final int diffYears = dt.year - now.year;

    if (diffdays == 0) {
      d12 = DateFormat('hh:mm a').format(dt);
    } else if (diffdays == -1) {
      d12 = 'Yesterday - ${DateFormat('hh a').format(dt)}';
    } else {
      d12 = diffYears == 0
          ? DateFormat('MMMM d').format(dt)
          : DateFormat('MMMM d, yyyy').format(dt);
    }

    return shortMonthFormat ? d12.shortMonth() : d12;
  }

  /// letters string
  static const String chars =
      '_AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz0123456789';

  /// numbers string
  static const String numbers = '0123456789';

  /// check if a string is a number e.g. '123' returns true, '+1' returns false
  static bool isNumeric(String str) {
    final RegExp exp = RegExp(r'^-?[0-9]+$');
    return exp.hasMatch(str);
  }

  /// if string is a valid email format based on the HTML5 email validation specs
  static bool isEmail(String email) {
    final RegExp exp = RegExp(
      r"""
      [a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]
      +@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\
      .[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$
      """,
    );
    return exp.hasMatch(email);
  }

  /// to generate random string with default length value of 16
  static String genString({int length = 16}) {
    final String randomString = List.generate(
      length,
      (_) => chars[Random().nextInt(chars.length)],
    ).join();

    return randomString;
  }

  /// to generate random number string with default length value of 16
  static String genNum({int length = 16}) {
    final String randomString = List.generate(
      length,
      (_) => numbers[Random().nextInt(numbers.length)],
    ).join();

    return randomString;
  }

  /// to generate timestamp based id string
  static String genId({int length = 16}) =>
      genString(length: length) + now.toString();
}
