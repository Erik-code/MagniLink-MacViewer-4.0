//
//  File.swift
//  
//
//  Created by Johannes Bergman on 2021-04-23.
//

import Foundation
import SWXMLHash

public struct VideoEncoderOptionsExtension : XMLObjectDeserialization {
    public let h264: H264Options2?
    
    public static func deserialize(_ node: XMLIndexer) throws -> VideoEncoderOptionsExtension {
        return try VideoEncoderOptionsExtension(
            h264: node["H264"].value()
        )
    }
}
