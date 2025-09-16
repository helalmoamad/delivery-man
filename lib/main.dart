import 'dart:io';
import 'package:app_settings/app_settings.dart';
import 'package:delivery_man_app/TrydosChat/di/di_container.dart';
import 'package:delivery_man_app/routes/routes.dart';
import 'package:delivery_man_app/services/service_provider.dart';
import 'package:delivery_man_app/shared/constants/color_constants.dart';
import 'package:delivery_man_app/shared/constants/lang_constants.dart';
import 'package:delivery_man_app/shared/global_functions/global_functions.dart';
import 'package:delivery_man_app/themes/themes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_bindings.dart';
import 'background_service/background_service.dart';
import 'language/localization.dart';
import 'shared/global_functions/push_notification_service.dart';

MaterialColor getMaterialColor(Color color) {
  final int red = color.red;
  final int green = color.green;
  final int blue = color.blue;

  final Map<int, Color> shades = {
    50: Color.fromRGBO(red, green, blue, .1),
    100: Color.fromRGBO(red, green, blue, .2),
    200: Color.fromRGBO(red, green, blue, .3),
    300: Color.fromRGBO(red, green, blue, .4),
    400: Color.fromRGBO(red, green, blue, .5),
    500: Color.fromRGBO(red, green, blue, .6),
    600: Color.fromRGBO(red, green, blue, .7),
    700: Color.fromRGBO(red, green, blue, .8),
    800: Color.fromRGBO(red, green, blue, .9),
    900: Color.fromRGBO(red, green, blue, 1),
  };

  return MaterialColor(color.value, shades);
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

late ItemScrollController myOrderStatusScrollController;
bool isDependencyInitialized = false;
bool isAssignToMeForReturnOrder = false;
Future<void> main() async {
  myOrderStatusScrollController = ItemScrollController();
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp();
  /////////////////////////////////////
  final sharedPreferences = await SharedPreferences.getInstance();
  Get.put<SharedPreferences>(sharedPreferences);
  ///////////////// Notification /////////////////////

  await PushNotificationService.initializeNotification();
  /////////////////////////////////////
  await Permission.notification.isDenied.then((value) async {
    if (value) {
      await AppSettings.openAppSettings(type: AppSettingsType.notification);
    }
  });
  await configureDependencies();
  isDependencyInitialized = true;
  await BackGroundServiceUtils.initializeService();
  // statusBarColor
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: AppColors.statusBarColor,
  ));

  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return ServiceProvider(
      child: GetMaterialApp(
        title: 'Delivery Man',
        debugShowCheckedModeBanner: false,
        theme: Themes.lightTheme,
        //for language
        locale: Locale(GlobalFunctions.getLanLocal()),
        fallbackLocale: const Locale(LangConstants.ene),
        translations: LocalizationApp(),
        ////
        getPages: AppRoutes.routes,
        initialRoute: Routes.splashPage,
        initialBinding: AppBinding(),
      ),
    );
  }
}
