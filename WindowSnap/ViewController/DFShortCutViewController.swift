//
//  DFShortCutViewController.swift
//  WindowSnap
//
//  Created by raymond on 2021/1/12.
//

import Foundation

enum DFShortcutEnableKey : String {
    case top = "DFShortcutTopKey"
    case bottom = "DFShortcutEnableBottomKey"
    case left = "DFShortcutEnableLeftKey"
    case right = "DFShortcutEnableRightKey"
    case leftTop = "DFShortcutEnableLeftTopKey"
    case leftBottom = "DFShortcutEnableLeftBottomKey"
    case rightTop = "DFShortcutEnableRightTopKey"
    case rightBottom = "DFShortcutEnableRightBottomKey"
}

enum DFShortcutKey : String {
    case top = "DFShortcutEnableTopKey"
    case bottom = "DFShortcutBottomKey"
    case left = "DFShortcutLeftKey"
    case right = "DFShortcutRightKey"
    case leftTop = "DFShortcutLeftTopKey"
    case leftBottom = "DFShortcutLeftBottomKey"
    case rightTop = "DFShortcutRightTopKey"
    case rightBottom = "DFShortcutRightBottomKey"
}

class DFShortCutViewController : NSViewController{
    
    @IBOutlet weak var enableTopCheckBox: NSButton!
    @IBOutlet weak var topShortcutView: MASShortcutView!
    @IBOutlet weak var topImageVIew: NSImageView!
    
    @IBOutlet weak var enableBottomCheckBox: NSButton!
    @IBOutlet weak var bottomShortcutView: MASShortcutView!
    @IBOutlet weak var bottomImageVIew: NSImageView!
    
    @IBOutlet weak var enableLeftCheckBox: NSButton!
    @IBOutlet weak var leftShortcutView: MASShortcutView!
    @IBOutlet weak var leftImageView: NSImageView!
    
    
    @IBOutlet weak var enableRightCheckBox: NSButton!
    @IBOutlet weak var rightShortcutView: MASShortcutView!
    @IBOutlet weak var rightImageView: NSImageView!
    
    
    @IBOutlet weak var enableLeftTopCheckBox: NSButton!
    @IBOutlet weak var leftTopShortcutView: MASShortcutView!
    @IBOutlet weak var leftTopImageView: NSImageView!
    
    @IBOutlet weak var enableLeftBottomCheckBox: NSButton!
    @IBOutlet weak var leftBottomShortcutView: MASShortcutView!
    @IBOutlet weak var leftBottomImageView: NSImageView!
    
    
    @IBOutlet weak var enableRightTopCheckBox: NSButton!
    @IBOutlet weak var rightTopShortcutView: MASShortcutView!
    @IBOutlet weak var rightTopImageView: NSImageView!

    
    @IBOutlet weak var enableRightBottomCheckBox: NSButton!
    @IBOutlet weak var rightBottomShortcutView: MASShortcutView!
    @IBOutlet weak var rightBottomImageView: NSImageView!
    
    
    @IBOutlet weak var mouseTopCheckBox: NSButton!
    @IBOutlet weak var mouseBottomCheckBox: NSButton!
    @IBOutlet weak var mouseLeftCheckBox: NSButton!
    @IBOutlet weak var mouseRightCheckBox: NSButton!
    @IBOutlet weak var mouseLeftTopCheckBox: NSButton!
    @IBOutlet weak var mouseLeftBottomCheckBox: NSButton!
    @IBOutlet weak var mouseRightTopCheckBox: NSButton!
    @IBOutlet weak var mouseRightBottomCheckBox: NSButton!
    
    @IBOutlet weak var topFullRadio: NSButton!
    @IBOutlet weak var topHalfFullRadio: NSButton!
    @IBOutlet weak var topHalfFullBottomRadio: NSButton!
    
    @IBOutlet weak var bottomFullRadio: NSButton!
    @IBOutlet weak var bottomHalfFullRadio: NSButton!
    @IBOutlet weak var bottomHalfFullBottomRadio: NSButton!
    
    
    
    override var representedObject: Any? {
        didSet {
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewAndRegister()
        setupMouseAreaCheckBoxAll()
        setupTopAreaSize()
        setupBottomAreaSize()
        
        
        leftTopImageView.rotate(byDegrees: -45)
        leftBottomImageView.rotate(byDegrees: 45)
        rightTopImageView.rotate(byDegrees: 45)
        rightBottomImageView.rotate(byDegrees: -45)
        
    }
    
    private func setupViewAndRegister()  {
        
        _setupShortcutView(shortcutView: topShortcutView,shortcut: DFShortCutViewController.getUserDefaultShortcut(.top))
        _setupCheckBox(checkbox: enableTopCheckBox, isEnable: DFShortCutViewController.getUserDefaultShortcutEnable(.top))
        DFShortCutViewController.safeRegiseter(shortcut: DFShortCutViewController.getUserDefaultShortcut(.top),
                          isEnable: DFShortCutViewController.getUserDefaultShortcutEnable(.top),
                          snapType: .top)
        
        _setupShortcutView(shortcutView: bottomShortcutView,shortcut: DFShortCutViewController.getUserDefaultShortcut(.bottom))
        _setupCheckBox(checkbox: enableBottomCheckBox, isEnable: DFShortCutViewController.getUserDefaultShortcutEnable(.bottom))
        DFShortCutViewController.safeRegiseter(shortcut: DFShortCutViewController.getUserDefaultShortcut(.bottom),
                          isEnable: DFShortCutViewController.getUserDefaultShortcutEnable(.bottom),
                          snapType: .bottom)
        
        _setupShortcutView(shortcutView: leftShortcutView,shortcut: DFShortCutViewController.getUserDefaultShortcut(.left))
        _setupCheckBox(checkbox: enableLeftCheckBox, isEnable: DFShortCutViewController.getUserDefaultShortcutEnable(.left))
        DFShortCutViewController.safeRegiseter(shortcut: DFShortCutViewController.getUserDefaultShortcut(.left),
                          isEnable: DFShortCutViewController.getUserDefaultShortcutEnable(.left),
                          snapType: .left)
        
        _setupShortcutView(shortcutView: rightShortcutView,shortcut: DFShortCutViewController.getUserDefaultShortcut(.right))
        _setupCheckBox(checkbox: enableRightCheckBox, isEnable: DFShortCutViewController.getUserDefaultShortcutEnable(.right))
        DFShortCutViewController.safeRegiseter(shortcut: DFShortCutViewController.getUserDefaultShortcut(.right),
                          isEnable: DFShortCutViewController.getUserDefaultShortcutEnable(.right),
                          snapType: .right)
        
        _setupShortcutView(shortcutView: leftTopShortcutView,shortcut: DFShortCutViewController.getUserDefaultShortcut(.leftTop))
        _setupCheckBox(checkbox: enableLeftTopCheckBox, isEnable: DFShortCutViewController.getUserDefaultShortcutEnable(.leftTop))
        DFShortCutViewController.safeRegiseter(shortcut: DFShortCutViewController.getUserDefaultShortcut(.leftTop),
                          isEnable: DFShortCutViewController.getUserDefaultShortcutEnable(.leftTop),
                          snapType: .leftTop)
        
        _setupShortcutView(shortcutView: leftBottomShortcutView,shortcut: DFShortCutViewController.getUserDefaultShortcut(.leftBottom))
        _setupCheckBox(checkbox: enableLeftBottomCheckBox, isEnable: DFShortCutViewController.getUserDefaultShortcutEnable(.leftBottom))
        DFShortCutViewController.safeRegiseter(shortcut: DFShortCutViewController.getUserDefaultShortcut(.leftBottom),
                          isEnable: DFShortCutViewController.getUserDefaultShortcutEnable(.leftBottom),
                          snapType: .leftBottom)
        
        _setupShortcutView(shortcutView: rightTopShortcutView,shortcut: DFShortCutViewController.getUserDefaultShortcut(.rightTop))
        _setupCheckBox(checkbox: enableRightTopCheckBox, isEnable: DFShortCutViewController.getUserDefaultShortcutEnable(.rightTop))
        DFShortCutViewController.safeRegiseter(shortcut: DFShortCutViewController.getUserDefaultShortcut(.rightTop),
                          isEnable: DFShortCutViewController.getUserDefaultShortcutEnable(.rightTop),
                          snapType: .rightTop)
        
        _setupShortcutView(shortcutView: rightBottomShortcutView,shortcut: DFShortCutViewController.getUserDefaultShortcut(.rightBottom))
        _setupCheckBox(checkbox: enableRightBottomCheckBox, isEnable: DFShortCutViewController.getUserDefaultShortcutEnable(.rightBottom))
        DFShortCutViewController.safeRegiseter(shortcut: DFShortCutViewController.getUserDefaultShortcut(.rightBottom),
                          isEnable: DFShortCutViewController.getUserDefaultShortcutEnable(.rightBottom),
                          snapType: .rightBottom)
    }
    
    private func _setupShortcutView(shortcutView:MASShortcutView, shortcut:MASShortcut?) {
        if let sc = shortcut{
            shortcutView.shortcutValue = sc
            shortcutView.shortcutValueChange = self.shortcutValueDidChange
        }
    }
    
    private func _setupCheckBox(checkbox:NSButton,isEnable:Bool) {
        if isEnable{
            checkbox.state = .on
        }else{
            checkbox.state = .off
        }
    }
    
    func shortcutValueDidChange(_ sender: MASShortcutView?) {
        if let shortcutView = sender{
            var key:DFShortcutKey?
            var snapType:DFWindowSnapType?
            var checkBox : NSButton?
            
            if sender == topShortcutView{
                key = .top
                snapType = .top
                checkBox = enableTopCheckBox
            }else if sender == bottomShortcutView{
                key = .bottom
                snapType = .bottom
                checkBox = enableBottomCheckBox
            }else if sender == leftShortcutView{
                key = .left
                snapType = .left
                checkBox = enableLeftCheckBox
            }else if sender == rightShortcutView{
                key = .right
                snapType = .right
                checkBox = enableRightCheckBox
            }else if sender == leftTopShortcutView{
                key = .leftTop
                snapType = .leftTop
                checkBox = enableLeftTopCheckBox
            }else if sender == leftBottomShortcutView{
                key = .leftBottom
                snapType = .leftBottom
                checkBox = enableLeftBottomCheckBox
            }else if sender == rightTopShortcutView{
                key = .rightTop
                snapType = .rightTop
                checkBox = enableRightTopCheckBox
            }else if sender == rightBottomShortcutView{
                key = .rightBottom
                snapType = .rightBottom
                checkBox = enableRightBottomCheckBox
            }
            if let scKey = key, let sType = snapType , let btn = checkBox{
                let isEnable = isShortcutEnable(checkbox: btn)
                DFShortCutViewController.saveInUserDefault(shortcut: shortcutView.shortcutValue, shortcutKey: scKey)
                DFShortCutViewController.safeRegiseter(shortcut: shortcutView.shortcutValue, isEnable: isEnable, snapType: sType)
            }
            
        }
    }
    
    @IBAction func checkBoxDidClicked(_ sender: NSButton) {
        let isEnable = isShortcutEnable(checkbox: sender)
        var shortcut:MASShortcut?
        var key:DFShortcutEnableKey?
        var snapType:DFWindowSnapType?
        
        if sender == enableTopCheckBox{
            key = .top
            shortcut = topShortcutView.shortcutValue
            snapType = .top
        }else if sender == enableBottomCheckBox{
            key = .bottom
            shortcut = bottomShortcutView.shortcutValue
            snapType = .bottom
        }else if sender == enableLeftCheckBox{
            key = .left
            shortcut = leftShortcutView.shortcutValue
            snapType = .left
        }else if sender == enableRightCheckBox{
            key = .right
            shortcut = rightShortcutView.shortcutValue
            snapType = .right
        }else if sender == enableLeftTopCheckBox{
            key = .leftTop
            shortcut = leftTopShortcutView.shortcutValue
            snapType = .leftTop
        }else if sender == enableLeftBottomCheckBox{
            key = .leftBottom
            shortcut = leftBottomShortcutView.shortcutValue
            snapType = .leftBottom
        }else if sender == enableRightTopCheckBox{
            key = .rightTop
            shortcut = rightTopShortcutView.shortcutValue
            snapType = .rightTop
        }else if sender == enableRightBottomCheckBox{
            key = .rightBottom
            shortcut = rightBottomShortcutView.shortcutValue
            snapType = .rightBottom
        }
        
        if let scKey = key, let sc = shortcut, let sType = snapType{
            DFShortCutViewController.saveInUserDefault(isEnable: isEnable, key: scKey)
            DFShortCutViewController.safeRegiseter(shortcut: sc, isEnable: isEnable, snapType: sType)
        }
    }
    
    func isShortcutEnable(checkbox:NSButton) -> Bool {
        var result = true
        if checkbox.state == .off{
            result = false
        }
        return result
    }
    
    @IBAction func topAreaRadioDidClicked(_ sender: NSButton) {
        _topAreaRadioDidClicked(sender: sender)
    }
    
    @IBAction func bottomAreaRadioDidClicked(_ sender: NSButton) {
        _bottomAreaRadioDidClicked(sender: sender)
    }
    
    @IBAction func mouseAreaCheckBoxDidClicked(_ sender: NSButton) {
        _mouseAreaCheckboxDidClicked(sender: sender)
    }
    
}


extension DFShortCutViewController{
    
    static func regiseterAllWithDefault()  {
        let topShortcut = DFShortCutViewController.getUserDefaultShortcut(.top)
        let bottomShortcut = DFShortCutViewController.getUserDefaultShortcut(.bottom)
        let leftShortcut = DFShortCutViewController.getUserDefaultShortcut(.left)
        let rightShortcut = DFShortCutViewController.getUserDefaultShortcut(.right)
        let leftTopShortcut = DFShortCutViewController.getUserDefaultShortcut(.leftTop)
        let leftBottomShortcut = DFShortCutViewController.getUserDefaultShortcut(.leftBottom)
        let rightTopShortcut = DFShortCutViewController.getUserDefaultShortcut(.rightTop)
        let rightBottomShortcut = DFShortCutViewController.getUserDefaultShortcut(.rightBottom)
        
        let topIsEnable = getUserDefaultShortcutEnable(.top)
        let bottomIsEnable = getUserDefaultShortcutEnable(.bottom)
        let leftIsEnable = getUserDefaultShortcutEnable(.left)
        let rightIsEnable = getUserDefaultShortcutEnable(.right)
        let leftTopIsEnable = getUserDefaultShortcutEnable(.leftTop)
        let leftBottomIsEnable = getUserDefaultShortcutEnable(.leftBottom)
        let rightTopIsEnable = getUserDefaultShortcutEnable(.rightTop)
        let rightBottomIsEnable = getUserDefaultShortcutEnable(.rightBottom)
        
        safeRegiseter(shortcut: topShortcut, isEnable: topIsEnable, snapType: .top)
        safeRegiseter(shortcut: bottomShortcut, isEnable: bottomIsEnable, snapType: .bottom)
        safeRegiseter(shortcut: leftShortcut, isEnable: leftIsEnable, snapType: .left)
        safeRegiseter(shortcut: rightShortcut, isEnable: rightIsEnable, snapType: .right)
        safeRegiseter(shortcut: leftTopShortcut, isEnable: leftTopIsEnable, snapType: .leftTop)
        safeRegiseter(shortcut: leftBottomShortcut, isEnable: leftBottomIsEnable, snapType: .leftBottom)
        safeRegiseter(shortcut: rightTopShortcut, isEnable: rightTopIsEnable, snapType: .rightTop)
        safeRegiseter(shortcut: rightBottomShortcut, isEnable: rightBottomIsEnable, snapType: .rightBottom)
    }
    
    static func safeRegiseter(shortcut:MASShortcut?, isEnable:Bool, snapType:DFWindowSnapType)  {
        if let sc = shortcut{
            if isEnable{
                _register(shortcut: sc, action: _action(snapType: snapType))
            }else{
                _unregister(shortcut: sc)
            }
        }
    }
    
    
    static func getUserDefaultShortcutEnable(_ shortcutEnabledKey:DFShortcutEnableKey) -> Bool {
        return UserDefaults.standard.object(forKey: shortcutEnabledKey.rawValue) as? Bool ?? true
    }
    
    static func getUserDefaultShortcut(_ shortcutKey:DFShortcutKey) -> MASShortcut? {
        if let obj = UserDefaults.standard.object(forKey: shortcutKey.rawValue){
            if let masShortcut = try? NSKeyedUnarchiver.unarchivedObject(ofClass: MASShortcut.self, from: obj as! Data){
                return masShortcut
            }
        }
        var shortcut:MASShortcut?
        switch shortcutKey {
        case .top:
            shortcut = MASShortcut.init(keyCode: kVK_UpArrow, modifierFlags: .command)
            break
        case .bottom:
            shortcut = MASShortcut.init(keyCode: kVK_DownArrow, modifierFlags: .command)
            break
        case .left:
            shortcut = MASShortcut.init(keyCode: kVK_LeftArrow, modifierFlags: .command)
            break
        case .right:
            shortcut = MASShortcut.init(keyCode: kVK_RightArrow, modifierFlags: .command)
            break
        case .leftTop:
            shortcut = MASShortcut.init(keyCode: kVK_LeftArrow, modifierFlags: [.control,.option])
            break
        case .leftBottom:
            shortcut = MASShortcut.init(keyCode: kVK_LeftArrow, modifierFlags: [.control,.option])
            break
        case .rightTop:
            shortcut = MASShortcut.init(keyCode: kVK_RightArrow, modifierFlags: [.command,.option])
            break
        case .rightBottom:
            shortcut = MASShortcut.init(keyCode: kVK_RightArrow, modifierFlags: [.command, .option])
            break
        }
        
        if let sc = shortcut{
            saveInUserDefault(shortcut: sc, shortcutKey: shortcutKey)
        }
        return shortcut
        
    }
    
    static func saveInUserDefault(shortcut:MASShortcut, shortcutKey:DFShortcutKey)  {
        if let data = try? NSKeyedArchiver.archivedData(withRootObject: shortcut, requiringSecureCoding: false){
            UserDefaults.standard.setValue(data, forKey: shortcutKey.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    
    static func saveInUserDefault(isEnable:Bool, key:DFShortcutEnableKey)  {
        UserDefaults.standard.setValue(isEnable, forKey: key.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    private static func _action(snapType:DFWindowSnapType) -> () -> Void  {
        return {
            if let windowRef = AXUIElement.focusedWindowInFrontmostApplication(){
                DFMouseMonitorManger.shared.snapWindow(snapType: snapType, windowRef: windowRef)
            }
        }
    }
    
    private static func _register(shortcut:MASShortcut?, action:@escaping ()->Void) {
        if let sc = shortcut{
            if let isReg = MASShortcutMonitor.shared()?.isShortcutRegistered(sc){
                if isReg{
                    MASShortcutMonitor.shared()?.register(sc, withAction: action)
                }
            }
        }
    }
    
    private static func _unregister(shortcut:MASShortcut?) {
        if let sc = shortcut{
            if let isReg = MASShortcutMonitor.shared()?.isShortcutRegistered(sc){
                if isReg{
                    MASShortcutMonitor.shared()?.unregisterShortcut(sc)
                }
            }
        }
        
    }
    
}

//mouseArea
extension DFShortCutViewController{
    
    func setupMouseAreaCheckBoxAll() {
        setupCheckBox(area: .top, checkBox: mouseTopCheckBox)
        setupCheckBox(area: .bottom, checkBox: mouseBottomCheckBox)
        setupCheckBox(area: .left, checkBox: mouseLeftCheckBox)
        setupCheckBox(area: .right, checkBox: mouseRightCheckBox)
        setupCheckBox(area: .leftTop, checkBox: mouseLeftTopCheckBox)
        setupCheckBox(area: .leftBottom, checkBox: mouseLeftBottomCheckBox)
        setupCheckBox(area: .rightTop, checkBox: mouseRightTopCheckBox)
        setupCheckBox(area: .rightBottom, checkBox: mouseRightBottomCheckBox)
    }
    
    func setupCheckBox(area:DFMouseArea,checkBox:NSButton) {
        let isEnable = DFMouseAreaHelper.helper.getAreaIsEnable(area: area)
        checkBox.state = .on
        if isEnable == false{
            checkBox.state = .off
        }
    }
    
    func _mouseAreaCheckboxDidClicked(sender:NSButton) {
        var isEnable = true
        if sender.state == .off{
            isEnable = false
        }
        
        if let area = getMouseArea(sender: sender){
            DFMouseAreaHelper.helper.saveAreaIsEnable(area: area, value: isEnable)
        }
    }
    
    func getMouseArea(sender:NSButton) -> DFMouseArea? {
        if sender == mouseTopCheckBox {
            return .top
        }else if sender == mouseBottomCheckBox{
            return .bottom
        }else if sender == mouseLeftCheckBox{
            return .left
        }else if sender == mouseRightCheckBox{
            return .right
        }else if sender == mouseLeftTopCheckBox{
            return .leftTop
        }else if sender == mouseLeftBottomCheckBox{
            return .leftBottom
        }else if sender == mouseRightTopCheckBox{
            return .rightTop
        }else if sender == mouseRightBottomCheckBox{
            return .rightBottom
        }else{
            return nil
        }
    }
    
}
 
//top size & bottom size
extension DFShortCutViewController{
    func setupTopAreaSize()  {
        self.topFullRadio.state = .off
        self.topHalfFullRadio.state = .off
        self.topHalfFullBottomRadio.state = .off
        if let size = DFAreaSizeHelper.helper.getTopAreaSize(){
            let topAreaSize = size
            switch topAreaSize {
            case .full:
                self.topFullRadio.state = .on
                break
            case .topHalf:
                self.topHalfFullRadio.state = .on
                break
            case .bottomHalf:
                self.topHalfFullBottomRadio.state = .on
                break
            }
        }
    }
    
    func _topAreaRadioDidClicked(sender:NSButton){
        
        
        
        self.topFullRadio.state = .off
        self.topHalfFullRadio.state = .off
        self.topHalfFullBottomRadio.state = .off
        
        sender.state = .on
        if sender == topFullRadio{
            DFAreaSizeHelper.helper.saveTopAreaSize(value: .full)
        }else if sender == topHalfFullRadio{
            DFAreaSizeHelper.helper.saveTopAreaSize(value: .topHalf)
        }else if sender == topHalfFullBottomRadio{
            DFAreaSizeHelper.helper.saveTopAreaSize(value: .bottomHalf)
        }
    }
    
    
    func setupBottomAreaSize()  {
        self.bottomFullRadio.state = .off
        self.bottomHalfFullRadio.state = .off
        self.bottomHalfFullBottomRadio.state = .off
        if let size = DFAreaSizeHelper.helper.getBottomAreaSize(){
            let bottomSize = size
            switch bottomSize {
            case .full:
                self.bottomFullRadio.state = .on
                break
            case .topHalf:
                self.bottomHalfFullRadio.state = .on
                break
            case .bottomHalf:
                self.bottomHalfFullBottomRadio.state = .on
                break
            }
        }
    }
    
    func _bottomAreaRadioDidClicked(sender:NSButton){
        
      
        
        
        self.bottomFullRadio.state = .off
        self.bottomHalfFullRadio.state = .off
        self.bottomHalfFullBottomRadio.state = .off
        
        sender.state = .on
        if sender == bottomFullRadio{
            DFAreaSizeHelper.helper.saveBottomAreaSize(value: .full)
        }else if sender == bottomHalfFullRadio{
            DFAreaSizeHelper.helper.saveBottomAreaSize(value: .topHalf)
        }else if sender == bottomHalfFullBottomRadio{
            DFAreaSizeHelper.helper.saveBottomAreaSize(value: .bottomHalf)
        }
    }
}
