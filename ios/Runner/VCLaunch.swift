//
//  VCLaunch.swift
//  NGroup
//
//  Created by Hung on 2024/05/23.
//

import Foundation

import UIKit


import Flutter

class ViewController: UIViewController {

    @IBOutlet weak var txtEULA: UITextView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if let EULAFile = Bundle.main.path(forResource: "EULA", ofType: "txt") {

            do {
                txtEULA.text = try String(contentsOfFile: EULAFile, encoding: String.Encoding.utf8)
            } catch {
                assertionFailure("Failed reading EULA file! Error: " + error.localizedDescription)
            }
            
        }
        
    }

    @IBAction func disagreeEULA(sender: UIButton) {
        exit(0)
    }
    
    @IBAction func agreeEULA(sender: UIButton) {
        
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: "AgreeEULA")
        defaults.set(UIApplication.release, forKey: "AgreeEULA_Ver")
        
        showFlutter()
        
    }
    
    @objc func showFlutter() {
      let flutterEngine = (UIApplication.shared.delegate as! AppDelegate).flutterEngine
      let flutterViewController =
          FlutterViewController(engine: flutterEngine, nibName: nil, bundle: nil)
        
        flutterViewController.modalPresentationStyle = .overCurrentContext
        
      present(flutterViewController, animated: true, completion: nil)
    }
    
}
