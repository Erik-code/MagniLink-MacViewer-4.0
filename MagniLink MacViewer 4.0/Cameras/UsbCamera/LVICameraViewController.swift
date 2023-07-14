//
//  LVICameraViewController.swift
//  MagniLink MacViewer 4.0
//
//  Created by Erik Sandstrom on 2023-06-19.
//

import Cocoa

class LVICameraViewController: CameraUSBViewController {

    override var name : String { return "MagniLink" }
    var control : LVICameraControl?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    func setup(videoCapture : VideoCapture)
    {
        mVideoCapture = videoCapture
        mVideoCapture?.mCameraVideoController = self
        
        control = LVICameraControl()
        
        control?.connect(withKeepAliveTime: 0)
    }
    
    override func nextNatural()
    {
        control?.increaseNaturalColors()
    }
    
    override func nextPositive()
    {
        control?.increasePositiveColors()
    }
    
    override func nextNegative()
    {
        control?.increaseNegativeColors()

    }
    
}
