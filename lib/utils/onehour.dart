import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OneHour {
  static const String app_name = "OneHour";
  static const String app_version = "Version 1.0.0";
  static const int app_version_code = 1;
  static const String app_color = "#ffd7167";
  static const Color primarySwatch = Color.fromRGBO(234, 128, 252, 1);
  static const Color textColor = Color.fromRGBO(255, 238, 204, 1);
  static Color primaryColor = Colors.black;
  static Color secondaryColor = Colors.white;
  static const String myriad_pro_family = "MyriadPro";
  static bool isDebugMode = true;
  static SharedPreferences prefs;

  static checkDebug() {
    assert(() {
      // * run any other checks to see if all the debug variable are
      // * swapped with production ones
      isDebugMode = true;
      return true;
    }());
  }

  static bool get checkDebigBool {
    var debug = false;

    assert(debug = true);

    return debug;
  }
}
