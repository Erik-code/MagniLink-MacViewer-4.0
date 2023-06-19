//
//  File.swift
//  
//
//  Created by Johannes Bergman on 2021-04-26.
//

import Foundation
import SWXMLHash

public struct PTZVector : XMLIndexerDeserializable {
    public let panTilt: Vector2D
    public let zoom: Vector1D
    
    public static func deserialize(_ node: XMLIndexer) throws -> PTZVector {
        return try PTZVector(
            panTilt: node["PanTilt"].value(),
            zoom: node["Zoom"].value()
        )
    }
}
