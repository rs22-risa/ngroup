import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    let flutterEngine = FlutterEngine(name: "my flutter engine")
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
      let defaults = UserDefaults.standard
      let agreeEULA = defaults.bool(forKey: "AgreeEULA")
      let agreeEULA_Ver = defaults.string(forKey: "AgreeEULA_Ver")
      
      if(!agreeEULA){
          // Show EULA screen if this was never shown before
          
          flutterEngine.run();
          
          GeneratedPluginRegistrant.register(with: self.flutterEngine)
          
          let storyboard = UIStoryboard(name: "PreMain", bundle: nil)
          let initialViewController = storyboard.instantiateViewController(withIdentifier: "Home")
          
          self.window.rootViewController = initialViewController
          self.window.makeKeyAndVisible()
          
      }else{
          GeneratedPluginRegistrant.register(with: self)
      }
      
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

extension UIApplication {
    static var release: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String? ?? "x.x"
    }
    static var build: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String? ?? "x"
    }
    static var version: String {
        return "\(release).\(build)"
    }
}
