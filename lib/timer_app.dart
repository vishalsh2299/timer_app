import 'timer_app_platform_interface.dart';

class TimerApp {
  Future<String?> getPlatformVersion() {
    return TimerAppPlatform.instance.getPlatformVersion();
  }
}
