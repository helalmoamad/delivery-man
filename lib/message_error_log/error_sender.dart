// lib/core/error_reporting/error_sender.dart
import 'dart:convert';
import 'package:delivery_man_app/message_error_log/errorLogModel.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ErrorSender {
  final Dio dio;
  final String endpoint;
  static const _pendingKey = 'unsent_error_logs';

  ErrorSender({Dio? dio, required this.endpoint}) : dio = dio ?? Dio();

  Future<void> sendError(ErrorLog log) async {
    try {
      await dio.post(endpoint, data: log.toJson());
    } catch (e) {
      await _saveLocally(log);
    }
  }

  Future<void> _saveLocally(ErrorLog log) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> list = prefs.getStringList(_pendingKey) ?? [];
    list.add(log.toJsonString());
    await prefs.setStringList(_pendingKey, list);
  }

  Future<void> flushPendingLogs() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> list = prefs.getStringList(_pendingKey) ?? [];
    if (list.isEmpty) return;

    final successIndexes = <int>[];
    for (var i = 0; i < list.length; i++) {
      final s = list[i];
      try {
        final map = jsonDecode(s) as Map<String, dynamic>;
        await dio.post(endpoint, data: map);
        successIndexes.add(i);
      } catch (e) {}
    }

    if (successIndexes.isNotEmpty) {
      final remaining = <String>[];
      for (var i = 0; i < list.length; i++) {
        if (!successIndexes.contains(i)) remaining.add(list[i]);
      }
      await prefs.setStringList(_pendingKey, remaining);
    }
  }
}
