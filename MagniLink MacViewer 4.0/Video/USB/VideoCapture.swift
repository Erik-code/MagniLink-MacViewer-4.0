//
//  VideoCapture.swift
//  MagniLink MacViewer 4.0
//
//  Created by Erik Sandstrom on 2023-06-19.
//

import Foundation
import AVFoundation

class VideoCapture: NSObject, AVCaptureAudioDataOutputSampleBufferDelegate, AVCaptureVideoDataOutputSampleBufferDelegate
{
    var mCameraVideoController: CameraUSBViewController!
    var mCameraBaseViewControllers = [CameraBaseViewController]()
    var mPreviewLayer: AVCaptureVideoPreviewLayer?
    @objc dynamic var mVideoDeviceInput: AVCaptureDeviceInput!
    private let mSession = AVCaptureSession()
    private let mVideoOutput = AVCaptureVideoDataOutput()
    private let sessionQueue = DispatchQueue(label: "camera-queue")
    private let mDataOutputQueue = DispatchQueue(label: "data output queue")
    private var mCameraDevice: AVCaptureDevice!
    private let photoOutput = AVCapturePhotoOutput()
    var mCameraViewController : CamerasViewController?
    private var inProgressLivePhotoCapturesCount = 0
    private var inProgressPhotoCaptureDelegates = [Int64: PhotoCaptureProcessor]()

    public func setup(completion: @escaping (Bool) -> Void)
    {
        mPreviewLayer = AVCaptureVideoPreviewLayer(session: mSession)
        
        sessionQueue.async {
            let success = self.configureSession()
            DispatchQueue.main.async {
                completion(success)
            }
        }
    }
    
    private func configureSession() -> Bool
    {
        mSession.sessionPreset = .photo
        //mSession.beginConfiguration()
        
        self.mPreviewLayer = AVCaptureVideoPreviewLayer(session: mSession)
        self.mPreviewLayer?.connection?.videoOrientation = .landscapeLeft
        self.mPreviewLayer?.videoGravity = .resizeAspectFill
        
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.externalUnknown],
                                                                mediaType: .video, position: .unspecified)

        guard let device = discoverySession.devices.first else {
            return false
        }
        
        mCameraDevice = device
        
        do {
            let cameraInput = try AVCaptureDeviceInput(device: mCameraDevice)
            if mSession.canAddInput(cameraInput) {
                mSession.addInput(cameraInput)
            }
            
            if let connection = mPreviewLayer?.connection, connection.isVideoMirroringSupported {
              connection.automaticallyAdjustsVideoMirroring = false
              connection.isVideoMirrored = true
            }
            
            mVideoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA)]
        
            mVideoOutput.alwaysDiscardsLateVideoFrames = true
            mVideoOutput.setSampleBufferDelegate(self, queue: mDataOutputQueue)
            
            if mSession.canAddOutput(mVideoOutput) {
                mSession.addOutput(mVideoOutput)
            }
            
            mPreviewLayer?.frame = CGRect(x: 0, y: 0, width: 12, height: 7)
            mCameraVideoController.view.superview!.layer = mPreviewLayer
            
            addPhotoCapture()
            //mPreviewLayer?.isHidden = true
            //mSession.startRunning()
        }
        catch {
            print("Error")
        }
        //mSession.commitConfiguration()
        
        return true
    }
    
    private func addPhotoCapture() -> Bool
    {
        
        if mSession.canAddOutput(self.photoOutput) {
            mSession.addOutput(self.photoOutput)

            self.photoOutput.isHighResolutionCaptureEnabled = true
            
            if let photoOutputConnection = self.photoOutput.connection(with: AVMediaType.video) {
                photoOutputConnection.videoOrientation = .landscapeLeft
            }

        } else {
            return false
        }
        
        return true
    }
    
    func takePhoto()
    {
        sessionQueue.async
        {
            guard self.photoOutput.connection(with: .video) != nil
            else{
                return
            }
            
            var photoSettings = AVCapturePhotoSettings()
            
            if  self.photoOutput.availablePhotoCodecTypes.contains(.hevc) {
                photoSettings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.hevc])
            }
            
            photoSettings.isHighResolutionPhotoEnabled = true
            
            let photoCaptureProcessor = PhotoCaptureProcessor(with: photoSettings, viewController: self.mCameraViewController!
            , livePhotoCaptureHandler: { capturing in
                /*
                 Because Live Photo captures can overlap, we need to keep track of the
                 number of in progress Live Photo captures to ensure that the
                 Live Photo label stays visible during these captures.
                 */
                self.sessionQueue.async {
                    if capturing {
                        self.inProgressLivePhotoCapturesCount += 1
                    } else {
                        self.inProgressLivePhotoCapturesCount -= 1
                    }
                    
                    _ = self.inProgressLivePhotoCapturesCount
                    DispatchQueue.main.async {
                    }
                }
            }, completionHandler: { photoCaptureProcessor in
                // When the capture is complete, remove a reference to the photo capture delegate so it can be deallocated.
                self.sessionQueue.async {
                    self.inProgressPhotoCaptureDelegates[photoCaptureProcessor.requestedPhotoSettings.uniqueID] = nil
                }
            })
            
            self.inProgressPhotoCaptureDelegates[photoCaptureProcessor.requestedPhotoSettings.uniqueID] = photoCaptureProcessor
            self.photoOutput.capturePhoto(with: photoSettings, delegate: photoCaptureProcessor)
        }
    }
    
    public func start() {
        if !mSession.isRunning {
            DispatchQueue.global(qos: .background).async {
                self.mSession.startRunning()
            }
        }
    }
    
    public func stop() {
        if mSession.isRunning {
            mSession.stopRunning()
        }
    }
    
    public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if let videoDataOutput = output as? AVCaptureVideoDataOutput
        {
            //print("captureOutput")
            self.mCameraVideoController.setSampleBuffer(sampleBuffer: sampleBuffer)
        }
        else if let audioDataOutput = output as? AVCaptureAudioDataOutput
        {
            
        }
    }
}
