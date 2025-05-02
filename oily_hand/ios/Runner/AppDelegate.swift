import UIKit
import Flutter
import CoreMotion

@main
@objc class AppDelegate: FlutterAppDelegate {
  var motionManager = CMMotionManager()
  var shockCount = 0
  var maxShock: Double = 0.0
  var dailyShocks: [String: Int] = [:]

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller = window?.rootViewController as! FlutterViewController
    let channel = FlutterMethodChannel(name: "com.example.oilyHand", binaryMessenger: controller.binaryMessenger)

    channel.setMethodCallHandler { [weak self] call, result in
      guard let self = self else { return }

      switch call.method {
      case "startShockDetection":
        self.startShockDetection()
        result(nil)
      case "getShockStats":
        result([
          "total": self.shockCount,
          "max": self.maxShock,
          "last7Days": self.dailyShocks
        ])
      default:
        result(FlutterMethodNotImplemented)
      }
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func startShockDetection() {
    if motionManager.isAccelerometerAvailable {
      motionManager.accelerometerUpdateInterval = 1.0
      motionManager.startAccelerometerUpdates(to: .main) { data, _ in
        guard let data = data else { return }

        let acceleration = sqrt(
          pow(data.acceleration.x, 2) +
          pow(data.acceleration.y, 2) +
          pow(data.acceleration.z, 2)
        )

        if acceleration > 2.5 {
          self.shockCount += 1
          self.maxShock = max(self.maxShock, acceleration)

          let formatter = DateFormatter()
          formatter.dateFormat = "yyyy-MM-dd"
          let dateKey = formatter.string(from: Date())

          self.dailyShocks[dateKey, default: 0] += 1

          print("💥 충격 감지됨: \(acceleration)")
        }
      }
    }
  }
}
