import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../controllers/Orders/orders_controller.dart';
import '../../routes/routes.dart';
import '../constants/color_constants.dart';
import '../constants/notifications_types.dart';
import 'global_functions.dart';

class PushNotificationService {
  static SharedPreferences prefs = Get.find<SharedPreferences>();

  static final OrdersController ordersController = Get.find<OrdersController>();

  static final firebaseMessaging = FirebaseMessaging.instance;

  static final flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const androidChannel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    importance: Importance.max,
    playSound: true,
  );

  static Future<void> initializeNotification() async {
    await initPushNotification();
    await initLocalNotification();
  }

  static Future<void> initPushNotification() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    await FirebaseMessaging.instance
        .getInitialMessage()
        .then(handleTerminatedMessageOnTap);

    FirebaseMessaging.onMessageOpenedApp
        .listen(handleMessageBackForGroundOnTap);

    FirebaseMessaging.onBackgroundMessage(backgroundTerminateHandler);

    FirebaseMessaging.onMessage.listen(
      (message) {
        final notification = message.notification;
        if (notification == null) return;

        debugPrint(
            '//////////////forground notification come //////////////////');
        AndroidNotification? androidNotification =
            message.notification?.android;
        if (androidNotification != null) {
          flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                androidChannel.id,
                androidChannel.name,
                channelDescription: androidChannel.description,
                color: AppColors.primaryDark,
                playSound: true,
                icon: '@mipmap/ic_launcher',
              ),
            ),
            payload: jsonEncode(message.toMap()),
          );
        }
      },
    );
  }

  static Future<void> initLocalNotification() async {
    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      onDidReceiveLocalNotification: (id, title, body, payload) {},
    );
    const LinuxInitializationSettings initializationSettingsLinux =
        LinuxInitializationSettings(defaultActionName: 'Open notification');

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
      linux: initializationSettingsLinux,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        final message = RemoteMessage.fromMap(
          jsonDecode(details.payload!),
        );
        handleMessageBackForGroundOnTap(message);
      },
    );

    final platform =
        flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    await platform?.createNotificationChannel(androidChannel);
  }

  @pragma('vm:entry-point')
  static Future<void> backgroundTerminateHandler(RemoteMessage message) async {
    debugPrint('Handling a background message ${message.messageId}');
    debugPrint('background message title ${message.notification!.title}');
    debugPrint('background message body${message.notification!.body}');
    debugPrint('background message data${message.data}');
    ///////////////////////////////////////////////////////
    if (message.data['notification_type'] == NotificationsTypes.newOrder) {
      debugPrint('newOrder');
    }
  }

  static void handleMessageBackForGroundOnTap(RemoteMessage? message) async {
    if (message == null) {
      debugPrint('//// Message Navigation null ////');
    } else {
      debugPrint('//// handle Message Navigation ////');
      /////////////////////////////////////////////////////
      if (message.data['notification_type'] == NotificationsTypes.newOrder) {
        debugPrint('//// Navigate to orderDetails page ////');

        if (ordersController.isRecording) {
          debugPrint('//////// isRecording ///////');
        } else {
          debugPrint('//////// is Not Recording ///////');
          await GlobalFunctions.setIsFromNotifiForNewOrder(
              isFromNotifiForNewOrder: true);
          debugPrint(
              '///////isFromNotifiForNewOrder///${GlobalFunctions.getIsFromNotifiForNewOrder()}');

          await GlobalFunctions.setOrderId(
              orderId: message.data['order_id'] ?? '0');

          if (Get.currentRoute != Routes.ordersDetailsPage) {
            Get.toNamed(Routes.ordersDetailsPage);
          } else {
            String token = GlobalFunctions.getToken();
            ///////////////////////////////////////////
            await ordersController.getOrderDetailsData(
              token: token,
              orderId: int.parse(GlobalFunctions.getOrderId() ?? '-1'),
              isForMyOrder: false,
              isFromNotifiOrder: true,
            );
          }
        }
      }
    }
  }

  static void handleTerminatedMessageOnTap(RemoteMessage? message) async {
    if (message == null) {
      debugPrint('//// Message On Tap null ////');
    } else {
      debugPrint('////Terminate handle Message On Tap ////');
      ///////////////////////////////////////////////////////////////////
      if (message.data['notification_type'] == NotificationsTypes.newOrder) {
        debugPrint('//// Navigate to order page from Terminate////');
        await prefs.setString('notifi_type', NotificationsTypes.newOrder);
        await prefs.setString('order_id', message.data['order_id'] ?? '-1');
      }
    }
  }

  static Future<String?> getToken() async {
    String? token = await firebaseMessaging.getToken();
    debugPrint('Fcm Token: $token');
    return token;
  }
}
