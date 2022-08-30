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

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');

    return version;
  }

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
    stop();
  }

  stop() async {
    await methodChannel.invokeMethod<String>('stop');
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
