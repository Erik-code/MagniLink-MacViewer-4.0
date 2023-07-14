//
//  CameraUSBViewController.swift
//  MagniLink MacViewer 4.0
//
//  Created by Erik Sandstrom on 2023-06-20.
//

import Foundation
import AVFoundation
import Cocoa

class CameraUSBViewController: CameraBaseViewController {

    var mVideoCapture : VideoCapture?
    
    
     
    
    func setSampleBuffer(sampleBuffer : CMSampleBuffer!)
    {
        let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)
        //mMetalView.waitSemaphore()
        mMetalView.setPixelBuffer(pixelBuffer: imageBuffer!)
    }
}
