//
//  DFMouseAreaHelper.swift
//  WindowSnap
//
//  Created by raymond on 2021/1/13.
//

import Foundation

enum DFMouseArea : String {
    case top = "DFMouseAreaTop"
    case bottom = "DFMouseAreaBottom"
    case left = "DFMouseAreaLeft"
    case right = "DFMouseAreaRight"
    case leftTop = "DFMouseAreaLeftTop"
    case leftBottom = "DFMouseAreaLeftBottom"
    case rightTop = "DFMouseAreaRightTop"
    case rightBottom = "DFMouseAreaRightBottom"
}

class DFMouseAreaHelper{
    
    static let helper = DFMouseAreaHelper()
    
    func setupAll() {
        setup(area: .top)
        setup(area: .bottom)
        setup(area: .left)
        setup(area: .right)
        setup(area: .leftTop)
        setup(area: .leftBottom)
        setup(area: .rightTop)
        setup(area: .rightBottom)
    }
    
    func setup(area:DFMouseArea) {
        let standard = UserDefaults.standard
        let obj = standard.object(forKey: area.rawValue)
        if obj == nil{
            saveAreaIsEnable(area: area, value: true)
        }
    }
    
    func getAreaIsEnable(area:DFMouseArea) -> Bool{
        
        let standard = UserDefaults.standard
        if let obj = standard.object(forKey: area.rawValue){
            return obj as! Bool
        }
        return true
    }
    
    func saveAreaIsEnable(area:DFMouseArea, value:Bool)  {
        UserDefaults.standard.setValue(value, forKey: area.rawValue)
        UserDefaults.standard.synchronize()
    }
}
