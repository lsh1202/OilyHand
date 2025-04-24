import UIKit
import Flutter
import CoreMotion

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    let motionManager = CMMotionManager()
    var shockChannel: FlutterMethodChannel?
    
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
                case "getShockCount":
                    result(self?.getTodayShockCount())
                default:
                    result(FlutterMethodNotImplemented)
                }
            }
        }
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    var bgTask: UIBackgroundTaskIdentifier = .invalid
    
    func startBackgroundTask() {
        bgTask = UIApplication.shared.beginBackgroundTask(withName: "ShockDetection") {
            UIApplication.shared.endBackgroundTask(self.bgTask)
            self.bgTask = .invalid
        }
    }
    
    private func startShockDetection() {
        startBackgroundTask()
        if motionManager.isAccelerometerAvailable {
            motionManager.accelerometerUpdateInterval = 0.2
            motionManager.startAccelerometerUpdates(to: OperationQueue.main) { (data, error) in
                guard let acceleration = data?.acceleration else { return }
                
                let magnitude = sqrt(
                    acceleration.x * acceleration.x +
                    acceleration.y * acceleration.y +
                    acceleration.z * acceleration.z
                )
                
                if magnitude > 2.5 {
                    print("⚠️ Shock Detected! Accel: \(magnitude)")
                    self.incrementShockCount()
                }
            }
        } else {
            print("❌ Accelerometer not available")
        }
    }
    
    private func getTodayKey() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }
    
    private func incrementShockCount() {
        let key = getTodayKey()
        let defaults = UserDefaults.standard
        let count = defaults.integer(forKey: key)
        defaults.set(count + 1, forKey: key)
    }
    
    private func getTodayShockCount() -> Int {
        let key = getTodayKey()
        return UserDefaults.standard.integer(forKey: key)
    }
}
