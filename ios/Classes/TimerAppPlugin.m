#import "TimerAppPlugin.h"
#if __has_include(<timer_app/timer_app-Swift.h>)
#import <timer_app/timer_app-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "timer_app-Swift.h"
#endif

@implementation TimerAppPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftTimerAppPlugin registerWithRegistrar:registrar];
}
@end
