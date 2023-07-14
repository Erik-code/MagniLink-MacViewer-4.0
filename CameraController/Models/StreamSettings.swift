//
//  File.swift
//  
//
//  Created by Johannes Bergman on 2021-04-23.
//

import Foundation

@objcMembers public class Resolution : NSObject {
    public private(set) var width: Int
    public private(set) var height: Int
    
    private override init() {
        self.width = 0
        self.height = 0
        
        super.init()
    }
    
    public convenience init(width: Int, height: Int) {
        self.init()
        
        self.width = width
        self.height = height
    }
}

@objcMembers public class ResolutionSetting : NSObject {
    public private(set) var resolution: Resolution
    public private(set) var supportedResolutions: [Resolution]
    
    private override init() {
        self.resolution = Resolution(width: 0, height: 0)
        self.supportedResolutions = [Resolution]()
        
        super.init()
    }
    
    public convenience init(resolution: Resolution, supportedResolutions: [Resolution]) {
        self.init()
        
        self.resolution = resolution
        self.supportedResolutions = supportedResolutions
    }
}

@objcMembers public class H264ProfileSetting : NSObject {
    public private(set) var h264Profile: String
    public private(set) var supportedH264Profiles: [String]
    
    private override init() {
        self.h264Profile = ""
        self.supportedH264Profiles = [String]()
        super.init()
    }
    
    public convenience init(h264Profile: String, supportedH264Profiles: [String]) {
        self.init()
        
        self.h264Profile = h264Profile
        self.supportedH264Profiles = supportedH264Profiles
    }
}

@objcMembers public class StreamSettings : NSObject {
    public private(set) var quality: IntSetting!
    public private(set) var govLength: IntSetting!
    public private(set) var frameRate: IntSetting!
    public private(set) var bitRate: IntSetting!
    public private(set) var resolution: ResolutionSetting!
    public private(set) var h264Profile: H264ProfileSetting!
    
    private override init() {
        /*self.quality = IntSetting(value: 0, min: 0, max: 0)
        self.govLength = IntSetting(value: 0, min: 0, max: 0)
        self.frameRate = IntSetting(value: 0, min: 0, max: 0)
        self.bitRate = IntSetting(value: 0, min: 0, max: 0)
        self.resolution = ResolutionSetting(resolution: Resolution(width: 0, height: 0), supportedResolutions: [Resolution]())
        self.h264Profile = H264ProfileSetting(h264Profile: "", supportedH264Profiles: [String]())*/
        
        super.init()
    }
    
    public convenience init(quality: IntSetting,
                            govLength: IntSetting,
                            frameRate: IntSetting,
                            bitRate: IntSetting,
                            resolution: ResolutionSetting!,
                            h264Profile: H264ProfileSetting) {
        self.init()
        
        self.quality = quality
        self.govLength = govLength
        self.frameRate = frameRate
        self.bitRate = bitRate
        self.resolution = resolution
        self.h264Profile = h264Profile
    }
}
