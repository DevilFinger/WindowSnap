//
//  DFSimulateKeyEvent.swift
//  WindowSnap
//
//  Created by raymond on 2021/1/12.
//

import Foundation

class DFSimulateKeyEvent {
    
    static func minimizedApplicationAllWindows()  {
        let src : CGEventSource? =  CGEventSource.init(stateID: CGEventSourceStateID.hidSystemState)
        
        let cmdmd :CGEvent? = CGEvent.init(keyboardEventSource: src, virtualKey: 46, keyDown: true)
        let cmdmu :CGEvent? = CGEvent.init(keyboardEventSource: src, virtualKey: 46, keyDown: false)
        
        cmdmd?.flags = CGEventFlags.init(rawValue: CGEventFlags.maskCommand.rawValue | CGEventFlags.maskAlternate.rawValue)
        cmdmu?.flags = CGEventFlags.init(rawValue: CGEventFlags.maskCommand.rawValue | CGEventFlags.maskAlternate.rawValue)
        
        let loc : CGEventTapLocation = .cghidEventTap
        
        cmdmd?.post(tap: loc)
        cmdmu?.post(tap: loc)
    }
    
    static func showDeskTop()  {
        let src : CGEventSource? =  CGEventSource.init(stateID: CGEventSourceStateID.hidSystemState)
        let cmdF11_down :CGEvent? = CGEvent.init(keyboardEventSource: src, virtualKey: 103, keyDown: true)
        let cmdF11_up :CGEvent? = CGEvent.init(keyboardEventSource: src, virtualKey: 103, keyDown: false)
        
        cmdF11_down?.flags = CGEventFlags.init(rawValue: CGEventFlags.maskSecondaryFn.rawValue )
        cmdF11_up?.flags = CGEventFlags.init(rawValue: CGEventFlags.maskSecondaryFn.rawValue )
        
        let loc : CGEventTapLocation = .cghidEventTap
        
        cmdF11_down?.post(tap: loc)
        cmdF11_up?.post(tap: loc)
    }
}
