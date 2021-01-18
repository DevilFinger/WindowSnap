//
//  DFMouseMonitorManger.swift
//  WindowSnap
//
//  Created by raymond on 2020/12/28.
//

import Foundation
import Cocoa
import ApplicationServices
import DFAXUIElement

enum DFWindowSnapType : Int {
    case none = 0
    case left = 1
    case right = 2
    case top = 3
    case bottom = 4
    case leftTop = 5
    case leftBottom = 6
    case rightTop = 7
    case rightBottom = 8
}



class DFMouseMonitorManger {
    
    static let shared = DFMouseMonitorManger()
    
    private var curWinNumber : Int? //当前选中Window的windowID 或者 windowNumber
    private var curPID : Int? //当前选中Window的Application的 PID
    private var curAppRef : AXUIElement?//当前选中Window的Application的AXUIElement的
    private var curWindowRef : AXUIElement?//当前选中的Window
    private var curAppWindows: Array<AXUIElement>?//当前选中Window的Application的所有windows的数组
    private var curWindowPosition : CGPoint = CGPoint.zero
    private var curWindowSize : CGSize = CGSize.zero
    private var curWindowRect : CGRect = CGRect.zero
    private var isDragging = false
    private var lastMousePoint :CGPoint = CGPoint.zero
    
    private var originFrame : CGRect?
    
    private var isResizeing = false
    
    private var coverFloatWin : NSWindow?
    
    public func moniter(event:NSEvent) {
        
        switch event.type {
        case .leftMouseUp:
            leftMouseUpLogice(event: event)
        case .leftMouseDragged:
            leftMouseDragLogice(event: event)
        case .leftMouseDown:
            leftMouseDownLogic(event: event)
        default: break
        }
    }
    
    private func leftMouseDownLogic(event:NSEvent)  {
        
        
        
        //因为windowNumber是会变的，会出现在软件自动重启等情况下。
        //所以不能因为windowNumber是一样就不重新获取相关的值
        //所以这里就简单粗暴的每次在鼠标点击下就重置所有属性为nil
        relaseAllParameters()
        
        let winNum = event.windowNumber
        self.curWinNumber = winNum
        
        if let winInfo = DFCGWindowInfoHelper.getCGWindowInfo(windowNumber: winNum, option: CGWindowListOption(rawValue: CGWindowListOption.optionOnScreenOnly.rawValue )){
            let pid = winInfo[kCGWindowOwnerPID as String] as! Int
            self.curPID = pid
            
            if let windows = AXUIElement.application(pid: pid_t(pid)).windows(){
                self.curAppWindows = windows
                for item in windows {
                    let windowRef : AXUIElement = item
                    let windowID = windowRef.windowID()
                    if winNum == windowID{
                        self.curWindowRef = windowRef
                        if let winRef = self.curWindowRef{
                            self.originFrame = winRef.frame()
                        }
                    }
                }
            }
        }
    }
    
    private func leftMouseUpLogice(event:NSEvent) {
        
        if let window = coverFloatWin{
            window.close()
        }
        self.coverFloatWin = nil
        
        if !isDragging || isResizeing{
            relaseAllParameters()
            return
        }
        
        if let curFrame = self.curWindowRef?.frame(), let oriFrame = originFrame{
            if curFrame.equalTo(oriFrame){
                relaseAllParameters()
                return
            }
        }
        if let windowRef = self.curWindowRef {
            isDragging = false
            
            setupCurWindowRect()
            
            let snapType : DFWindowSnapType = getWindowSnapType(event: event)
            
            let screen = getCurScreen(event: event)
            let screenSize = screen.visibleFrame
            
            let resizeRect = getResizeWindowRect(snapType: snapType, screenSize: screenSize)
            if let rc = resizeRect {
                _ = resizeWindowRect(point: rc.origin, size: rc.size, windowRef: windowRef)
            }
        }
        relaseAllParameters()
        
    }
    
    private func leftMouseDragLogice(event:NSEvent) {
        
        isDragging = true
        if isResizeing {
            return
        }
        //todo-list
        //1.需要判断拖动方向，以此来更加精准的判断是分劈到左还是右，上还是下
        //但是现在还没有比较的好方法，暂时不进行判断
        if self.curWindowRef != nil{
            
            if let curFrame = self.curWindowRef?.frame(), let oriFrame = originFrame{
                if curFrame.equalTo(oriFrame){
                    return
                }
            }
            
            let oldSize = self.curWindowSize
            setupCurWindowRect()
            let newSize = self.curWindowSize
            
            if !oldSize.equalTo(CGSize.zero) && !oldSize.equalTo(newSize){
                isResizeing = true
            }
            let snapType : DFWindowSnapType = getWindowSnapType(event: event)
            print("snapType \(snapType)")
            let screen = getCurScreen(event: event)
            
           
            if let coverRect = getCoverWindowRect(snapType: snapType, screenSize: screen.visibleFrame){
                showCoverWindow(snapRect: coverRect,screen: screen)
            }else{
                closeCoverWindow()
            }
        }
        lastMousePoint = event.locationInWindow
    }
    
    
    /// 获取黏贴位置的具体大小,用于浮窗的显示。同时因为mac的坐标系和ios的坐标系是相反的。即从下往上的。而ios是从上往下的
    /// - Parameters:
    ///   - snapType: DFWindowSnapType
    ///   - screenSize: 屏幕的大小
    /// - Returns: 返回黏贴的size和位置
    private func getCoverWindowRect(snapType:DFWindowSnapType, screenSize:CGRect) -> CGRect? {
        
        var origin = CGPoint.zero;
        var size = CGSize.zero;
        
        switch snapType {
        
        case .left:
            origin = CGPoint.init(x: screenSize.minX, y:screenSize.minY)
            size = CGSize.init(width: screenSize.maxX - screenSize.midX, height: screenSize.height)
            return CGRect.init(origin: origin, size: size)
        
        case .right:
            origin = CGPoint.init(x: screenSize.midX, y: screenSize.minY)
            size = CGSize.init(width: screenSize.maxX - screenSize.midX, height: screenSize.height)
            return CGRect.init(origin: origin, size: size)
            
           
        case .top:
            
            if let topAreaSize = DFAreaSizeHelper.helper.getTopAreaSize(){
                switch topAreaSize {
                case .full:
                    origin = CGPoint.init(x: screenSize.minY, y: screenSize.minY)
                    size =  CGSize.init(width: screenSize.width, height: screenSize.height)
                    return CGRect.init(origin: origin, size: size)
                case .topHalf:
                    origin = CGPoint.init(x: screenSize.origin.x, y: screenSize.midY)
                    size =  CGSize.init(width: screenSize.width, height: screenSize.height / 2)
                    return CGRect.init(origin: origin, size: size)
                case .bottomHalf:
                    origin = CGPoint.init(x: screenSize.origin.x, y: screenSize.minY)
                    size =  CGSize.init(width: screenSize.width, height: screenSize.height / 2)
                    return CGRect.init(origin: origin, size: size)
                }
            }else{
                origin = CGPoint.init(x: screenSize.origin.x, y: screenSize.midY)
                size =  CGSize.init(width: screenSize.width, height: screenSize.height / 2)
                return CGRect.init(origin: origin, size: size)
            }
        case .bottom:
            
            if let bottomAreaSize = DFAreaSizeHelper.helper.getBottomAreaSize(){
                switch bottomAreaSize {
                case .full:
                    origin = CGPoint.init(x: screenSize.minY, y: screenSize.minY)
                    size =  CGSize.init(width: screenSize.width, height: screenSize.height)
                    return CGRect.init(origin: origin, size: size)
                case .topHalf:
                    origin = CGPoint.init(x: screenSize.origin.x, y: screenSize.midY)
                    size =  CGSize.init(width: screenSize.width, height: screenSize.height / 2)
                    return CGRect.init(origin: origin, size: size)
                case .bottomHalf:
                    origin = CGPoint.init(x: screenSize.origin.x, y: screenSize.minY)
                    size =  CGSize.init(width: screenSize.width, height: screenSize.height / 2)
                    return CGRect.init(origin: origin, size: size)
                }
            }else{
                origin = CGPoint.init(x: screenSize.origin.x, y: screenSize.minY)
                size =  CGSize.init(width: screenSize.width, height: screenSize.height / 2)
                return CGRect.init(origin: origin, size: size)
            }
        case .leftBottom:
            origin = CGPoint.init(x: screenSize.origin.x, y: 0)
            size = CGSize.init(width: screenSize.width  / 2, height: screenSize.height / 2)
            return CGRect.init(origin: origin, size: size)
        
        case .leftTop:
            origin = CGPoint.init(x: screenSize.origin.x, y: screenSize.midY )
            size = CGSize.init(width: screenSize.width  / 2, height: screenSize.height / 2)
            return CGRect.init(origin: origin, size: size)
            
        case .rightBottom:
            origin = CGPoint.init(x: screenSize.midX, y: 0)
            size = CGSize.init(width: screenSize.width  / 2, height: screenSize.height / 2)
            return CGRect.init(origin: origin, size: size)
            
        case .rightTop:
            origin = CGPoint.init(x: screenSize.midX, y: screenSize.midY)
            size = CGSize.init(width: screenSize.width  / 2, height: screenSize.height / 2)
            return CGRect.init(origin: origin, size: size)
            
        case .none:
            return nil
        }
    }
    
    private func getResizeWindowRect(snapType:DFWindowSnapType, screenSize:CGRect) -> CGRect? {
        
        var origin = CGPoint.zero;
        var size = CGSize.zero;
        
        switch snapType {
        
        case .left:
            origin = CGPoint.init(x: screenSize.minX, y: screenSize.minY)
            size = CGSize.init(width: screenSize.maxX - screenSize.midX, height: screenSize.height)
            return CGRect.init(origin: origin, size: size)
        
        case .right:
            origin = CGPoint.init(x: screenSize.midX, y: screenSize.minY)
            size = CGSize.init(width: screenSize.maxX - screenSize.midX, height: screenSize.height)
            return CGRect.init(origin: origin, size: size)
            
           
        case .top:
            
            if let topAreaSize = DFAreaSizeHelper.helper.getTopAreaSize(){
                switch topAreaSize {
                case .full:
                    origin = CGPoint.init(x: screenSize.minY, y: screenSize.minY)
                    size =  CGSize.init(width: screenSize.width, height: screenSize.height)
                    return CGRect.init(origin: origin, size: size)
                case .topHalf:
                    origin = CGPoint.init(x: screenSize.minX, y: screenSize.minY)
                    size =  CGSize.init(width: screenSize.width, height: screenSize.height / 2)
                    return CGRect.init(origin: origin, size: size)
                case .bottomHalf:
                    origin = CGPoint.init(x: screenSize.minX, y: screenSize.midY)
                    size =  CGSize.init(width: screenSize.width, height: screenSize.height / 2)
                    return CGRect.init(origin: origin, size: size)
                }
            }else{
                origin = CGPoint.init(x: screenSize.minX, y: screenSize.minY)
                size =  CGSize.init(width: screenSize.width, height: screenSize.height / 2)
                return CGRect.init(origin: origin, size: size)
            }
            
        case .bottom:
            
            if let bottomAreaSize = DFAreaSizeHelper.helper.getBottomAreaSize(){
                switch bottomAreaSize {
                case .full:
                    origin = CGPoint.init(x: screenSize.minY, y: screenSize.minY)
                    size =  CGSize.init(width: screenSize.width, height: screenSize.height)
                    return CGRect.init(origin: origin, size: size)
                case .topHalf:
                    origin = CGPoint.init(x: screenSize.minX, y: screenSize.minY)
                    size =  CGSize.init(width: screenSize.width, height: screenSize.height / 2)
                    return CGRect.init(origin: origin, size: size)
                case .bottomHalf:
                    origin = CGPoint.init(x: screenSize.minX, y: screenSize.midY)
                    size =  CGSize.init(width: screenSize.width, height: screenSize.height / 2)
                    return CGRect.init(origin: origin, size: size)
                }
            }else{
                origin = CGPoint.init(x: screenSize.minX, y: screenSize.midY)
                size =  CGSize.init(width: screenSize.width, height: screenSize.height / 2)
                return CGRect.init(origin: origin, size: size)
            }
            
            
            
        case .leftBottom:
            origin = CGPoint.init(x: screenSize.minX, y: screenSize.midY)
            size = CGSize.init(width: screenSize.width  / 2, height: screenSize.height / 2)
            return CGRect.init(origin: origin, size: size)
        
        case .leftTop:
            origin = CGPoint.init(x: screenSize.minX, y: screenSize.minY )
            size = CGSize.init(width: screenSize.width  / 2, height: screenSize.height / 2)
            return CGRect.init(origin: origin, size: size)
            
        case .rightBottom:
            origin = CGPoint.init(x: screenSize.midX, y: screenSize.midY)
            size = CGSize.init(width: screenSize.width  / 2, height: screenSize.height / 2)
            return CGRect.init(origin: origin, size: size)
            
        case .rightTop:
            origin = CGPoint.init(x: screenSize.midX, y: screenSize.minY)
            size = CGSize.init(width: screenSize.width  / 2, height: screenSize.height / 2)
            return CGRect.init(origin: origin, size: size)
            
        case .none:
            return nil
        }
    }
    
    /// 根据windowRef（AXUIElement），更新window的位置和大小
    /// - Parameters:
    ///   - point: window的位置
    ///   - size: window的大小
    ///   - windowRef: window的AXUIElement
    /// - Returns: 返回两个错误值，一个是point是否设置成功，一个是size是否设置成功
    private func resizeWindowRect(point:CGPoint,size:CGSize,windowRef:AXUIElement) -> (AXError,AXError) {
        
        let pointResult = windowRef.setPosition(point: point)
        let sizeReuslt = windowRef.setSize(size: size)
        
        return (pointResult, sizeReuslt)
    }
    
    
//    private func resizeWindowRef{
//
//        let leftBottomRc = CGRect.init(origin: CGPoint.init(x: screenRc.minX, y: screenRc.minY), size: size)
//        let leftTopRc = CGRect.init(origin: CGPoint.init(x: screenRc.minX, y: screenRc.maxY - size.height), size: size)
//        let rightBottomRc = CGRect.init(origin: CGPoint.init(x: screenRc.maxX - size.width, y: screenRc.minY), size: size)
//        let rightTopRc = CGRect.init(origin: CGPoint.init(x: screenRc.maxX - size.width, y: screenRc.maxY - size.height), size: size)
//
//    }
    
    
    /// 根据当前鼠标的位置，获取需要黏贴的位置
    /// - Parameter event: 鼠标事件
    /// - Returns: 返回DFWindowSnapType
    private func getWindowSnapType(event:NSEvent) -> DFWindowSnapType {
        
        //let type = getWindowDragDirctionType(event: event)
        let screenRc = getCurScreen(event: event).visibleFrame
        let mousePoint = event.locationInWindow
        
        let size = CGSize.init(width: 100, height: 100)
        
        let leftBottomRc = CGRect.init(origin: CGPoint.init(x: screenRc.minX, y: screenRc.minY), size: size)
        let leftTopRc = CGRect.init(origin: CGPoint.init(x: screenRc.minX, y: screenRc.maxY - size.height), size: size)
        let rightBottomRc = CGRect.init(origin: CGPoint.init(x: screenRc.maxX - size.width, y: screenRc.minY), size: size)
        let rightTopRc = CGRect.init(origin: CGPoint.init(x: screenRc.maxX - size.width, y: screenRc.maxY - size.height), size: size)
        
        if leftBottomRc.contains(mousePoint){
            
            if DFMouseAreaHelper.helper.getAreaIsEnable(area: .leftBottom){
                return DFWindowSnapType.leftBottom
            }else{
                return DFWindowSnapType.none
            }
            
        }else if leftTopRc.contains(mousePoint){
            
            if DFMouseAreaHelper.helper.getAreaIsEnable(area: .leftTop){
                return DFWindowSnapType.leftTop
            }else{
                return DFWindowSnapType.none
            }
            
        }else if rightBottomRc.contains(mousePoint){
            
            if DFMouseAreaHelper.helper.getAreaIsEnable(area: .rightBottom){
                return DFWindowSnapType.rightBottom
            }else{
                return DFWindowSnapType.none
            }
            
        }else if rightTopRc.contains(mousePoint){
            
            if DFMouseAreaHelper.helper.getAreaIsEnable(area: .rightTop){
                return DFWindowSnapType.rightTop
            }else{
                return DFWindowSnapType.none
            }
            
        }else if mousePoint.x <= screenRc.minX{
            
            if DFMouseAreaHelper.helper.getAreaIsEnable(area: .left){
                return DFWindowSnapType.left
            }else{
                return DFWindowSnapType.none
            }
            
        }else if mousePoint.x  >= screenRc.maxX - CGFloat(2.0){
            
            if DFMouseAreaHelper.helper.getAreaIsEnable(area: .right){
                return DFWindowSnapType.right
            }else{
                return DFWindowSnapType.none
            }
            
        }else if mousePoint.y >=  screenRc.maxY{
            
            if DFMouseAreaHelper.helper.getAreaIsEnable(area: .top){
                return DFWindowSnapType.top
            }else{
                return DFWindowSnapType.none
            }
            
        }else if mousePoint.y <=  screenRc.minY + CGFloat(2.0){
            
            if DFMouseAreaHelper.helper.getAreaIsEnable(area: .bottom){
                return DFWindowSnapType.bottom
            }else{
                return DFWindowSnapType.none
            }
            
        }else{
            return .none
        }
    }
    
    
    /// 根据鼠标事件，获取当前是在哪个屏幕（多屏幕适应）
    /// - Parameter event: 鼠标事件
    /// - Returns: 正在操作的屏幕
    private func getCurScreen(event:NSEvent) -> NSScreen  {
        var targetScreen : NSScreen = NSScreen.main!
        
        if NSScreen.screens.count > 1 {
            for screen in NSScreen.screens {
                //NSScreen提供了一种方法(visibleframe)，从屏幕大小中减去菜单和Dock。
                //frame方法同时包含两者。
                //[NSStatusBar system​Status​Bar].thickness将返回菜单栏的高度。
                let screenRc = screen.visibleFrame
                if screenRc.contains(event.locationInWindow) {
                    targetScreen = screen
                    break
                }
            }
        }
        return targetScreen
    }
    
    
    /// 设置和更新当前的全局属性，会更新当前窗体的position、size、rect
    private func setupCurWindowRect() {
        if let windowRef = self.curWindowRef{
            let position = windowRef.position()
            let size = windowRef.size()
            self.curWindowPosition = position ?? CGPoint.zero
            self.curWindowSize = size ?? CGSize.zero
            self.curWindowRect = CGRect.init(origin: self.curWindowPosition, size: self.curWindowSize)
        }
    }
    
    
    /// 展示cover window
    /// - Parameters:
    ///   - snapRect: 需要黏贴的区域
    ///   - screen: 需要显示的屏幕
    private func showCoverWindow(snapRect:CGRect, screen:NSScreen)  {
        
        if let window = coverFloatWin{
            
            window.setFrame(snapRect, display:true)
        }else{
            let window = NSWindow(contentRect: snapRect, styleMask: NSWindow.StyleMask.borderless, backing: NSWindow.BackingStoreType.buffered, defer: true, screen: screen)
            window.makeKeyAndOrderFront(nil)
            window.styleMask.remove(NSWindow.StyleMask.borderless)
            window.styleMask.remove(NSWindow.StyleMask.titled)
            window.styleMask.remove(NSWindow.StyleMask.miniaturizable)
            window.styleMask.remove(NSWindow.StyleMask.closable)
            window.styleMask.remove(NSWindow.StyleMask.resizable)
            window.styleMask.remove(NSWindow.StyleMask.fullScreen)
            window.backgroundColor = NSColor.blue.withAlphaComponent(0.2)
            window.level = .floating
            window.setFrame(snapRect, display:true)
            window.isReleasedWhenClosed = false
            coverFloatWin = window
        }
    }
    
    
    /// 关闭cover window
    private func closeCoverWindow()  {
        
        if let window = coverFloatWin{
            window.close()
        }
        self.coverFloatWin = nil
    }
    
    
    /// 释放所有当前的资源
    private func relaseAllParameters() {
        self.curWinNumber = nil
        self.curPID = nil
        self.curAppRef = nil
        self.curWindowRef = nil
        self.curAppWindows = nil
        self.curWindowPosition = CGPoint.zero
        self.curWindowSize = CGSize.zero
        self.curWindowRect = CGRect.zero
        self.isDragging = false
        self.isResizeing = false
        self.lastMousePoint = CGPoint.zero
        
        if let window = coverFloatWin{
            window.close()
        }
        self.coverFloatWin = nil
    }
    
    
    func snapWindow(snapType:DFWindowSnapType, windowRef:AXUIElement){
        if let screen = NSScreen.main{
            let screenSize = screen.visibleFrame
            if let resizeRect = getResizeWindowRect(snapType: snapType, screenSize: screenSize){
                _ = resizeWindowRect(point: resizeRect.origin, size: resizeRect.size, windowRef: windowRef)
            }
        }
    }
}


//此方法暂时不够科学，所以先不使用

//enum DFMouseDragDirectionType : Int {
//    case DFMouseDragDirectionTypeLeft = 0
//    case DFMouseDragDirectionTypeRight = 1
//    case DFMouseDragDirectionTypeUp = 2
//    case DFMouseDragDirectionTypeDown = 3
//}

//    private func getWindowDragDirctionType(event:NSEvent) -> DFMouseDragDirectionType {
//
//        let point = event.locationInWindow
//        var isVer = true
//        if abs(point.x - lastMousePoint.x) > abs(point.y - lastMousePoint.y) {
//            isVer = false
//        }
//
//        if isVer {
//            if point.y - lastMousePoint.y > 0 {
//                return DFMouseDragDirectionType.DFMouseDragDirectionTypeUp
//            }else{
//                return DFMouseDragDirectionType.DFMouseDragDirectionTypeDown
//            }
//        }else{
//            if point.x - lastMousePoint.x > 0 {
//                return DFMouseDragDirectionType.DFMouseDragDirectionTypeRight
//            }else{
//                return DFMouseDragDirectionType.DFMouseDragDirectionTypeLeft
//            }
//        }
//    }
