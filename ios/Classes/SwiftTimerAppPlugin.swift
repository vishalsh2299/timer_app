import Flutter
import UIKit

public class SwiftTimerAppPlugin: NSObject, FlutterPlugin {
    private var timer: Timer?
    private var counter: Double? = 40
    private static var eventChannelHandler: EventChannelHandler?
    private static var interval: Double? = 1

    override public init() {
        super.init()
    }

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "timer_app", binaryMessenger: registrar.messenger())
        let instance = SwiftTimerAppPlugin()

        registrar.addMethodCallDelegate(instance, channel: channel)

        eventChannelHandler = EventChannelHandler(id: "timer_event_channel", messenger: registrar.messenger())
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let args = call.arguments as? [String: Any]

        switch call.method {
        case "start":
            let totalTime = args?["totalTime"] as? Double
            counter = totalTime

            start(totalTime: totalTime, interval: SwiftTimerAppPlugin.interval)
            result("Started")
            break

        case "pause":
            timer?.invalidate()
            timer = nil
            result("Paused")
            break
            
        case "resume":
            start(totalTime: counter, interval: SwiftTimerAppPlugin.interval)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    public func start(totalTime _: Double?, interval: Double?) {
        timer = Timer.scheduledTimer(timeInterval: interval ?? 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
    }

    @objc func updateCounter() {
        if counter! > 0 {
            counter! -= 1
            do {
                try SwiftTimerAppPlugin.eventChannelHandler?.success(event: counter)
            } catch {}
        } else {
            do {
                try SwiftTimerAppPlugin.eventChannelHandler?.success(event: "FINISHED")
            } catch {}
        }
    }
}
