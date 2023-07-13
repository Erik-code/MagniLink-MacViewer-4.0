//
//  CameraAirViewController.swift
//  MagniLink MacViewer 4.0
//
//  Created by Erik Sandstrom on 2023-06-19.
//

import Cocoa

class CameraAirViewController: CameraBaseViewController {

    var mGStreamer : GStreamerBackend?
    var mVideoCapture : VideoCapture?
    var mAirCameraController : AirCameraController?
    var mCameraController : CameraController?
    var mSerial : String = ""
    var mProductId : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    func parseToken(profileToken : String?)
    {
        if let token = profileToken
        {
            let arr = token.split(separator: "_")
            if arr.count >= 3 {
                mSerial = String(arr[1])
                mProductId = String(arr[2])
            }
        }
    }
    
    func setVideoStruct(aVideo : VideoStruct)
    {
        mMetalView.setVideoStruct(aVideo: aVideo)
    }
    
    @objc func gstreamerInitialized(_ aBackend: GStreamerBackend!) {
        DispatchQueue.main.async {
            aBackend.play()
            //self.isRunning = true
        }
    }
    
    @objc func gstreamerExitedMainLoop(_ aBackend: GStreamerBackend!)
    {
        DispatchQueue.main.async
        {
            print("gstreamerExitedMainLoop")
        }
    }
    
    @objc func gstreamerSetUIMessage(_ aMessage : String)
    {
        print("gstreamerSetUIMessage: \(aMessage)")
    }
    
}
