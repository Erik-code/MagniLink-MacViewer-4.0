//
//  File.swift
//  
//
//  Created by Johannes Bergman on 2021-04-06.
//

import Foundation
import SWXMLHash

public struct MediaProfile : XMLIndexerDeserializable {
    public let token: String
    public let name: String
    public let fixed: Bool
    
    public let videoSourceConfiguration: VideoSourceConfiguration?
    public let videoEncoderConfiguration: VideoEncoderConfiguration?
    public let ptzConfiguration: PTZConfiguration?
    
    public static func deserialize(_ node: XMLIndexer) throws -> MediaProfile {
        return try MediaProfile(
            token: node.value(ofAttribute: "token"),
            name: node["Name"].value(),
            fixed: node.value(ofAttribute: "fixed"),
            videoSourceConfiguration: try? node["VideoSourceConfiguration"].value(),
            videoEncoderConfiguration: try? node["VideoEncoderConfiguration"].value(),
            ptzConfiguration: try? node["PTZConfiguration"].value()
        )
    }
}


