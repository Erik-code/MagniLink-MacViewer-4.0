//
//  ViewController.swift
//  MagniLink MacViewer 4.0
//
//  Created by Erik Sandstrom on 2023-06-19.
//

import Cocoa

class MainViewController: NSViewController, KeyHandlerDelegate {
    

    var mCameraViewController : CamerasViewController?
    var mKeyhandler = KeyHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mKeyhandler.delegate = self
        mKeyhandler.load()
        
        mCameraViewController = CamerasViewController()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear() {
        self.addChild(mCameraViewController!)
        self.view.addSubview(mCameraViewController!.view)
                
        mCameraViewController?.view.frame = self.view.bounds
        
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) {
            self.keyDown(with: $0)
            return $0
        }
        NSEvent.addLocalMonitorForEvents(matching: .keyUp) {
            self.keyUp(with: $0)
            return $0
        }
        
        becomeFirstResponder()
    }
    
    override var acceptsFirstResponder: Bool
    {
        get{
            return true
        }
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    override func keyDown(with event: NSEvent) {
        mKeyhandler.handleKeyDown(key: event)
    }
    
    override func keyUp(with event: NSEvent) {
        mKeyhandler.handleKeyUp(key: event)
    }
    
    func performAction(action: Actions) {
        mCameraViewController?.performAction(action: action)
    }
}

