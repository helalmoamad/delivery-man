import 'package:flutter/material.dart';

class ScreenSizeUtils {
//////////////////////////////////////////////////
  static double getHeightInPercent(BuildContext context, double percent) {
    return (MediaQuery.of(context).size.height) * (percent / 100);
  }

////////////////////////////////////////////////////////////////
  static double getWidthInPercent(BuildContext context, double percent) {
    return (MediaQuery.of(context).size.width) * (percent / 100);
  }

////////////////////////////////////////////////////////////////
  static double getSp(BuildContext context, double percent) {
    return (MediaQuery.of(context).size.width) * (percent / 300);
  }
}
