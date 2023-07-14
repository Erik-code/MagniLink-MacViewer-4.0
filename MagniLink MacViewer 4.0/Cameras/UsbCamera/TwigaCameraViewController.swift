//
//  TwigaCameraViewController.swift
//  MagniLink MacViewer 4.0
//
//  Created by Erik Sandstrom on 2023-06-19.
//

import Cocoa

class TwigaCameraViewController: CameraUSBViewController {

    override var name : String { return "TAB" }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.green.cgColor
    }
    
    func setup(videoCapture : VideoCapture)
    {
        mVideoCapture = videoCapture
        mVideoCapture?.mCameraVideoController = self
    }
}
