//
//  CameraManager.swift
//  MagniLink MacViewer 4.0
//
//  Created by Erik Sandstrom on 2023-06-19.
//

import Foundation

protocol CameraManagerDelegate
{
    func cameraAdded(manager : CameraManager)
    func cameraRemoved(manager : CameraManager)
}

class CameraManager
{
    var mVideoControllers : [CameraBaseViewController] = []
    var delegates = [CameraManagerDelegate]()
    var mSplit = SplitTwo()
    
    init()
    {
        
    }
    
    func count() -> Int
    {
        return mVideoControllers.count
    }
    
    func addController(controller : CameraBaseViewController)
    {
        mVideoControllers.append(controller)
        for delegate in delegates {
            delegate.cameraAdded(manager: self)
        }
    }
    
    func removeController(controller : CameraBaseViewController)
    {
        mVideoControllers.append(controller)
        for delegate in delegates {
            delegate.cameraRemoved(manager: self)
        }
    }
    
//    var availableFunctions : Set<CameraFunctions>
//    {
//        get{
//            var result = Set<CameraFunctions>()
//            
//            for v in mVideoControllers {
//                result = result.union(v.availableFunctions)
//            }
//            return result
//        }
//    }
    
    var currentCamera : CameraBaseViewController
    {
        get{
            return mVideoControllers[mSplit.active]
        }
    }
    
    var mRecordingTimer : Timer?
    func toggleVideoRecording()
    {
//        if Preferences.shared.limitRecording
//        {
//            mRecordingTimer = Timer.scheduledTimer(timeInterval: TimeInterval(Preferences.shared.recordingLength * 60), target: self, selector: #selector(fireRecordingTimer(_:)), userInfo: nil, repeats: false)
//        }
//        
//        for controller in mVideoControllers {
//            
//            if controller.isRecording() {
//                controller.toggleRecording()
//                mRecordingTimer?.invalidate()
//                mRecordingTimer = nil
//                return
//            }
//        }
//        
//        currentCamera.toggleRecording()
    }
    
    @objc func fireRecordingTimer(_ timer: Timer)
    {
        if mRecordingTimer != nil {
            mRecordingTimer?.invalidate()
            mRecordingTimer = nil
            toggleVideoRecording()
        }
    }
}

