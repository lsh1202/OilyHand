import Flutter
import UIKit
import CoreMotion

public class SwiftOilyHandPlugin: NSObject, FlutterPlugin {
    private var motionManager: CMMotionManager?
    private var shockCount = 0
    private var maxShockCount = 0
    private var shockHistory: [String: Int] = [:] // 날짜와 충격 횟수 기록

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "com.example.oilyHand/shock", binaryMessenger: registrar.messenger())
        let instance = SwiftOilyHandPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if call.method == "startShockDetection" {
            startShockDetection()
            result(nil)
        } else if call.method == "getShockCount" {
            result(shockCount)
        } else if call.method == "getShockStats" {
            result(getShockStats())
        } else {
            result(FlutterMethodNotImplemented)
        }
    }

    private func startShockDetection() {
        if motionManager == nil {
            motionManager = CMMotionManager()
        }

        motionManager?.accelerometerUpdateInterval = 0.1
        motionManager?.startAccelerometerUpdates(to: .main) { [weak self] data, error in
            guard let self = self else { return }
            if let acceleration = data?.acceleration {
                let magnitude = sqrt(acceleration.x * acceleration.x + acceleration.y * acceleration.y + acceleration.z * acceleration.z)
                if magnitude > 2.0 {  // 충격 감지 기준 (2.0은 예시, 적절하게 설정)
                    self.shockCount += 1
                    self.updateShockHistory()
                    self.updateMaxShockCount()
                }
            }
        }
    }

    private func updateShockHistory() {
        let date = getCurrentDate()
        shockHistory[date] = (shockHistory[date] ?? 0) + 1
    }

    private func updateMaxShockCount() {
        if shockCount > maxShockCount {
            maxShockCount = shockCount
        }
    }

    private func getCurrentDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: Date())
    }

    private func getShockStats() -> [String: Any] {
        return [
            "shockCount": shockCount,
            "maxShockCount": maxShockCount,
            "shockHistory": shockHistory
        ]
    }
}
