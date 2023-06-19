//
//  File.swift
//  
//
//  Created by Johannes Bergman on 2021-04-20.
//

import Foundation
import SWXMLHash

public struct FloatRange : XMLIndexerDeserializable {
    public let min: Float
    public let max: Float
    
    public static func deserialize(_ node: XMLIndexer) throws -> FloatRange {
        return try FloatRange(
            min: node["Min"].value(),
            max: node["Max"].value()
        )
    }
}

