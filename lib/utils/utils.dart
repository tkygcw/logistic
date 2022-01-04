import 'package:driver_app/translation/app_localizations.dart';
import 'package:flutter/material.dart';

class Utils {
  /*
  * remove double's decimal if behind is .00 / .0
  * */
  static numDetector(String value) {
    try {
      List split = value.split('.');
      //if is decimal value
      if (split.length > 1) {
        //if value after dot (.xx) is smaller than 0
        if (int.parse(split[1]) <= 0) {
          return split[0];
        } else {
          return double.parse(value).toStringAsFixed(2);
        }
      } else {
        return value;
      }
    } catch (e) {
      return value;
    }
  }

  /*
  * remove double's decimal if behind is .00 / .0
  * */
  static getText(context, label) {
    return AppLocalizations.of(context)?.translate(label);
  }

  static String idPrefix(orderID) {
    String prefix = '';
    for (int i = orderID.length; i < 5; i++) {
      prefix = prefix + "0";
    }
    return '#' + prefix + orderID;
  }

  static getPhoneNumber(phone) {
    try {
      String firstTwoDigits = phone.substring(0, 2);
      if (firstTwoDigits == '60' || firstTwoDigits == '65') {
        return phone;
      }
      return '6$phone';
    } catch (e) {
      return '6$phone';
    }
  }

  static showSnackBar(context, label) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(Utils.getText(context, label)),
    ));
  }

  static MaterialColor white = const MaterialColor(
    0xFFFFFFFF,
    <int, Color>{
      50: Color(0xFFFFFFFF),
      100: Color(0xFFFFFFFF),
      200: Color(0xFFFFFFFF),
      300: Color(0xFFFFFFFF),
      400: Color(0xFFFFFFFF),
      500: Color(0xFFFFFFFF),
      600: Color(0xFFFFFFFF),
      700: Color(0xFFFFFFFF),
      800: Color(0xFFFFFFFF),
      900: Color(0xFFFFFFFF),
    },
  );
}
