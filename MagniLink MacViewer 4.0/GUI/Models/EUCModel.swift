//
//  EUCModel.swift
//  MagniLink Viewer
//
//  Created by Erik Sandstrom on 2023-03-07.
//

import Foundation

class EUCModel: ObservableObject
{
    @Published var cameras = [CameraColorModel]()
    @Published var current : Int = 0
    
    static let shared = EUCModel()
    var mWidth : CGFloat = 100
    
    private init()
    {
    }
    
    var currentColors : [ColorModel]
    {
        get{
            if current < cameras.count {
                return cameras[current].colors
            }
            else {
                return [ColorModel]()
            }
        }
    }
    
    var currentCamera : CameraColorModel
    {
        get{
            if current < cameras.count {
                return cameras[current]
            }
            else {
                return CameraColorModel(name: "Foo", colors: [ColorModel]())
            }
        }
        set (newval){
            if let index = cameras.firstIndex(of: newval)
            {
                current = index
            }
        }
    }
    
    func setDelegate(delegate : ColorModelDelegate)
    {
        for i in cameras {
            for j in i.colors {
                j.delegate = delegate
            }
        }
    }
    
    func addFromSettings(names : [String])
    {
        for name in names
        {
            let camera = CameraColorModel.createForCameraFromSettings(name: name)
            if cameras.contains(camera) == false {
                cameras.append(camera)
            }
        }
        cameras.sort { cam1, cam2 in
            EUCModel.sortHelp(model: cam1) < EUCModel.sortHelp(model: cam2)
        }
    }
    
    static func sortHelp(model : CameraColorModel) -> Int
    {
        switch model.name {
        case "OCR":
            return 5
        case "Front":
            return 0
        case "Back":
            return 1
        case "TAB":
            return 2
        case "MagniLink":
            return 2
        default:
            return 10
        }
    }
    
    static func createFromSettings(names : [String]) -> CameraModel
    {
        var cameras = [CameraColorModel]()

        for name in names
        {
            let camera = CameraColorModel.createForCameraFromSettings(name: name)
            cameras.append(camera)
        }
                
        let model = CameraModel.shared
        //model.cameras = cameras
        //model.current = 0
        model.frontCamera = Preferences.shared.frontCamera
        model.backCamera = Preferences.shared.backCamera
        
        return model
    }
    
    func saveToSettings()
    {
        for camera in cameras
        {
            if camera.name != "MagniLink" {
                camera.saveToSettings()
            }
        }
    }
}
