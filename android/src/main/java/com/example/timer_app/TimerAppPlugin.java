package com.example.timer_app;

import android.os.CountDownTimer;
import android.util.Log;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/** TimerAppPlugin */
public class TimerAppPlugin implements FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;
  private EventChannel eventChannel;
  private EventChannel.EventSink eventSink;
  private CountDownTimer countDownTimer;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "timer_app");
    eventChannel = new EventChannel(flutterPluginBinding.getBinaryMessenger(), "timer_event_channel");
    eventChannel.setStreamHandler(new EventChannel.StreamHandler() {
      @Override
      public void onListen(Object arguments, EventChannel.EventSink events) {
          TimerAppPlugin.this.eventSink = events;
      }

      @Override
      public void onCancel(Object arguments) {
          TimerAppPlugin.this.eventSink = null;
      }
    });
    channel.setMethodCallHandler(this);
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("start")) {

      Double totalTime = call.argument("totalTime") != null ? (double)call.argument("totalTime") * 1000.0 : 40000.0;
      long interval = 1000;

      timer(totalTime, interval);
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    } else  if (call.method.equals("stop")){
      countDownTimer.cancel();
    } else {
      result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }

  public void timer(Double totalTime, long interval) {
    countDownTimer = new CountDownTimer(totalTime.longValue(), interval) {
      @Override
      public void onTick(long l) {
        if(eventSink != null) {
          eventSink.success(l/1000);
        }
      }

      @Override
      public void onFinish() {
        if(eventSink != null) {
          eventSink.success("FINISHED");
        }
      }
    };

    countDownTimer.start();
  }
}
