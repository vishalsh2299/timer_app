import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'timer_app_method_channel.dart';

abstract class TimerAppPlatform extends PlatformInterface {
  /// Constructs a TimerAppPlatform.
  TimerAppPlatform() : super(token: _token);

  static final Object _token = Object();

  static TimerAppPlatform _instance = MethodChannelTimerApp();

  /// The default instance of [TimerAppPlatform] to use.
  ///
  /// Defaults to [MethodChannelTimerApp].
  static TimerAppPlatform get instance => _instance;
  
  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [TimerAppPlatform] when
  /// they register themselves.
  static set instance(TimerAppPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
