import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class HttpClientService extends GetxService {
  late http.Client _client;
  late http.Client _secondaryClient;

  http.Client get client => _client;
  http.Client get secondaryClient => _secondaryClient;

  @override
  void onInit() {
    super.onInit();
    _client = http.Client();
    _secondaryClient = http.Client();
    debugPrint('init Client');
  }

  @override
  void onClose() {
    closeClient();
    super.onClose();
  }

  void closeClient() {
    closeClient();
    closeSecondaryClient();
    debugPrint('closeClient');
  }

  void reOpenClient() {
    _client = http.Client();
    debugPrint('reopenClient');
  }

  void reOpenSecondaryClient() {
    _secondaryClient = http.Client();
    debugPrint('reOpenSecondaryClient');
  }

  void closeSecondaryClient() {
    _secondaryClient.close();
    debugPrint('closeSecondaryClient');
  }
}
