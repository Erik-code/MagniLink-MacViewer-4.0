//
//  File.swift
//  
//
//  Created by Johannes Bergman on 2021-04-26.
//

import Foundation
import SWXMLHash

public struct PTZMoveStatus : XMLObjectDeserialization {
    public let panTilt: String?
    public let zoom: String?
    
    public static func deserialize(_ node: XMLIndexer) throws -> PTZMoveStatus {
        return try PTZMoveStatus(
            panTilt: node["PanTilt"].value(),
            zoom: node["Zoom"].value()
        )
    }
}
