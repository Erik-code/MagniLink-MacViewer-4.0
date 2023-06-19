//
//  File.swift
//  
//
//  Created by Johannes Bergman on 2021-04-20.
//

import Foundation
import SWXMLHash

public struct Space1DDescription : XMLIndexerDeserializable {
    public let uri: String
    public let xRange: FloatRange
    
    public static func deserialize(_ node: XMLIndexer) throws -> Space1DDescription {
        return try Space1DDescription(
            uri: node["Range"]["URI"].value(),
            xRange: node["Range"]["XRange"].value()
        )
    }
}
