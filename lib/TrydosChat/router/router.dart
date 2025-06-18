import 'package:delivery_man_app/TrydosChat/presentation/pages/chat_pages.dart';
import 'package:delivery_man_app/TrydosChat/presentation/pages/contacts_page.dart';
import 'package:delivery_man_app/TrydosChat/presentation/pages/single_page_chat.dart';
import 'package:delivery_man_app/TrydosChat/router/router_config.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GRouter {
  static GoRouter get router => _router;

  static RouterConfiguration get config => _config;

  static final RouterConfiguration _config = RouterConfiguration.init();

  static final GoRouter _router = GoRouter(
    observers: [],
    // initialLocation: _config.applicationRoutes.kWebView,
    navigatorKey: navigatorKey,
    routes: <RouteBase>[
      // GoRoute(
      //     path: _config.applicationRoutes.kWebView,
      //     pageBuilder: (BuildContext context, GoRouterState state) {
      //       return _builderPage(
      //         child: AgoraWebView(
      //           type: 'video',
      //           channelId: '155',
      //           uId: '6',
      //           message_id: '',
      //           action: '',
      //           auth_token: '',
      //         ),
      //         state: state,
      //       );
      //     }),

      // GoRoute(
      //   path: _config.applicationRoutes.kAnswerCall,
      //   pageBuilder: (BuildContext context, GoRouterState state) {
      //     return _builderPage(
      //       child: AnswerCall(
      //         channelName: state.uri.queryParameters['channelName']!,
      //         messageId: state.uri.queryParameters['messageId']!,
      //         callerName: state.uri.queryParameters['callerName']!,
      //         callerPhoto: state.uri.queryParameters['callerPhoto']!,
      //       ),
      //       state: state,
      //     );
      //   },
      // ),

      GoRoute(
        path: _config.applicationRoutes.kChatPage,
        pageBuilder: (BuildContext context, GoRouterState state) {
          void Function(int, String) onSendForwardMessage =
              state.extra as void Function(int, String);
          return _builderPage(
            child: ChatPages(
              description: state.uri.queryParameters['description']!,
              // ignore: sdk_version_since
              hideCallsAndStories:
                  bool.parse(state.uri.queryParameters['hideCallsAndStories']!),
              onSendForwardMessage: onSendForwardMessage,
            ),
            state: state,
          );
        },
      ),
    ],
    errorBuilder: (context, state) => Container(
      color: Colors.red,
    ),
  );

  static Page<dynamic> _builderPage<T>(
      {required Widget child, required GoRouterState state}) {
    //if (Platform.isIOS) {
    return MaterialPage<T>(child: child, key: state.pageKey);
  }
}
