//
//  CameraAirReadingViewController.swift
//  MagniLink MacViewer 4.0
//
//  Created by Erik Sandstrom on 2023-06-19.
//

import Foundation
import Cocoa

class CameraAirReadingViewController: CameraAirViewController {

    private var mManufacturer : String = ""
    override var name : String { return "Air Reading" }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.red.cgColor
    }
    
    func setup(videoCapture : VideoCapture, manufacturer : String)
    {
        guard let metalView = view as? MetalView else {
            return
        }
        mManufacturer = manufacturer

        mVideoCapture = videoCapture
        
//        mVideoCapture?.mCameraVideoController = self
        
        mGStreamer = GStreamerBackend(self, andType: AirReading)
        mGStreamer?.backendCallback = self.setVideoStruct(aVideo:)

        mAirCameraController = AirCameraController()
        Task{
            do {
                mCameraController = try await mAirCameraController?.createAsync(ip: "192.168.101.100")
                mAirCameraController?.mCameraController = mCameraController
                
                parseToken(profileToken: mCameraController?.profileToken)
                
                //AboutModel.shared.setAirInfo(id: mProductId, serial: mSerial)
                
                if let settings = try await mAirCameraController?.getStreamSettingsAsync()
                {
//                    let cm = CameraModel.shared
//                    cm.airDistance = AirCameraModel()
//                    cm.airDistance?.minQuality = settings.quality.min
//                    cm.airDistance?.maxQuality = settings.quality.max
//                    cm.airDistance?.quality = settings.quality.value
//
//                    cm.airDistance?.minFrameRate = settings.frameRate.min
//                    cm.airDistance?.maxFrameRate = settings.frameRate.max
//                    cm.airDistance?.frameRate = settings.frameRate.value
//
//                    cm.airDistance?.availableResolutions = settings.resolution.supportedResolutions
//                    cm.airDistance?.resolution = settings.resolution.resolution
//
//                    cm.airDistance?.mCameraController = self
                }
                                
                let _ = try await mAirCameraController?.configurePresetsAsync()
            }
            catch {
                print("error")
            }
        }
    }
    
}
