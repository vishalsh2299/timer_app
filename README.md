# timer_app

The Timer Application is made in Native (Android & IOS) and then integrated with Flutter as a plugin using Platform channels.

## Getting Started

This project is a starting point for a Flutter
[plug-in package](https://flutter.dev/developing-packages/),
a specialized package that includes platform-specific implementation code for
Android and/or iOS.

For help getting started with Flutter development, view the
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

![Alt Text](https://github.com/vishalsh2299/timer_app/blob/master/timer_app.gif)

## Platform Channels

Platform channels are used to communicate with the native side using event streams or method calls. This communication is set up by calling platform-specific APIs from Dart code, and it provides a way to share data among platform and dart sides. These APIs can be called in the language supported by the specific platform. eg - Java or Kotlin for Android, Swift or Objective-C for IOS.

### MethodChannel

They are used to invoke methods with or without arguments at the platform side. And on the platform side, we receive the method calls and send back a result. The method call is asynchronous. On Android, we use MethodChannel and on IOS, we use FlutterMethodChannel for handling method calls.

### EventChannel

They are used to stream data from platform to dart side. These stream requests are encoded into binary at the platform side and then we can receive these stream requests by subscribing to them. The stream data is then decoded into Dart.
