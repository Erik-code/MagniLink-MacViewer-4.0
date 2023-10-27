//
//  PhotoCapture.swift
//  MagniLink MacViewer 4.0
//
//  Created by Erik Sandstrom on 2023-10-27.
//

import Foundation
import AVFoundation
import Photos

class PhotoCaptureProcessor: NSObject {
    private(set) var requestedPhotoSettings: AVCapturePhotoSettings
    
//    private let willCapturePhotoAnimation: () -> Void
    
    private let livePhotoCaptureHandler: (Bool) -> Void
    
    private let completionHandler: (PhotoCaptureProcessor) -> Void
    
//    var onDeviceTextRecognizer : VisionTextRecognizer?
    
    private var photoData: Data?
    
    private var livePhotoCompanionMovieURL: URL?
    
    public var resultText : String?
    
    var mCameraViewController: CamerasViewController?
    
//    lazy var vision = Vision.vision()
    
    init(with requestedPhotoSettings: AVCapturePhotoSettings,
         viewController : CamerasViewController,
         livePhotoCaptureHandler: @escaping (Bool) -> Void,
         completionHandler: @escaping (PhotoCaptureProcessor) -> Void)
    {
        self.mCameraViewController = viewController
        self.requestedPhotoSettings = requestedPhotoSettings
        self.livePhotoCaptureHandler = livePhotoCaptureHandler
        self.completionHandler = completionHandler
    }
    
    private func didFinish() {
       
        completionHandler(self)
    }
}

extension PhotoCaptureProcessor: AVCapturePhotoCaptureDelegate {

    func photoOutput(_ output: AVCapturePhotoOutput, willBeginCaptureFor resolvedSettings: AVCaptureResolvedPhotoSettings) {
//        if resolvedSettings.livePhotoMovieDimensions.width > 0 && resolvedSettings.livePhotoMovieDimensions.height > 0 {
//            livePhotoCaptureHandler(false)
//        }
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, willCapturePhotoFor resolvedSettings: AVCaptureResolvedPhotoSettings) {
//        willCapturePhotoAnimation()
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        if let error = error {
            print("Error capturing photo: \(error)")
        } else {
            
            photoData = photo.fileDataRepresentation()
            
            let nsImage = NSImage(data: photoData!)
            print("CREATING A UIImage: \(nsImage!.size.width),\(nsImage!.size.height)")
         
            mCameraViewController!.imageTaken(aImage: nsImage!, pixels: nil)
        }
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishCaptureFor resolvedSettings: AVCaptureResolvedPhotoSettings, error: Error?) {
        if let error = error {
            print("Error capturing photo: \(error)")
            didFinish()
            return
        }
    }
}
