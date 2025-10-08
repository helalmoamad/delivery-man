import 'package:delivery_man_app/TrydosChat/chat_utils/prefs_key.dart';
import 'package:delivery_man_app/message_error_log/errorLogModel.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeviceInfoHelper {
  static Future<Map<String, dynamic>> collectDeviceAndAppInfo() async {
    final Map<String, dynamic> info = {};
    final deviceInfoPlugin = DeviceInfoPlugin();
    final deviceInfo = await deviceInfoPlugin.deviceInfo;
    final packageInfo = await PackageInfo.fromPlatform();

    try {
      if (deviceInfo is AndroidDeviceInfo) {
        info['platform'] = 'android';
        info['deviceModel'] = '${deviceInfo.manufacturer} ${deviceInfo.model}';
        info['osVersion'] =
            'Android ${deviceInfo.version.release} (SDK ${deviceInfo.version.sdkInt})';
      } else if (deviceInfo is IosDeviceInfo) {
        info['platform'] = 'ios';
        info['deviceModel'] = '${deviceInfo.name} ${deviceInfo.model}';
        info['osVersion'] = 'iOS ${deviceInfo.systemVersion}';
      } else {
        info['platform'] = 'unknown';
        info['deviceModel'] = deviceInfo.toMap().toString();
        info['osVersion'] = '';
      }
    } catch (_) {
      info['platform'] = 'unknown';
      info['deviceModel'] = 'unknown';
      info['osVersion'] = 'unknown';
    }

    // إضافة معلومات التطبيق
    info['flutterVersion'] = packageInfo.version;
    info['deviceInfo'] =
        '${info['platform']} | ${info['deviceModel']} | ${info['osVersion']}';

    return info;
  }

  static Future<ErrorLog> createErrorLog({
  required String errorType,
  List<String>? lastFourPageVisited,
  String? urlBackend,
  String? messageFromBackend,
  String? lastApiRequest,
  String? errorPath,
}) async {
  final prefs = await SharedPreferences.getInstance();
  final deviceInfo = await collectDeviceAndAppInfo();
  final packageInfo = await PackageInfo.fromPlatform();

  return ErrorLog(
    flutterVersion: '1',
    deviceInfo:
        '${deviceInfo['platform'] ?? ''} | ${deviceInfo['deviceModel'] ?? ''} | ${deviceInfo['osVersion'] ?? ''}',
    clientIp: '',
    errorType: errorType,
    lastFourPageVisited: lastFourPageVisited,
    userChatId: prefs.getInt(PrefsKey.userChatId),
    userChatToken: prefs.getString(PrefsKey.chatToken),
    userChatPhoto: prefs.getString(PrefsKey.chatPhoto),
    userChatName: prefs.getString(PrefsKey.chatName),
    userFleetId: prefs.getInt('userId'),
    userFleetName: prefs.getString('name'),
    userFleetToken: prefs.getString('token'),
    isLoggedIn: prefs.getBool('isLoggedIn'),
    language: prefs.getString('lang'),
    urlBackend: urlBackend,
    messageFromBackend: messageFromBackend,
    lastApiRequest: prefs.getString('lastApi'),
    errorPath: errorPath,
    timestamp: DateTime.now(),
  );
}
}
