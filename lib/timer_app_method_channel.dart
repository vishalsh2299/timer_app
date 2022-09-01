import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'timer_app_platform_interface.dart';

/// An implementation of [TimerAppPlatform] that uses method channels.
class MethodChannelTimerApp extends TimerAppPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('timer_app');
  final eventChannel = const EventChannel('timer_event_channel');
  StreamSubscription<dynamic>? streamSubscription;

  start(double? totalTime) async {
    await methodChannel
        .invokeMethod<String>('start', {'totalTime': totalTime ?? 40.0});
  }

  timerListen(TimerListener timerListener) {
    streamSubscription = eventChannel.receiveBroadcastStream().listen((event) {
      if (event != null) {
        timerListener.onSuccess!(event);
      } else {
        timerListener.onError!("ERROR");
      }
    });
  }

  stopListener() {
    streamSubscription!.cancel();
    pause();
  }

  pause() async {
    await methodChannel.invokeMethod<String>('pause');
  }

  resume() async {
    await methodChannel.invokeMethod<String>('resume');
  }
}

class TimerListener {
  Function? onSuccess;
  Function? onError;

  TimerListener({
    this.onSuccess,
    this.onError,
  });
}
