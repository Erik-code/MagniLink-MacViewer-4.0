//
//  File.swift
//  
//
//  Created by Johannes Bergman on 2021-04-06.
//

import Foundation
import SWXMLHash

public struct VideoResolution : XMLObjectDeserialization {
    public let width: Int
    public let height: Int
    
    public static func deserialize(_ node: XMLIndexer) throws -> VideoResolution {
        return try VideoResolution(
            width: node["Width"].value(),
            height: node["Height"].value()
        )
    }
}

