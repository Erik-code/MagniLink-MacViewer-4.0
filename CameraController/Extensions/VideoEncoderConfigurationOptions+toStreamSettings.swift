//
//  File.swift
//  
//
//  Created by Johannes Bergman on 2021-04-23.
//

import Foundation

internal extension VideoEncoderConfigurationOptions {
    func toStreamSettings(videoEncoderConfiguration: VideoEncoderConfiguration) -> StreamSettings {
        let quality = IntSetting(value: Int(videoEncoderConfiguration.quality), min: self.qualityRange.min, max: self.qualityRange.max)
        
        let govLength = IntSetting(value: videoEncoderConfiguration.h264?.govLength ?? 0, min: self.h264?.govLengthRange.min ?? 0, max: self.h264?.govLengthRange.max ?? 0)
        
        let frameRate = IntSetting(value: videoEncoderConfiguration.rateControl?.frameRateLimit ?? 0, min: self.h264?.frameRateRange.min ?? 0, max: self.h264?.frameRateRange.max ?? 0);
        
        let bitrate = IntSetting(value: videoEncoderConfiguration.rateControl?.bitrateLimit ?? 0, min: self.videoEncoderOptionsExtension?.h264?.bitrateRange.min ?? 0, max: self.videoEncoderOptionsExtension?.h264?.bitrateRange.max ?? 0)
        
        let resolution = ResolutionSetting(resolution: Resolution(width: videoEncoderConfiguration.resolution.width, height: videoEncoderConfiguration.resolution.height), supportedResolutions: self.h264?.resolutionsAvailable.map { resolution in
            return Resolution(width: resolution.width, height: resolution.height)
        } ?? [Resolution]())
        
        let h264Profile = H264ProfileSetting(h264Profile: videoEncoderConfiguration.h264?.h264Profile.rawValue ?? "", supportedH264Profiles: self.h264?.h264ProfilesSupported ?? [String]())
        
        return StreamSettings(quality: quality,
                                 govLength: govLength,
                                 frameRate: frameRate,
                                 bitRate: bitrate,
                                 resolution: resolution,
                                 h264Profile: h264Profile)
    }
}
