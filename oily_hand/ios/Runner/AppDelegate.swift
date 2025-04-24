import UIKit
import Flutter
import CoreMotion

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  let motionManager = CMMotionManager()
  var shockChannel: FlutterMethodChannel?
  var bgTask: UIBackgroundTaskIdentifier = .invalid

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    if let controller = window?.rootViewController as? FlutterViewController {
      shockChannel = FlutterMethodChannel(
        name: "com.example.oilyHand/shock",
        binaryMessenger: controller.binaryMessenger
      )

      shockChannel?.setMethodCallHandler { [weak self] (call, result) in
        switch call.method {
        case "startShockDetection":
          self?.startShockDetection()
          result(nil)
        case "getShockStats":
          result(self?.getShockStats())
        default:
          result(FlutterMethodNotImplemented)
        }
      }
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func startBackgroundTask() {
    bgTask = UIApplication.shared.beginBackgroundTask(withName: "ShockDetection") {
      UIApplication.shared.endBackgroundTask(self.bgTask)
      self.bgTask = .invalid
    }
  }

  private func startShockDetection() {
    startBackgroundTask()

    if motionManager.isAccelerometerAvailable {
      motionManager.accelerometerUpdateInterval = 0.2
      motionManager.startAccelerometerUpdates(to: OperationQueue.main) { [weak self] (data, _) in
        guard let acceleration = data?.acceleration else { return }

        let magnitude = sqrt(
          acceleration.x * acceleration.x +
          acceleration.y * acceleration.y +
          acceleration.z * acceleration.z
        )

        if magnitude > 2.5 {
          print("⚠️ Shock Detected! Accel: \(magnitude)")
          self?.saveShockEvent()
        }
      }
    } else {
      print("❌ Accelerometer not available")
    }
  }

  private func saveShockEvent() {
    let userDefaults = UserDefaults.standard
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    let today = dateFormatter.string(from: Date())

    var shockHistory = userDefaults.dictionary(forKey: "shockHistory") as? [String: Int] ?? [:]
    shockHistory[today] = (shockHistory[today] ?? 0) + 1
    userDefaults.setValue(shockHistory, forKey: "shockHistory")
    userDefaults.synchronize()
  }

  private func getShockStats() -> [String: Any] {
    let userDefaults = UserDefaults.standard
    let shockHistory = userDefaults.dictionary(forKey: "shockHistory") as? [String: Int] ?? [:]

    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    let today = dateFormatter.string(from: Date())
    let todayCount = shockHistory[today] ?? 0
    let maxRecord = shockHistory.values.max() ?? 0

    // 📅 날짜순 정렬된 리스트 반환
    let sortedHistory = shockHistory.sorted(by: { $0.key < $1.key })
    let shockHistoryList: [[String: Any]] = sortedHistory.map { (date, count) in
      return ["date": date, "count": count]
    }

    return [
      "today": todayCount,
      "max": maxRecord,
      "history": shockHistoryList
    ]
  }
}
