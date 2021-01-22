//
//  DFAboutViewController.swift
//  WindowSnap
//
//  Created by raymond on 2021/1/2.
//

import Cocoa

class DFAboutViewController: NSViewController {
    
    @IBOutlet weak var iconImageView: NSImageView!
    
    @IBOutlet weak var appNameLbl: NSTextField!
    
    @IBOutlet weak var versionLbl: NSTextField!
    
    @IBOutlet weak var teamNameLbl: NSTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        
        iconImageView.image = NSApp.applicationIconImage
        
        
        
        if let dict = Bundle.main.infoDictionary{
            
            let appDisplayName = dict["CFBundleName"]  as? String
            if let appDisplayName = appDisplayName {
                appNameLbl.stringValue = appDisplayName
            }
            
            
            let version = dict["CFBundleShortVersionString"] as? String
            let build = dict["CFBundleVersion"] as? String
            
            if let  version = version, let build = build{
                versionLbl.stringValue = "V\(version)(Build:\(build))"
            }
        }
        
    }

    override var representedObject: Any? {
        didSet {
        
            
        }
    }
}

