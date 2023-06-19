//
//  File.swift
//  
//
//  Created by Johannes Bergman on 2021-04-20.
//

import Foundation
import SWXMLHash

public struct VideoRateControl : XMLIndexerDeserializable {
    public let frameRateLimit: Int
    public let encodingInterval: Int
    public let bitrateLimit: Int
    
    public static func deserialize(_ node: XMLIndexer) throws -> VideoRateControl {
        return try VideoRateControl(
            frameRateLimit: node["FrameRateLimit"].value(),
            encodingInterval: node["EncodingInterval"].value(),
            bitrateLimit: node["BitrateLimit"].value()
        )
    }
}

