import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    let flutterEngine = FlutterEngine(name: "my flutter engine")
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
      let dbFiles = ["database.isar", "database.isar.lock"]
      
      for dbFile in dbFiles {
          let new_db_file = URL.documents.appendingPathComponent(dbFile)
          let old_db_file = URL.applicationSupport.appendingPathComponent(dbFile)
          
          if(FileManager.default.fileExists(atPath: old_db_file.absoluteString)){
              
              if(!FileManager.default.fileExists(atPath: new_db_file.absoluteString) ||
                 (fileModificationDate(url: old_db_file) > fileModificationDate(url: new_db_file))){
                  
                  do{
                      try FileManager.default.moveItem(at: old_db_file, to: new_db_file)
                      print("Database file \(dbFile) moved to AppDocuments")
                  }catch{
                      print("Move database file \(dbFile) fail")
                  }
                  
              }
          }
      }
      
      
      
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
    
    
    func fileModificationDate(url: URL) -> Date {
        do {
            let attr = try FileManager.default.attributesOfItem(atPath: url.path)
            return attr[FileAttributeKey.modificationDate] as? Date ?? Date.distantPast
        } catch {
            return Date.distantPast
        }
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

extension URL {
    
    static var documents: URL {
        return FileManager
            .default
            .urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    static var applicationSupport: URL {
        return FileManager
            .default
            .urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
    }
    
}
