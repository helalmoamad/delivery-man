import 'dart:io';
import 'dart:ui';
import 'package:app_settings/app_settings.dart';
import 'package:delivery_man_app/TrydosChat/di/di_container.dart';
import 'package:delivery_man_app/TrydosChat/presentation/manager/chat_event.dart';
import 'package:delivery_man_app/controllers/Auth/auth_controller.dart';
import 'package:delivery_man_app/message_error_log/device_info_util.dart';
import 'package:delivery_man_app/message_error_log/dio_error_reporting_interceptor.dart';
import 'package:delivery_man_app/message_error_log/errorLogModel.dart';
import 'package:delivery_man_app/message_error_log/error_sender.dart';
import 'package:delivery_man_app/providers/Auth_providers/set_fcm_token_provider.dart';
import 'package:delivery_man_app/routes/routes.dart';
import 'package:delivery_man_app/services/networking/api_config/api_methods.dart';
import 'package:delivery_man_app/services/service_provider.dart';
import 'package:delivery_man_app/shared/constants/color_constants.dart';
import 'package:delivery_man_app/shared/constants/lang_constants.dart';
import 'package:delivery_man_app/shared/global_functions/global_functions.dart';
import 'package:delivery_man_app/themes/themes.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
//import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:smartlook/smartlook.dart';
//import 'package:smartlook/smartlook.dart';
import 'app_bindings.dart';
import 'background_service/background_service.dart';
import 'language/localization.dart';
import 'shared/global_functions/push_notification_service.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

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
late Dio appDio;
// قراءة المفاتيح من --dart-define (آمنة نسبياً)
// const String sentryDsn = String.fromEnvironment('SENTRY_DSN', defaultValue: '');
// const String smartlookKey =
//     String.fromEnvironment('SMARTLOOK_KEY', defaultValue: '');

// Future<void> main() async {
//   myOrderStatusScrollController = ItemScrollController();
//   WidgetsFlutterBinding.ensureInitialized();

//   await dotenv.load(fileName: ".env");
//   await Firebase.initializeApp();
//   /////////////////////////////////////
//   final sharedPreferences = await SharedPreferences.getInstance();
//   Get.put<SharedPreferences>(sharedPreferences);
//   ///////////////// Notification /////////////////////

//   await PushNotificationService.initializeNotification();
//   /////////////////////////////////////
//   await Permission.notification.isDenied.then((value) async {
//     if (value) {
//       await AppSettings.openAppSettings(type: AppSettingsType.notification);
//     }
//   });
//   await configureDependencies();
//   isDependencyInitialized = true;
//   await BackGroundServiceUtils.initializeService();
//   // statusBarColor
//   SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
//     statusBarColor: AppColors.statusBarColor,
//   ));

//   HttpOverrides.global = MyHttpOverrides();

//   // for errors
//   ////////////////////////////////////////////////////////////////////////////
//   Future<String> getCurrentUserId() async {
//     return GlobalFunctions.getUserId().toString();
//   }

//   Future<String> getCurrentToken() async {
//     return GlobalFunctions.getToken();
//   }

//   final deviceInfo = await collectDeviceAndAppInfo();
//   errorSender = ErrorSender(endpoint: 'https://your-backend.com/api/errors');
//   await errorSender.flushPendingLogs();

//   appDio = Dio(BaseOptions(
//     baseUrl: 'https://your-backend.com/',
//     receiveDataWhenStatusError: true,
//   ));

//   appDio.interceptors.add(
//     ErrorReportingInterceptor(
//       sender: errorSender,
//       getUserId: getCurrentUserId,
//       getToken: getCurrentToken,
//       deviceInfo: deviceInfo,
//     ),
//   );

//   FlutterError.onError = (details) async {
//     FlutterError.presentError(details);
//     final log = ErrorLog(
//       type: 'FlutterError',
//       message: details.exceptionAsString(),
//       stackTrace: details.stack?.toString(),
//       appVersion: deviceInfo['appVersion'],
//       platform: deviceInfo['platform'],
//       deviceModel: deviceInfo['deviceModel'],
//       osVersion: deviceInfo['osVersion'],
//       userId: await getCurrentUserId(),
//     );
//     await errorSender.sendError(log);
//   };

//   PlatformDispatcher.instance.onError = (error, stack) {
//     final log = ErrorLog(
//       type: 'AsyncError',
//       message: error.toString(),
//       stackTrace: stack.toString(),
//       appVersion: deviceInfo['appVersion'],
//       platform: deviceInfo['platform'],
//       deviceModel: deviceInfo['deviceModel'],
//       osVersion: deviceInfo['osVersion'],
//     );
//     errorSender.sendError(log);
//     return true;
//   };

// ///////////////////////////////////////////////////////////////////////////
// await SentryFlutter.init(
//   (options) {
//     options.dsn = const String.fromEnvironment('SENTRY_DSN'); // بتحط DSN من --dart-define
//     options.tracesSampleRate = 0.1;
//     options.release = 'lamar_market_mobile@1.0.0';
//     options.environment = 'production';
//   },
//   appRunner: () async {
//     // Smartlook init
//     const smartlookKey = String.fromEnvironment('SMARTLOOK_KEY');
//     if (smartlookKey.isNotEmpty) {
//       Smartlook.setupAndStartRecording(
//         SetupOptions(smartlookAPIKey: smartlookKey),
//       );
//     }

//     runApp(const MyApp());
//   },
// );
// }

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
AuthController auth = AuthController();
SetFcmTokenProvider setFcmTokenProvider = Get.find<SetFcmTokenProvider>();
List<String> lastFourPageVisited = [];
late ErrorSender errorSender;

Future<void> main() async {
  myOrderStatusScrollController = ItemScrollController();
  WidgetsFlutterBinding.ensureInitialized();

  // send errors to backend

  ApiMethodsDelivery.deviceInfo =
      await DeviceInfoHelper.collectDeviceAndAppInfo();

  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp();

  final sharedPreferences = await SharedPreferences.getInstance();
  Get.put<SharedPreferences>(sharedPreferences);

  await PushNotificationService.initializeNotification();
  await Permission.notification.isDenied.then((value) async {
    if (value) {
      await AppSettings.openAppSettings(type: AppSettingsType.notification);
    }
  });

  await configureDependencies();
  isDependencyInitialized = true;
  await BackGroundServiceUtils.initializeService();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: AppColors.statusBarColor,
  ));

  HttpOverrides.global = MyHttpOverrides();

  /////////////////////////////////////////
  ///
  ///
  errorSender = ErrorSender(
    endpoint: dotenv.env['ErrorURLSENDER']!,
  );
  await errorSender.flushPendingLogs();

  ///////////////send fcm to backend//////////////////////////
  var myFcmToken = await FirebaseMessaging.instance.getToken();
  if (myFcmToken != null) {
    var userIdd = await GlobalFunctions.getUserId();
    if (userIdd != null) {
      StoreFcmTokenEvent(userId: userIdd, fcmToken: myFcmToken);
    } else {
      print('no userIdd');
    }
  }

  /////////////////////////////////////////

  // Sentry + Smartlook
  await SentryFlutter.init(
    (options) {
      options.dsn = dotenv.env['SENTRY_DSN'];
      options.tracesSampleRate = 0.1;
    },
    appRunner: () async {
      // var smartlookKey = dotenv.env['SMARTLOOK_KEY'];
      // if (smartlookKey!.isNotEmpty) {
      //   final setupOptions = (SetupOptionsBuilder(smartlookKey)
      //         ..StartNewSession = true
      //         ..Fps = 2)
      //       .build();

      //   await Smartlook.setupAndStartRecording(setupOptions);
      // }
      // تعريف أخطاء Flutter
      FlutterError.onError = (details) async {
        FlutterError.presentError(details);
        final log = await DeviceInfoHelper.createErrorLog(
            errorType: "Flutter Error",
            lastFourPageVisited: lastFourPageVisited,
            errorPath: lastFourPageVisited.last ?? "",
            lastApiRequest: '');
        await errorSender.sendError(log);
        await Sentry.captureException(details.exception,
            stackTrace: details.stack);
      };

      runApp(const MyApp());
    },
  );
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
        navigatorKey: navigatorKey,

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
