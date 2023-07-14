//
//  File.swift
//  
//
//  Created by Johannes Bergman on 2021-04-23.
//

import Foundation

@objcMembers public class FocusSetting : NSObject {
    public private(set) var focusMode: String
    public private(set) var supportedFocusModes: [String]
    public private(set) var minSpeed: Float
    public private(set) var maxSpeed: Float
    
    private override init() {
        focusMode = ""
        supportedFocusModes = [String]()
        minSpeed = 0
        maxSpeed = 0
        
        super.init()
    }
    
    public convenience init(focusMode: String, supportedFocusModes: [String], minSpeed: Float, maxSpeed: Float) {
        self.init()
        
        self.focusMode = focusMode
        self.supportedFocusModes = supportedFocusModes
        self.minSpeed = minSpeed
        self.maxSpeed = maxSpeed
    }
}

@objcMembers public class CameraSettings : NSObject {
    public private(set) var brightness: FloatSetting!
    public private(set) var contrast : FloatSetting!
    public private(set) var saturation: FloatSetting!
    public private(set) var sharpness: FloatSetting!
    public private(set) var focus: FocusSetting!
    
    private override init() {
        super.init()
    }
    
    public convenience init(brightness: FloatSetting,
                            contrast: FloatSetting,
                            saturation: FloatSetting,
                            sharpness: FloatSetting,
                            focus: FocusSetting) {
        self.init()
        
        self.brightness = brightness
        self.contrast = contrast
        self.saturation = saturation
        self.sharpness = sharpness
        self.focus = focus
    }
}
