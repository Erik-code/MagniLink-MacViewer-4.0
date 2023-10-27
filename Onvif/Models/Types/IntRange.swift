//
//  File.swift
//  
//
//  Created by Johannes Bergman on 2021-04-23.
//

import Foundation
import SWXMLHash

public struct IntRange : XMLObjectDeserialization {
    public let min: Int
    public let max: Int
    
    public static func deserialize(_ node: XMLIndexer) throws -> IntRange {
        return try IntRange(
            min: node["Min"].value(),
            max: node["Max"].value()
        )
    }
}

