class RouterConfiguration {
  RouterConfiguration.init();

  final String kRootRoute = '/';
  final applicationRoutes = _ApplicationRoutes();
}

class _ApplicationRoutes {
  final String kWebView = '/WebView';

  final String kRoomCallPage = '/RoomCallPage';
  final String kAnswerCall = '/AnswerCall';
  final String kSinglePageChatPageName = 'SinglePageChatPage';

  final String kSinglePageChatPagePath = '/BasePage/SinglePageChatPage';

  final String kMyContactsPageName = 'MyContacts';
  final String kMyContactsPagePath = '/BasePage/MyContacts';

  final String kChatPage = '/ChatPage';
}
