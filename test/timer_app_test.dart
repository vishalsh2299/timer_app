import 'package:flutter_test/flutter_test.dart';
import 'package:timer_app/timer_app.dart';
import 'package:timer_app/timer_app_platform_interface.dart';
import 'package:timer_app/timer_app_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockTimerAppPlatform 
    with MockPlatformInterfaceMixin
    implements TimerAppPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final TimerAppPlatform initialPlatform = TimerAppPlatform.instance;

  test('$MethodChannelTimerApp is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelTimerApp>());
  });

  test('getPlatformVersion', () async {
    TimerApp timerAppPlugin = TimerApp();
    MockTimerAppPlatform fakePlatform = MockTimerAppPlatform();
    TimerAppPlatform.instance = fakePlatform;
  
    expect(await timerAppPlugin.getPlatformVersion(), '42');
  });
}
