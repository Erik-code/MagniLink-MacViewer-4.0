//
//  ViewController.swift
//  MagniLink MacViewer 4.0
//
//  Created by Erik Sandstrom on 2023-06-19.
//

import Cocoa

class MainViewController: NSViewController, KeyHandlerDelegate, RibbonDelegate {
    
    var mCameraViewController : CamerasViewController?
    var mKeyhandler = KeyHandler()
    var mRibbon : MyRibbonView?
    //let mRibbonHeight : CGFloat = 154
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mKeyhandler.delegate = self
        mKeyhandler.load()
        
        mCameraViewController = CamerasViewController()
        mCameraViewController?.mMainViewController = self
    }
    
    override func viewDidAppear() {
        self.addChild(mCameraViewController!)
        self.view.addSubview(mCameraViewController!.view)
        //view.translatesAutoresizingMaskIntoConstraints = false
        
        //mCameraViewController?.view.frame = self.view.bounds
        
        var frame = self.view.bounds
        frame.origin.y = frame.size.height - 154
        frame.size.height = 154
        
        mRibbon = MyRibbonView(frame: frame)
        guard let ribbon = mRibbon else {
            return
        }
        
        ribbon.setup()
        view.addSubview(ribbon)
        ribbon.autoresizingMask = [.minXMargin, .maxXMargin, .minYMargin, .width]
        scaleRibbon(scale: 1.0)
        ribbon.setAllCameraGroups()
        ribbon.setAllOcrGroups()
        ribbon.delegate = self
        ribbon.translatesAutoresizingMaskIntoConstraints = false
     
//        NSEvent.addLocalMonitorForEvents(matching: .keyDown) {
//            self.keyDown(with: $0)
//            return $0
//        }
//        NSEvent.addLocalMonitorForEvents(matching: .keyUp) {
//            self.keyUp(with: $0)
//            return $0
//        }
        
        becomeFirstResponder()
    }
    
    
    
    override var acceptsFirstResponder: Bool
    {
        get{
            return true
        }
    }
    
    func scaleRibbon(scale : Float)
    {
        mRibbon?.setScale(scale)
        var rect = view.bounds
        rect.size.height -= (mRibbon?.bounds.height)!
        
        var ribbonRect = mRibbon?.frame
        
        print("ribbonRect \(ribbonRect!.height)")
        
        ribbonRect?.origin.y = view.bounds.size.height - (mRibbon?.bounds.size.height)!
        mRibbon?.frame = ribbonRect!
    }
    
    override func viewDidLayout() {
        
        var frame = self.view.bounds
        var ribbonRect = mRibbon?.frame
        frame.size.height = frame.size.height - (mRibbon?.bounds.size.height)!
        
        mRibbon?.frame = ribbonRect!
        
        mCameraViewController?.view.frame = frame
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    override func keyDown(with event: NSEvent) {
        
        
        guard event.isARepeat == false else {
            return
        }
        
        mKeyhandler.handleKeyDown(key: event)
//        super.keyDown(with: event)
        //mCameraViewController?.mCameraManager.currentCamera.mMetalView.updateUniformsRender()
    }
    
    override func keyUp(with event: NSEvent) {
//        super.keyDown(with: event)
        mKeyhandler.handleKeyUp(key: event)
    }
    
    func performAction(action: Actions) {
        mCameraViewController?.performAction(action: action)
    }
    
// MARK: Ribbon delegates
    
    func handleCameraButtonClicked(_ button: CameraButton, withModifier mod: UInt) {
        switch button {
        case kCamNatural:
            mCameraViewController?.performAction(action: .nextNatural)
        case kCamArtificial:
            mCameraViewController?.performAction(action: .nextArtificial)
        default:
            break
        }
    }
    
    func handleCameraButtonPress(_ button: CameraButton) {
        
    }
    
    func handleCameraButtonRelease(_ button: CameraButton) {
        
    }
        
    func handleVolumeChanged(_ value: Double) {
        
    }
    
    func handleSpeedChanged(_ value: Double) {
        
    }
    
    func handleSettings() {
        
    }
}

