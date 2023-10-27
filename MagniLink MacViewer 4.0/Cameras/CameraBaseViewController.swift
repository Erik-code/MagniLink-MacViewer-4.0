//
//  CameraBaseViewController.swift
//  MagniLink MacViewer 4.0
//
//  Created by Erik Sandstrom on 2023-06-19.
//

import Cocoa
import AVFoundation

protocol CameraBaseViewControllerDelegate
{
    func imageTaken(aImage: NSImage, pixels : [UInt8]?)
    //func cameraLost(camera : CameraBaseViewController)
    //func valueChanged(text : String)
    //func propertyChanged(action : Actions)
}

class CameraBaseViewController: NSViewController, MetalViewDelegate {
    
    var delegate : CameraBaseViewControllerDelegate?
    
    var mMetalView : MetalView!
    private var mStartRecordingTime = CFTimeInterval()
    private var mStartRecordingTimeFromAudio = CMTime()
    let recordingQueue = DispatchQueue(label: "recording queue") // Communicate with the session and other session objects on this queue.
    private var mVideoRecorder : VideoRecorder! = nil
    
    var name : String { preconditionFailure() }
    var Id : CameraType
    {
        /*preconditionFailure("This method must be overridden")*/
        return .MagniLink
    }
    
    override func loadView() {
        view = MetalView()
        guard let mv = view as? MetalView else {
            return
        }
        mv.setup()
        mMetalView = view as? MetalView
        mMetalView.myDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    func takePicture() {}
    
// MARK: Recording
    func isRecording() -> Bool
    {
        guard let recorder = mVideoRecorder else {
            return false
        }
        return recorder.isRecording
    }
    
    func toggleRecording()
    {
        self.mMetalView.toggleRecording()
        if self.mVideoRecorder == nil
        {
            let url = URL(fileURLWithPath: "/Users/eriksandstrom/Desktop/MetalMovie.mov")
            var audioSettings : [String : Any]? = nil
            let transform = self.getVideoTransform()
            
            recordingQueue.async {
                
                self.mVideoRecorder = VideoRecorder(outputURL: url, size: self.getVideoSize(), audioSettings: audioSettings, transform: transform)!
                
                self.mStartRecordingTime = CACurrentMediaTime()
                self.mStartRecordingTimeFromAudio = CMTimeMakeWithSeconds(self.mStartRecordingTime, preferredTimescale: 240)
                
                self.mVideoRecorder.startRecording(startTime: self.mStartRecordingTimeFromAudio)
            }
        }
        else{
            recordingQueue.async {
                self.mVideoRecorder.endRecording {
                    print("Recording ended")
                    self.mVideoRecorder = nil
                }
            }
        }
    }
    
    func recordImage(texture: MTLTexture) 
    {
        if mVideoRecorder != nil
        {
            //recordingQueue.async {
                let frameTime = CACurrentMediaTime() - self.mStartRecordingTime
                let presentationTime = CMTimeMakeWithSeconds(frameTime, preferredTimescale: 240)
                let newtime = CMTimeAdd(self.mStartRecordingTimeFromAudio, presentationTime)
                self.mVideoRecorder.writeFrame(forTexture: texture, time: newtime)
            //}
        }
    }
    
    func getVideoSize() -> CGSize
    {
        return CGSize(width: 1280, height: 720)
    }
    
    func getVideoTransform() -> CGAffineTransform
    {
        return .init(rotationAngle: CGFloat.pi)
    }
    
    func nextNatural()
    {
        guard let camera = EUCModel.shared.cameras.first(where:{ $0.name == name }) else {
            return
        }
        
        let grayscale = camera.nextNatural()
        mMetalView.setNatural(grayscale: grayscale)
    }
    
    func nextPositive()
    {
        guard let camera = EUCModel.shared.cameras.first(where:{ $0.name == name }) else {
            return
        }
        guard let colors = camera.nextPositive() else {
            return
        }
        
        mMetalView.setArtificial(backColor: colors.backColor, foreColor: colors.foreColor)
    }
    
    func nextNegative()
    {
        guard let camera = EUCModel.shared.cameras.first(where:{ $0.name == name }) else {
            return
        }
        guard let colors = camera.nextNegative() else {
            return
        }
        
        mMetalView.setArtificial(backColor: colors.backColor, foreColor: colors.foreColor)
    }
    
    func nextArtificial()
    {
        guard let camera = EUCModel.shared.cameras.first(where:{ $0.name == name }) else {
            return
        }
        guard let colors = camera.nextArtificial() else {
            return
        }
        
        mMetalView.setArtificial(backColor: colors.backColor, foreColor: colors.foreColor)
    }
    
    var mZoomTimer : Timer?
    func zoom(aDirection: CameraControlZoomDirection)
    {
        if aDirection != .stop && mZoomTimer == nil
        {
            mZoomTimer = Timer.scheduledTimer(timeInterval: 0.032, target: self, selector: #selector(fireZoomTimer(_:)), userInfo: aDirection, repeats: true)
        }
        else
        {
            mZoomTimer?.invalidate()
            mZoomTimer = nil
        }
    }
    
    @objc func fireZoomTimer(_ timer: Timer)
    {
//        let dir = timer.userInfo as! CameraControlZoomDirection
//        var zoom = mMetalView.getZoom()
//        zoom *= dir == .inn ? 1.05 : 1 / 1.05
//
//        zoom = zoom > maxZoom ? maxZoom : zoom
//        zoom = zoom < minZoom ? minZoom : zoom
//
//        zoomHelp(value: zoom)
    }
}
