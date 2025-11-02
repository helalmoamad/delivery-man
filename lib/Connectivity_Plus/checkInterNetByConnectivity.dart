import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConnectivityService extends GetxController {
  static final Connectivity _connectivity = Connectivity();
  static final RxBool isConnected = true.obs;
  static StreamSubscription<List<ConnectivityResult>>? _subscription;

  static void startListening() {
    _subscription = _connectivity.onConnectivityChanged.listen((results) {
      final result =
          results.isNotEmpty ? results.first : ConnectivityResult.none;
      isConnected.value = result != ConnectivityResult.none;
    });
  }

  static void stopListening() {
    _subscription?.cancel();
  }
}

class ConnectivityWrapper extends StatelessWidget {
  final Widget child;
  const ConnectivityWrapper({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!ConnectivityService.isConnected.value) {
        return const Directionality(
          textDirection: TextDirection.rtl, // أو ltr حسب لغتك
          child: Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.wifi_off, size: 80, color: Colors.redAccent),
                  SizedBox(height: 16),
                  Text(
                    "🚫 لا يوجد اتصال بالإنترنت",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "تحقق من اتصالك بالشبكة وحاول مجددًا.",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      }
      return child;
    });
  }
}
