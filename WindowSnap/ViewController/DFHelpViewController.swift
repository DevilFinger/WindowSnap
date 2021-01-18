//
//  DFHelpViewController.swift
//  WindowSnap
//
//  Created by raymond on 2021/1/2.
//

import Cocoa


class DFHelpViewController: NSViewController{
    
    struct DFHelp {
        var content : String?
        var imageName : String?
        var step  : Int?
    }

    var helps : [DFHelp]?
    
    var curIndex = 0
    
    @IBOutlet weak var imageView: NSImageView!
    @IBOutlet weak var preImageBtn: NSButton!
    @IBOutlet weak var nextImageBtn: NSButton!
    @IBOutlet weak var stepLbl: NSTextField!
    @IBOutlet weak var multiLineLbl: NSTextField!
    @IBOutlet weak var checkBtn: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("DFHelpViewController viewdidload")
        setupHelps()
        setupContent()
        
        checkBtn.state = .off
        if let isShow = UserDefaults.standard.object(forKey: "HelpIsShow") as? Bool {
            if isShow{
                checkBtn.state  = .on
            }else{
                checkBtn.state = .off
            }
        }
        
    }

    func setupHelps() {
        let help1 = DFHelp.init(content: "", imageName: "help-1.image", step: 0)
        let help2 = DFHelp.init(content: "", imageName: "help-2.image", step: 1)
        let help3 = DFHelp.init(content: "", imageName: "help-3.image", step: 2)
        self.helps = [help1, help2, help3]
        
        self.curIndex = 0
    }
   
    override var representedObject: Any? {
        didSet {
        
        }
    }
    
    
    @IBAction func nextBtnDidClicked(_ sender: Any) {
        self.curIndex += 1
        setupContent()
        
    }
    @IBAction func preBtnDidClicked(_ sender: Any) {
        self.curIndex -= 1
        setupContent()
    }
    
    @IBAction func checkBtnDidClicked(_ sender: NSButton) {
        if sender.state == .on {
            UserDefaults.standard.setValue(true, forKey: "HelpIsShow")
        }else if sender.state == .off{
            UserDefaults.standard.setValue(false, forKey: "HelpIsShow")
        }
        
    }
    
    func setupContent() {
        
        if let arrs = helps{
            
            
            if arrs.count > 0 {
                if curIndex > arrs.count - 1  {
                    curIndex = arrs.count - 1
                    nextImageBtn.isEnabled = false
                }else if curIndex <= 0{
                    curIndex = 0
                    preImageBtn.isEnabled = false
                }else{
                    nextImageBtn.isEnabled = true
                    preImageBtn.isEnabled = true
                }
                let help = arrs[self.curIndex]
                let image = Bundle.main.image(forResource: "help-\(curIndex + 1).png")
                imageView.image = image
                stepLbl.stringValue = "\(curIndex + 1)/\(arrs.count)"
                multiLineLbl.stringValue = help.content ?? ""
            }else{
                imageView.image = nil
                stepLbl.stringValue = ""
                multiLineLbl.stringValue = ""
            }
            
        }
    }
}
