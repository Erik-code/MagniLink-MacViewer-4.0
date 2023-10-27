//
//  File.swift
//  
//
//  Created by Johannes Bergman on 2021-04-23.
//

import Foundation
import SWXMLHash

public struct H264Options2 : XMLObjectDeserialization {
    public let resolutionsAvailable: [VideoResolution]
    public let govLengthRange: IntRange
    public let frameRateRange: IntRange
    public let encodingIntervalRange: IntRange
    public let h264ProfilesSupported: [String]
    public let bitrateRange: IntRange
    
    public static func deserialize(_ node: XMLIndexer) throws -> H264Options2 {
        return try H264Options2(
            resolutionsAvailable: node["ResolutionsAvailable"].value(),
            govLengthRange: node["GovLengthRange"].value(),
            frameRateRange: node["FrameRateRange"].value(),
            encodingIntervalRange: node["EncodingIntervalRange"].value(),
            h264ProfilesSupported: node["H264ProfilesSupported"].value(),
            bitrateRange: node["BitrateRange"].value()
        )
    }
}
