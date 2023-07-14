//
//  CameraModel.swift
//  MagniLink Viewer
//
//  Created by Erik Sandstrom on 2022-11-04.
//

import Foundation
import AVFoundation

class AirCameraModel: ObservableObject
{
    @Published var minFrameRate = 10
    @Published var maxFrameRate = 60
    @Published var frameRate = 25
    
    @Published var minQuality : Int = 1
    @Published var maxQuality : Int = 6
    @Published var quality : Int = 6
    
    @Published var availableResolutions : [Resolution] = [Resolution]()
    @Published var resolution = Resolution(width: 0, height: 0)
    
    var mSettingsChangedFlag = false
    var mCameraController : CameraAirViewController? = nil
}

class CameraModel: ObservableObject
{
    //@Published var cameras : [CameraColorModel]
    @Published var airDistance : AirCameraModel? = nil
    @Published var airReading : AirCameraModel? = nil

    //@Published var current : Int
    @Published var frontCamera : Bool
    @Published var backCamera : Bool
    @Published var angleCorrection : Bool
    @Published var mPiConnected = false
    @Published var mLviConnected = false
//    @Published var mPiTurnOff : Bool
    @Published var mPiBitrate : Int
    
    var mWidth : CGFloat = 100
    var mMultiCam = true
    
//    var currentColors : [ColorModel]
//    {
//        get{
//            if current < cameras.count {
//                return cameras[current].colors
//            }
//            else {
//                return [ColorModel]()
//            }
//        }
//    }
//
//    var currentCamera : CameraColorModel
//    {
//        get{
//            if current < cameras.count {
//                return cameras[current]
//            }
//            else {
//                return CameraColorModel(name: "Foo", colors: [ColorModel]())
//            }
//        }
//        set (newval){
//            if let index = cameras.firstIndex(of: newval)
//            {
//                current = index
//            }
//        }
//    }
            
    static let shared = CameraModel()
        
    private init() {
        //cameras = [CameraColorModel]()
        //current = 0
        frontCamera = Preferences.shared.frontCamera
        backCamera = Preferences.shared.backCamera
//        mPiTurnOff = Preferences.shared.turnOffPi
        mPiBitrate = Preferences.shared.piBitrate
        angleCorrection = Preferences.shared.angleCorrection
    }
    
    func standard()
    {
        frontCamera = true
        backCamera = true
//        mPiTurnOff = false
        mPiBitrate = 2800000
        angleCorrection = true
        Preferences.shared.frontCamera = frontCamera
        Preferences.shared.backCamera = backCamera
//        Preferences.shared.turnOffPi = mPiTurnOff
        Preferences.shared.piBitrate = mPiBitrate
        Preferences.shared.angleCorrection = angleCorrection
    }
    
//    func setDelegate(delegate : ColorModelDelegate)
//    {
//        for i in cameras {
//            for j in i.colors {
//                j.delegate = delegate
//            }
//        }
//    }
//    
//    func addFromSettings(names : [String])
//    {
//        for name in names
//        {
//            let camera = CameraColorModel.createForCameraFromSettings(name: name)
//            if cameras.contains(camera) == false {
//                cameras.append(camera)
//            }
//        }
//        cameras.sort { cam1, cam2 in
//            CameraModel.sortHelp(model: cam1) < CameraModel.sortHelp(model: cam2)
//        }
//    }
//    
//    static func sortHelp(model : CameraColorModel) -> Int
//    {
//        switch model.name {
//        case "OCR":
//            return 5
//        case "Front":
//            return 0
//        case "Back":
//            return 1
//        case "TAB":
//            return 2
//        case "MagniLink":
//            return 2
//        default:
//            return 10
//        }
//    }
//    
//    static func createFromSettings(names : [String]) -> CameraModel
//    {
//        var cameras = [CameraColorModel]()
//
//        for name in names
//        {
//            let camera = CameraColorModel.createForCameraFromSettings(name: name)
//            cameras.append(camera)
//        }
//                
//        let model = CameraModel.shared
//        model.cameras = cameras
//        model.current = 0
//        model.frontCamera = Preferences.shared.frontCamera
//        model.backCamera = Preferences.shared.backCamera
//        
//        return model
//    }
//    
//    func saveToSettings()
//    {
//        for camera in cameras
//        {
//            if camera.name != "MagniLink" {
//                camera.saveToSettings()
//            }
//        }
//    }
}
