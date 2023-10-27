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
    
    func switchCamera() -> Bool
    {
        guard mVideoControllers.count > 1 else {
            return false
        }
        
        if mVideoControllers.count == mSplit.videos.count
        {
            mSplit.active = (mSplit.active + 1) % mVideoControllers.count
        }
        else{
            if mSplit.active == mSplit.videos[0]
            {
                mSplit.active = mSplit.videos[1];
            }
            else
            {
                mSplit.active = mSplit.videos[0];
            }
        }
        return true
    }
    
    func toggleVideoRecording()
    {
        for controller in mVideoControllers 
        {
            if controller.isRecording() {
                controller.toggleRecording()
                return
            }
        }
        currentCamera.toggleRecording()
    }    
}

