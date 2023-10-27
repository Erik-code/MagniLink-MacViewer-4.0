//
//  File.swift
//  
//
//  Created by Johannes Bergman on 2021-04-26.
//

import Foundation
import SWXMLHash

public struct Vector1D : XMLObjectDeserialization {
    public let space: String?
    public let x: Float
    
    public static func deserialize(_ node: XMLIndexer) throws -> Vector1D {
        return try Vector1D(
            space: node.value(ofAttribute: "space"),
            x: node.value(ofAttribute: "x")
        )
    }
}
