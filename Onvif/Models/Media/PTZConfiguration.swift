//
//  File.swift
//  
//
//  Created by Johannes Bergman on 2021-04-20.
//

import Foundation
import SWXMLHash

public struct PTZConfiguration : XMLObjectDeserialization {
    public let token: String
    public let name: String
    public let useCount: Int
    public let nodeToken: String
    public let defaultPtzTimeout: String?
    public let panTiltLimits: Space2DDescription?
    public let zoomLimits: Space1DDescription?
    
    public let defaultAbsolutePantTiltPositionSpace: String?
    public let defaultAbsoluteZoomPositionSpace: String?
    public let defaultRelativePanTiltTranslationSpace: String?
    public let defaultRelativeZoomTranslationSpace: String?
    public let defaultContinuousPanTiltVelocitySpace: String?
    public let defaultContinuousZoomVelocitySpace: String?
    
    public static func deserialize(_ node: XMLIndexer) throws -> PTZConfiguration {
        return try PTZConfiguration(
            token: node.value(ofAttribute: "token"),
            name: node["Name"].value(),
            useCount: node["UseCount"].value(),
            nodeToken: node["NodeToken"].value(),
            defaultPtzTimeout: try? node["DefaultPTZTimeout"].value(),
            panTiltLimits: try? node["PanTiltLimits"].value(),
            zoomLimits: try? node["ZoomLimits"].value(),
            defaultAbsolutePantTiltPositionSpace: try? node["DefaultAbsolutePantTiltPositionSpace"].value(),
            defaultAbsoluteZoomPositionSpace: try? node["DefaultAbsoluteZoomPositionSpace"].value(),
            defaultRelativePanTiltTranslationSpace: try? node["DefaultRelativePanTiltTranslationSpace"].value(),
            defaultRelativeZoomTranslationSpace: try? node["DefaultRelativeZoomTranslationSpace"].value(),
            defaultContinuousPanTiltVelocitySpace: try? node["DefaultContinuousPanTiltVelocitySpace"].value(),
            defaultContinuousZoomVelocitySpace: try? node["DefaultContinuousZoomVelocitySpace"].value()
        )
    }
}
