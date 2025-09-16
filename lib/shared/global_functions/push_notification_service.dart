import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:delivery_man_app/TrydosChat/data/models/my_chats_response_model.dart';
import 'package:delivery_man_app/TrydosChat/di/di_container.dart'
    show configureDependencies;
import 'package:delivery_man_app/TrydosChat/domain/repositories/prefs_repository.dart';
import 'package:delivery_man_app/TrydosChat/presentation/manager/chat_bloc.dart';
import 'package:delivery_man_app/TrydosChat/presentation/manager/chat_event.dart';
import 'package:delivery_man_app/background_service/background_service.dart';
import 'package:delivery_man_app/calls/presentation/bloc/calls_bloc.dart';
import 'package:delivery_man_app/calls/presentation/pages/in_app_view.dart';
import 'package:delivery_man_app/main.dart' as main;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../controllers/Orders/orders_controller.dart';
import '../../routes/routes.dart';
import '../constants/color_constants.dart';
import '../constants/notifications_types.dart';
import 'global_functions.dart';

@pragma('vm:entry-point')
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
  @pragma('vm:entry-point')
  static Future<void> initializeNotification() async {
    await initPushNotification();
    await initLocalNotification();
  }

  @pragma('vm:entry-point')
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

    await flutterLocalNotificationsPlugin
        .getNotificationAppLaunchDetails()
        .then(
      (value) async {
        try {
          if (((int.tryParse(value?.notificationResponse?.payload ?? "") ?? 0) <
              1)) {
            return;
          }
          await prefs.setString('notifi_type', "chat");
          await prefs.setString('order_id',
              (value?.notificationResponse?.payload ?? "").toString());
        } catch (e) {}
      },
    );

    FirebaseMessaging.onMessageOpenedApp.listen(
      (event) {
        if (event.data["type"] == "message") {
          Map remoteMessage = jsonDecode(event.data['data']);
          String orderId = (remoteMessage['order_id'] ?? "").toString();
          handleOpenChatPageFromNotificationInBackground(orderId);
          return;
        }
        GetIt.I<PrefsRepository>().setMyOrderIdForChat("");
        handleMessageBackForGroundOnTap(event);
      },
    );

    FirebaseMessaging.onBackgroundMessage(backgroundTerminateHandler);

    FirebaseMessaging.onMessage.listen(
      (message) {
        print(
            "GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG${message.data}GGGGGGGGGGGGg");

        if (notificationIsChat(message.data["type"])) {
          showNotificationFromChat(message);
          return;
        }

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
                priority: Priority.max,
                importance: Importance.max,
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

  @pragma('vm:entry-point')
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
        if ((int.tryParse(details.payload ?? "") ?? 0) > 0) {
          handleOpenChatPageFromNotificationInBackground(details.payload);
          return;
        }
        GetIt.I<PrefsRepository>().setMyOrderIdForChat("");

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
    if (notificationIsChat(message.data["type"])) {
      showNotificationFromChat(message);
      return;
    }
    debugPrint('Handling a background message ${message.messageId}');
    debugPrint('background message title ${message.notification!.title}');
    debugPrint('background message body${message.notification!.body}');
    debugPrint('background message data${message.data}');
    ///////////////////////////////////////////////////////
    if (message.data['notification_type'] == NotificationsTypes.newOrder) {
      debugPrint('newOrder');
    }
  }

  @pragma('vm:entry-point')
  static void handleOpenChatPageFromNotificationInBackground(
      String? orderId) async {
    GetIt.I<PrefsRepository>().setMyOrderIdForChat(orderId ?? "");
    ordersController.myOrderIdInMarket = int.tryParse(orderId ?? "") ?? 0;
    DealWithMessagesStoredFromBackground();
    DealWithChatsToDeleteFromBackground();
    DealWithChatsToEditStoredFromBackground();
    DealWithRemovedMessageStoredFromBackground();
    DealWithMessageReceivedStatusStoredFromBackground();
    DealWithMessageWatchStatusStoredFromBackground();

    Future.delayed(Duration(milliseconds: 600),
        () => navigationToOrderPageForChat(orderId));
  }

  @pragma('vm:entry-point')
  static void navigationToOrderPageForChat(String? orderId) async {
    await GlobalFunctions.setIsFromNotifiForNewOrder(
        isFromNotifiForNewOrder: true);
    debugPrint(
        '///////isFromNotifiForNewOrder///${GlobalFunctions.getIsFromNotifiForNewOrder()}');
    String token = GlobalFunctions.getToken();
    await ordersController.getMyOrderForChatData(
        token: token, id: orderId ?? "", offset: 1);

    if (Get.currentRoute != Routes.ordersDetailsPage) {
      Get.toNamed(Routes.ordersDetailsPage);
    } else {
      Get.back();
      Future.delayed(const Duration(milliseconds: 600),
          () => Get.toNamed(Routes.ordersDetailsPage));
    }
  }

  @pragma('vm:entry-point')
  static void DealWithMessageWatchStatusStoredFromBackground() async {
    await GetIt.I<SharedPreferences>().reload();

    List<Map>? messagesStatus;
    if ((messagesStatus = GetIt.I<PrefsRepository>()
            .getTheMessageWatchStatusFromBackground) !=
        null) {
      for (int i = 0; i < (messagesStatus?.length ?? 0); i++) {
        GetIt.I<ChatBloc>().add(WatchedMessageFromPusherEvent(
            messagesStatus![i]['channel_id'].toString(),
            messagesStatus[i]['auth_user_id'],
            messagesStatus[i]['last_message_id'],
            DateTime.parse(messagesStatus[i]['watched_at'])));
      }
      GetIt.I<PrefsRepository>().removeMessageWatchStatusFromBackground();
    }
  }

  @pragma('vm:entry-point')
  static void DealWithMessageReceivedStatusStoredFromBackground() async {
    await GetIt.I<SharedPreferences>().reload();

    List<Map>? messagesStatus;
    if ((messagesStatus = GetIt.I<PrefsRepository>()
            .getTheMessageReceivedStatusFromBackground) !=
        null) {
      for (int i = 0; i < (messagesStatus?.length ?? 0); i++) {
        GetIt.I<ChatBloc>().add(ReceiveMessageFromPusherEvent(
            messagesStatus![i]['channel_id'].toString(),
            messagesStatus[i]['auth_user_id'],
            messagesStatus[i]['last_message_id'],
            DateTime.parse(messagesStatus[i]['received_at'])));
      }
      GetIt.I<PrefsRepository>().removeMessageReceivedStatusFromBackground();
    }
  }

  @pragma('vm:entry-point')
  static void DealWithRemovedMessageStoredFromBackground() async {
    await GetIt.I<SharedPreferences>().reload();

    List<Map>? removedMessages;
    if ((removedMessages =
            GetIt.I<PrefsRepository>().getTheRemovedMessageFromBackground) !=
        null) {
      for (int i = 0; i < (removedMessages?.length ?? 0); i++) {
        GetIt.I<CallsBloc>().add(DeleteMessageNotificationReceivedInCallsEvent(
            channelId: removedMessages![i]['message']["channel_id"],
            messageId: removedMessages[i]['message']["id"],
            deleteFromBoth: removedMessages[i]['message']["auth_message_status"]
                    ["delete_for_all"]
                ? 1
                : 0,
            type: !removedMessages[i]['message']["message_type"]["name"]
                    .toString()
                    .contains('Call')
                ? "message"
                : "call",
            deleteFromId:
                removedMessages[i]['message']["deleted_by_user_id"] ?? 0));
      }
      GetIt.I<PrefsRepository>().removeRemovedMessageFromBackground();
    }
  }

  @pragma('vm:entry-point')
  static void DealWithChatsToEditStoredFromBackground() async {
    await GetIt.I<SharedPreferences>().reload();
    List<Chat>? chats;
    if ((chats = GetIt.I<PrefsRepository>().getTheChatsToEditFromBackground) !=
        null) {
      for (int i = 0; i < (chats?.length ?? 0); i++) {
        GetIt.I<ChatBloc>()
            .add(UpdateChannelObjectFromNotificationEvent(chat: chats![i]));
      }
      GetIt.I<PrefsRepository>().removeChatToEditFromBackground();
    }
  }

  @pragma('vm:entry-point')
  static void DealWithMessagesStoredFromBackground() async {
    await GetIt.I<SharedPreferences>().reload();
    List<ChatMessage>? messages;
    if ((messages = GetIt.I<PrefsRepository>().getTheMessageFromBackground) !=
        null) {
      for (int i = 0; i < (messages?.length ?? 0); i++) {
        print(messages![i].messageContent?.content);
        GetIt.I<ChatBloc>().add(AddChannelToChannels(message: messages[i]));
        GetIt.I<ChatBloc>().add(
            ReceiveMessageEvent(message: messages[i], prevMessageId: null));
      }
      GetIt.I<PrefsRepository>().removeMessageFromBackground();
    }
  }

  @pragma('vm:entry-point')
  static void DealWithChatsToDeleteFromBackground() async {
    await GetIt.I<SharedPreferences>().reload();
    List<String>? ids;
    if ((ids =
            GetIt.I<PrefsRepository>().getTheChatsIdsToRemoveFromBackground) !=
        null) {
      for (int i = 0; i < (ids?.length ?? 0); i++) {
        GetIt.I<ChatBloc>()
            .add(DeleteChatFromNotificationEvent(channelId: ids![i]));
      }
      GetIt.I<PrefsRepository>().removeChatsFromBackground();
    }
  }

  @pragma('vm:entry-point')
  static void handleMessageBackForGroundOnTap(RemoteMessage? message) async {
    if (message == null) {
      debugPrint('//// Message Navigation null ////');
    } else {
      debugPrint('//// handle Message Navigation ////');
      /////////////////////////////////////////////////////
      if (message.data['notification_type'] == NotificationsTypes.newOrder ||
          message.data['notification_type'] ==
              NotificationsTypes.orderRequiresAssingment ||
          message.data['notification_type'] ==
              NotificationsTypes.orderRequiresShipping) {
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
            );
          }
        }
      }
    }
  }

  @pragma('vm:entry-point')
  static void handleTerminatedMessageOnTap(RemoteMessage? message) async {
    if (message == null) {
      debugPrint('//// Message On Tap null ////');
    } else {
      debugPrint('////Terminate handle Message On Tap ////');
      ///////////////////////////////////////////////////////////////////
      if (message.data['notification_type'] == NotificationsTypes.newOrder ||
          message.data['notification_type'] ==
              NotificationsTypes.orderRequiresAssingment ||
          message.data['notification_type'] ==
              NotificationsTypes.orderRequiresShipping) {
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

  static bool notificationIsChat(String? typeMessage) {
    return typeMessage == "RefuseCallEvent" ||
        typeMessage == "VoiceCallEvent" ||
        typeMessage == "VideoCallEvent" ||
        typeMessage == "AnswerCallEvent" ||
        typeMessage == "ChannelDeletedEvent" ||
        typeMessage == "UpdatingMessageEvent" ||
        typeMessage == "ChannelUpdatedEvent" ||
        typeMessage == "ChannelWatchedEvent" ||
        typeMessage == "ChannelReceivedEvent" ||
        typeMessage == "message";
  }

  @pragma('vm:entry-point')
  static void showNotificationFromChat(RemoteMessage? remoteMessages) async {
    if (!main.isDependencyInitialized) {
      HttpOverrides.global = MyHttpOverrides();
      await dotenv.load(fileName: ".env");
      await configureDependencies();
      main.isDependencyInitialized = true;
    }

    Map<String, dynamic> remoteMessage = remoteMessages?.data ?? {};
    remoteMessage = jsonDecode(remoteMessage["data"]);

    if (remoteMessage['type'] == 'RefuseCallEvent') {
      Map<String, dynamic> data = remoteMessage;
      GetIt.I<PrefsRepository>().saveRequestsData(
          null, null, null, null, null, null, null,
          error: 'RefuseCall for message ForeGround ${data['message_id']}');
      if (data['duration_in_seconds']!.toString().contains("-1")) {
        GetIt.I<ChatBloc>().add(ReceiveMissCallEvent(true,
            channelId: data['channel_id'].toString()));
        GetIt.I<CallsBloc>().add(IcreaseMissedCallEvent());
      }
      if ((data['message_id'].toString() !=
              GetIt.I<CallsBloc>().state.currentActiveCallId) &&
          GetIt.I<CallsBloc>().state.currentActiveCallId != '-1') {
        return;
      }

      FlutterCallkitIncoming.endAllCalls();
      GetIt.I<CallsBloc>().add(UserInteractWithCall(rejectIt: true));
      /*if (navigatorKey.currentState!.context.canPop() &&
          navigatorKey.currentState!.context.widget is! SinglePageChat) {
        navigatorKey.currentState!.context.pop();
      }*/
    } else if (remoteMessage['type'] == 'VideoCallEvent') {
      GetIt.I<PrefsRepository>().saveRequestsData(
          null, null, null, null, null, null, null,
          error: 'VideoCallEvent ForeGround Message');
      ChatMessage? message;
      try {
        message = ChatMessage.fromJson(remoteMessage['message']);
        GetIt.I<CallsBloc>()
            .add(UpdateCurrentActiveCallIdEvent(id: message.id.toString()));
      } catch (e) {
        GetIt.I<PrefsRepository>().saveRequestsData(
            null, null, null, null, null, null, null,
            error: 'VideoCallEvent Error ${e.toString()}');
      }
      GetIt.I<ChatBloc>().add(AddChannelToChannels(message: message!));
      GetIt.I<ChatBloc>().add(
          ReceiveMessageEvent(message: message, increaseUnReadMessages: false));
      /*  Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => AgoraInAppWebView(
            messageId: message!.id.toString(),
            action: 'receive',
            type: 'video',
            channelId: message.channelId.toString(),
            auth_token: GetIt.I<PrefsRepository>().chatToken!,
            uId: GetIt.I<PrefsRepository>().myChatId!.toString()),
      ));*/
    } else if (remoteMessage['type'] == 'VoiceCallEvent') {
      print(remoteMessage);
      GetIt.I<PrefsRepository>().saveRequestsData(
          null, null, null, null, null, null, null,
          error: 'VoiceCallEvent ForeGround Message');
      ChatMessage? message;
      try {
        message = ChatMessage.fromJson(remoteMessage['message']);

        GetIt.I<CallsBloc>()
            .add(UpdateCurrentActiveCallIdEvent(id: message.id.toString()));
      } catch (e) {
        GetIt.I<PrefsRepository>().saveRequestsData(
            null, null, null, null, null, null, null,
            error: 'VoiceCallEvent Error ${e.toString()}');
      }
      GetIt.I<ChatBloc>().add(AddChannelToChannels(message: message!));
      GetIt.I<ChatBloc>().add(
          ReceiveMessageEvent(message: message, increaseUnReadMessages: false));
      /* Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => AgoraInAppWebView(
            messageId: message!.id.toString(),
            action: 'receive',
            type: 'voice',
            channelId: message.channelId.toString(),
            auth_token: GetIt.I<PrefsRepository>().chatToken!,
            uId: GetIt.I<PrefsRepository>().myChatId!.toString()),
      ));*/
    } else if (remoteMessage['type'] == 'AnswerCallEvent') {
      Map<String, dynamic> data = remoteMessage;
      GetIt.I<PrefsRepository>().saveRequestsData(
          null, null, null, null, null, null, null,
          error: 'AnswerCallEvent Message');
      debugPrint(
          'GetIt.I<CallsBloc>().add(UserInteractWithCall(rejectIt: false))');
      if (data['message_id'].toString() !=
              GetIt.I<CallsBloc>().state.currentActiveCallId &&
          GetIt.I<CallsBloc>().state.currentActiveCallId != '-1') {
        return;
      }
      /* if (GetIt.I<PrefsRepository>().myChatId.toString() ==
              data['user']['id'].toString() &&
          navigatorKey.currentState!.context.canPop() &&
          navigatorKey.currentState!.context.widget is! SinglePageChat) {
        navigatorKey.currentState!.context.pop();
      }*/
      GetIt.I<CallsBloc>().add(UserInteractWithCall(rejectIt: false));
    } else if (remoteMessage['type'] == 'ChannelDeletedEvent') {
      Map<String, dynamic> data = remoteMessage;
      GetIt.I<ChatBloc>()
          .add(DeleteChatFromNotificationEvent(channelId: data['channelId']));
    } else if (remoteMessage['type'] == 'UpdatingMessageEvent') {
      Map<String, dynamic> data = remoteMessage['message'];
      GetIt.I<CallsBloc>().add(DeleteMessageNotificationReceivedInCallsEvent(
          channelId: data["channel_id"],
          messageId: data["id"],
          deleteFromBoth: data["auth_message_status"]["delete_for_all"] ? 1 : 0,
          type: !data["message_type"]["name"].toString().contains('Call')
              ? "message"
              : "call",
          deleteFromId: data["deleted_by_user_id"] ?? 0));
    } else if (remoteMessage['type'] == 'ChannelUpdatedEvent') {
      Map<String, dynamic> data = remoteMessage;
      GetIt.I<ChatBloc>().add(UpdateChannelObjectFromNotificationEvent(
          chat: Chat.fromJson(data['channel'])));
    } else if (remoteMessage['type'] == 'ChannelWatchedEvent') {
      Map<String, dynamic> data = remoteMessage;
      GetIt.I<ChatBloc>().add(WatchedMessageFromPusherEvent(
        data['channel_id'].toString(),
        data['auth_user_id'],
        data['last_message_id'],
        DateTime.parse(data['watched_at']),
      ));
    } else if (remoteMessage['type'] == 'ChannelReceivedEvent') {
      Map<String, dynamic> data = remoteMessage;
      GetIt.I<ChatBloc>().add(ReceiveMessageFromPusherEvent(
          data['channel_id'].toString(),
          data['auth_user_id'],
          data['last_message_id'],
          DateTime.parse(data['received_at'])));
    } else {
      ChatMessage message = ChatMessage.fromJson(remoteMessage['message']);
      String prevMessageId = remoteMessage['prev_message_id'].toString();
      GetIt.I<ChatBloc>().add(AddChannelToChannels(message: message));
      GetIt.I<ChatBloc>().add(
          ReceiveMessageEvent(message: message, prevMessageId: prevMessageId));
      if (message.senderUserId != GetIt.I<PrefsRepository>().myChatId) {
        GetIt.I<ChatBloc>().add(
            NotifyThatIReceivedMessageEvent(channelId: message.channelId!));
      }

      if (GetIt.I<ChatBloc>().state.currentOpenedChatId != message.channelId &&
          message.channel!.channelMembers!
                  .firstWhere((element) =>
                      element.userId == GetIt.I<PrefsRepository>().myChatId)
                  .mute !=
              1 &&
          message.senderUserId != GetIt.I<PrefsRepository>().myChatId) {
        final Random random = Random();
        final int notificationId = random.nextInt(1000000);

        Map remoteMessage = jsonDecode(remoteMessages?.data['data']);
        ChatMessage myMessage = ChatMessage.fromJson(remoteMessage["message"]);
        String prevMessageId =
            (remoteMessage['prev_message_id'] ?? "").toString();
        String orderId = (remoteMessage['order_id'] ?? "").toString();
        String orderGroupId =
            (remoteMessage['order_group_id'] ?? "").toString();
        String type = myMessage.messageType!.name.toString();

        await flutterLocalNotificationsPlugin.show(
            notificationId,
            myMessage.channel?.channelName ?? 'No Channel Name',
            type == 'TextMessage'
                ? myMessage.messageContent!.content.toString()
                : type == 'ImageMessage'
                    ? 'Photo'
                    : type == 'VoiceMessage'
                        ? 'Voice'
                        : type == 'VideoMessage'
                            ? 'Video'
                            : 'File',
            NotificationDetails(
              android: AndroidNotificationDetails(
                priority: Priority.max,
                androidChannel.id,
                androidChannel.name,
                importance: Importance.max,
                tag: myMessage.channel?.id,
                groupKey: myMessage.channel?.id,
                setAsGroupSummary: true,
                channelDescription: androidChannel.description,
                color: AppColors.primaryDark,
                playSound: true,
                icon: '@mipmap/ic_launcher',
              ),
            ),
            payload: orderId);
      }
    }
  }
}
