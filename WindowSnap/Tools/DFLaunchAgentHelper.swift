//
//  DFLaunchAgentHelper.swift
//  WindowSnap
//
//  Created by raymond on 2020/12/30.
//

import Foundation
import DFAXUIElement

class DFLaunchAgentHelper {
    static var launchAgentDirectory: URL? {
        let libDir = try? FileManager.default.url(for: .libraryDirectory,
                                                  in: .userDomainMask,
                                                  appropriateFor: nil,
                                                  create: false)
        return libDir?.appendingPathComponent("LaunchAgents")
    }
    
    
    static var launchAgentFile: URL? {
        
        if let bundleIdentifier = DFNSRunningApplicaitonHelper.curApplication().bundleIdentifier{
            return launchAgentDirectory?.appendingPathComponent(bundleIdentifier)
        }
        return nil
    }

    static func add() {
        guard let launchAgentDirectory = launchAgentDirectory else {
            DFLogHelper.log(message: "Error: could not access launch agent directory")
            print("Error: could not access launch agent directory")
            return
        }

        guard let launchAgentFile = launchAgentFile else {
            DFLogHelper.log(message: "Error: could not access launch agent file")
            print("Error: could not access launch agent file")
            return
        }

        if (launchAgentDirectory as NSURL).checkResourceIsReachableAndReturnError(nil) == false {
            _ = try? FileManager.default.createDirectory(at: launchAgentDirectory,
                                                         withIntermediateDirectories: false,
                                                         attributes: nil)
        }

        guard let execPath = Bundle.main.executablePath else {
            return
        }
        
        if let bundleIdentifier = DFNSRunningApplicaitonHelper.curApplication().bundleIdentifier{
            let plist: NSDictionary = [
                "Label": bundleIdentifier,
                "Program": execPath,
                "RunAtLoad": true
            ]
            plist.write(to: launchAgentFile, atomically: true)
        }
    }

    static func remove() {
        _ = try? FileManager.default
            .removeItem(at: launchAgentFile!)
    }

    static func enabled() -> Bool {
       
        let reachable = (launchAgentFile as NSURL?)?.checkResourceIsReachableAndReturnError(nil)
        return reachable ?? false
    }
}

