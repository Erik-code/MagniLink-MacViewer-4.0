//
//  File.swift
//  
//
//  Created by Johannes Bergman on 2021-04-20.
//

import Foundation
import SWXMLHash

public struct Space2DDescription : XMLIndexerDeserializable {
    public let uri: String
    public let xRange: FloatRange
    public let yRange: FloatRange
    
    public static func deserialize(_ node: XMLIndexer) throws -> Space2DDescription {
        return try Space2DDescription(
            uri: node["Range"]["URI"].value(),
            xRange: node["Range"]["XRange"].value(),
            yRange: node["Range"]["YRange"].value()
        )
    }
}
