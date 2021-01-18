//
//  DFAppleScript.swift
//  WindowSnap
//
//  Created by raymond on 2021/1/12.
//

import Foundation

class DFAppleScript{
    
    
    static func minimizedAllWindowWithAppleScript(){
        
        let script = """
        tell application "System Events"
            set listOfProcesses to (name of every process where background only is false)
        end tell

        repeat with processName in listOfProcesses
            activate application processName
            tell application "System Events" to keystroke "m" using {command down, option down}
        end repeat
        """
        _ = runAppleScript(script: script)
        
    }
    
    static func runAppleScript(script:String) -> NSDictionary?  {
        
        var error: NSDictionary? = nil
        if let appleScript =  NSAppleScript.init(source: script){
            appleScript.executeAndReturnError(&error)
        }
        print("runAppleScript \(String(describing: error))")
        return error
    }
    
    static func checkApplicationHasAppleScriptPermission(bundleIdentifier:String) -> Dictionary<String, Any> {
        var response = [String:Any]()
        if #available(OSX 10.11, *) {
            let targetAppEventDescriptor = NSAppleEventDescriptor.init(bundleIdentifier: bundleIdentifier)
            if #available(OSX 10.14, *) {
                let status = AEDeterminePermissionToAutomateTarget(targetAppEventDescriptor.aeDesc, typeWildCard, typeWildCard, true)
                switch (status) {
                        case -600: //procNotFound
                            response["isEnabled"] = false
                            response["message"] = "Not running app with id \(bundleIdentifier)"
                            break;

                        case 0: // noErr
                            response["isEnabled"] = true
                            response["message"] = "SIP check successfull for app with id \(bundleIdentifier)"
                            break;

                        case -1744: // errAEEventWouldRequireUserConsent
                            // This only appears if you send false for askUserIfNeeded
                            response["isEnabled"] = false
                            response["message"] = "User consent required for app with id \(bundleIdentifier)"
                            break;

                        case -1743: //errAEEventNotPermitted

                            response["isEnabled"] = false
                            response["message"] = "User didn't allow usage for app with id \(bundleIdentifier)"

                            // Here you should present a dialog with a tutorial on how to activate it manually
                            // This can be something like
                            // Go to system preferences > security > privacy
                            // Choose automation and active [APPNAME] for [APPNAME]
                        default:
                            break;
                    }
            }else{
                response["isEnabled"] = false
                response["message"] = "API not support. API should higher than OSX 10.14"
            }
        }else{
            response["isEnabled"] = false
            response["message"] = "API not support. API should higher than OSX 10.11"
        }
        return response;
    }
    
    private func _createAEDesc() {
        
        var addressDesc:AEAddressDesc = AEDesc()

        let aString:String = "com.apple.finder"
        let aCString = aString.cString(using: String.Encoding.utf8)!
        let length = strlen(aCString)

        let error :OSErr = AECreateDesc(typeApplicationBundleID, aCString, length, &addressDesc)
        print("createAEDesc \(error)")
        
    }
}
