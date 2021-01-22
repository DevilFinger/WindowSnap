//
//  AppDelegate.swift
//  WindowSnap
//
//  Created by raymond on 2020/12/30.
//

import Cocoa

import AVFoundation
import ApplicationServices.HIServices.Processes
import DFAXUIElement
import MASShortcut

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {
    
    var statusItem: NSStatusItem?
    
    var coverFloatWin : NSWindow?
    
    var aboutWindow : NSWindow?
    
    var helpWindow : NSWindow?
    
    @IBOutlet weak var menu: NSMenu!
    
    @IBOutlet weak var launchAtLoginMenu: NSMenuItem!
    @IBOutlet weak var aboutMenu: NSMenuItem!
    @IBOutlet weak var helpMenu: NSMenuItem!
    @IBOutlet weak var shortcutSettingMenu: NSMenuItem!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItem?.button?.title = "WindowSnap"
        
        let itemImage = NSImage(named: "SplitScreen")
        itemImage?.isTemplate = true
        statusItem?.button?.image = itemImage
        
        if let menu = menu {
            statusItem?.menu = menu
            //menu.delegate = self
        }
        
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        DFShortCutViewController.regiseterAllWithDefault()
        DFMouseAreaHelper.helper.setupAll()
        DFAreaSizeHelper.helper.setupTopAreaSize()
        DFAreaSizeHelper.helper.setupBottomAreaSize()
        
        launchAtLoginMenu.state = DFLaunchAgentHelper.enabled() ? .on : .off
        let _ = NSEvent.addGlobalMonitorForEvents(matching: [.leftMouseUp, .leftMouseDown, .leftMouseDragged]) {
            (event : NSEvent) in
            
            DFMouseMonitorManger.shared.moniter(event: event)
            
        }
        let isShowHelp : Bool? =  UserDefaults.standard.object(forKey: "HelpIsShow") as? Bool
        if let isShow =  isShowHelp  {
            if isShow{
                _ = AXUIElement.askForAccessibilityIfNeeded()
            }else{
                helpMenuItemDidClicked(nil)
            }

        }else{
            helpMenuItemDidClicked(nil)
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
        
    }
    
    @objc
    @IBAction func toggleRunAtLogin(_ sender: NSMenuItem) {
        if sender.state == .on {
            DFLaunchAgentHelper.remove()
            sender.state = .off
        } else {
            DFLaunchAgentHelper.add()
            sender.state = .on
        }
    }
    
    @IBAction func aboutMenuItemDidClicked(_ sender: Any?) {
        
        if let window = aboutWindow{
            window.close()
            aboutWindow = nil
        }
        
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateController(withIdentifier: .init(stringLiteral: "DFAboutViewControllerID")) as? DFAboutViewController else { return }
        let window = NSWindow(contentViewController: vc)
        window.makeKeyAndOrderFront(sender)
        window.styleMask.remove(NSWindow.StyleMask.miniaturizable)
        window.styleMask.remove(NSWindow.StyleMask.resizable)
        window.styleMask.remove(NSWindow.StyleMask.fullScreen)
        window.level = .floating
        
        window.title = "About WindowSnap"
        
        var centerX : CGFloat = 0.0
        var centerY : CGFloat = 0.0
        let width : CGFloat = 450.0
        let height : CGFloat = 350.0
        
        if let screen = window.screen {
            centerX = screen.frame.midX - width / 2.0
            centerY = screen.frame.midY - height / 2.0
        }
        
        window.setFrame(CGRect.init(x: centerX, y: centerY, width: width, height: height), display:true)
        aboutWindow = window
    }
    
    
    @IBAction func helpMenuItemDidClicked(_ sender: Any?) {
        
        if let win = helpWindow {
            win.close()
            helpWindow = nil
        }
        
        if let window = initWindow(controllerId: "DFHelpViewControllerID"){
            window.makeKeyAndOrderFront(sender)
            window.styleMask.remove(NSWindow.StyleMask.miniaturizable)
            window.styleMask.remove(NSWindow.StyleMask.resizable)
            window.styleMask.remove(NSWindow.StyleMask.fullScreen)
            window.level = .floating
            window.title = "How to use WindowSnap"
            window.delegate = self
            
            var centerX : CGFloat = 0.0
            var centerY : CGFloat = 0.0
            let width : CGFloat = 732.0
            let height : CGFloat = 800.0
            
            if let screen = window.screen {
                centerX = screen.frame.midX - width / 2.0
                centerY = screen.frame.midY - height / 2.0
            }
            
            window.setFrame(CGRect.init(x: centerX, y: centerY, width: width, height: height), display:true)
        }else {
            print("error")
        }
        
    }
    
    @IBAction func showDeskTopMenuItemDidClicked(_ sender: Any) {
        DFSimulateKeyEvent.showDeskTop()
        
    }
    
    @IBAction func minimizedAllWindowMenuItemDidClicked(_ sender: Any) {
        DFAppleScript.minimizedAllWindowWithAppleScript()
    }
    
    @IBAction func shortcutSettingMenuItemDidClicked(_ sender: Any) {
        if let window = initWindow(controllerId: "DFShortCutViewControllerID"){
            window.makeKeyAndOrderFront(sender)
            window.styleMask.remove(NSWindow.StyleMask.miniaturizable)
            window.styleMask.remove(NSWindow.StyleMask.resizable)
            window.styleMask.remove(NSWindow.StyleMask.fullScreen)
            window.level = .floating
            window.title = "Setting"
            var centerX : CGFloat = 0.0
            var centerY : CGFloat = 0.0
            let width : CGFloat = 600.0
            let height : CGFloat = 728.0
            
            if let screen = window.screen {
                centerX = screen.frame.midX - width / 2.0
                centerY = screen.frame.midY - height / 2.0
            }
            
            window.setFrame(CGRect.init(x: centerX, y: centerY, width: width, height: height), display:true)
        }
    }
    
    func initWindow(controllerId:String) -> NSWindow? {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateController(withIdentifier: .init(stringLiteral: controllerId)) as? NSViewController else {
            print("initWindow error")
            return nil
        }
        let window = NSWindow(contentViewController: vc)
        return window;
    }
    
    func windowWillClose(_ notification: Notification) {
        _ = AXUIElement.askForAccessibilityIfNeeded()
    }
    
}


