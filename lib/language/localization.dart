import 'package:get/get.dart';
import '../shared/constants/lang_constants.dart';
import 'arabic.dart';
import 'english.dart';

class LocalizationApp extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        LangConstants.ara: ar,
        LangConstants.ene: en,
      };
}
