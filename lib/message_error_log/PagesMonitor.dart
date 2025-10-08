import 'package:delivery_man_app/main.dart';

class PagesMonitor {
  static void addPageToList({required String page}) {
    var len = lastFourPageVisited.length;
    if (len >= 4) {
      lastFourPageVisited.removeAt(0);
      lastFourPageVisited.add(page);
    } else {
      lastFourPageVisited.add(page);
    }
  }
}
