import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TimerService extends GetxService {
  Timer? _globalTimer;
  Timer? _secondaryTimer;

  Timer get globalTimer => _globalTimer!;
  Timer get secondaryTimer => _secondaryTimer!;

  void startTimer({
    required bool isGlobalTimer,
    required Duration duration,
    required VoidCallback callback,
  }) {
    isGlobalTimer
        ? _globalTimer = Timer(duration, callback)
        : _secondaryTimer = Timer(duration, callback);

    debugPrint(
        'startTimer ${isGlobalTimer ? '_globalTimer' : '_secondaryTimer'} Timer');
  }

  void stopTimer({
    required bool isGlobalTimer,
  }) {
    isGlobalTimer ? _globalTimer?.cancel() : _secondaryTimer?.cancel();

    debugPrint(
        'stopTimer ${isGlobalTimer ? '_globalTimer' : '_secondaryTimer'} Timer');
  }

  bool isTimerActive({
    required bool isGlobalTimer,
  }) {
    return isGlobalTimer
        ? _globalTimer?.isActive ?? false
        : _secondaryTimer?.isActive ?? false;
  }
}
