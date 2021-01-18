//
//  DFAreaSizeHelper.swift
//  WindowSnap
//
//  Created by raymond on 2021/1/13.
//

import Foundation


let DFTopAreaSizeKey = "DFTopAreaSizeKey"
enum DFTopAreaSize : String {
    case full = "DFTopAreaFullSreceenSize"
    case topHalf = "DFTopAreaTopHalfSize"
    case bottomHalf = "DFTopAreaBottomHalfSize"
}

let DFBottomAreaSizeKey = "DFBottomAreaSizeKey"
enum DFBottomAreaSize : String {
    case full = "DFBottomAreaFullSreceenSize"
    case topHalf = "DFBottomAreaTopHalfSize"
    case bottomHalf = "DFBottomAreaBottomHalfSize"
}


class DFAreaSizeHelper{
    
    static let helper = DFAreaSizeHelper()
    
    func setupTopAreaSize() {
        let standard = UserDefaults.standard
        let obj = standard.object(forKey:DFTopAreaSizeKey)
        if obj == nil{
            saveTopAreaSize(value: .topHalf)
        }
    }
    
    func getTopAreaSize() -> DFTopAreaSize?{
        
        let standard = UserDefaults.standard
        if let obj = standard.object(forKey: DFTopAreaSizeKey){
            let objStr = obj as! String
            return DFTopAreaSize.init(rawValue: objStr)
        }
        return DFTopAreaSize.topHalf
    }
    
    func saveTopAreaSize(value:DFTopAreaSize)  {
        UserDefaults.standard.setValue(value.rawValue, forKey: DFTopAreaSizeKey)
        UserDefaults.standard.synchronize()
    }
    
    
    func setupBottomAreaSize() {
        let standard = UserDefaults.standard
        let obj = standard.object(forKey:DFBottomAreaSizeKey)
        if obj == nil{
            saveBottomAreaSize(value: .bottomHalf)
        }
    }
    
    func getBottomAreaSize() -> DFBottomAreaSize?{
        
        let standard = UserDefaults.standard
        if let obj = standard.object(forKey: DFBottomAreaSizeKey){
            let objStr = obj as! String
            return DFBottomAreaSize.init(rawValue: objStr)
        }
        return DFBottomAreaSize.bottomHalf
    }
    
    func saveBottomAreaSize(value:DFBottomAreaSize)  {
        UserDefaults.standard.setValue(value.rawValue, forKey: DFBottomAreaSizeKey)
        UserDefaults.standard.synchronize()
    }
}
