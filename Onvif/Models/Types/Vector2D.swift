//
//  File.swift
//  
//
//  Created by Johannes Bergman on 2021-04-26.
//

import Foundation
import SWXMLHash

public struct Vector2D : XMLObjectDeserialization {
    public let space: String?
    public let x: Float
    public let y: Float
    
    public static func deserialize(_ node: XMLIndexer) throws -> Vector2D {
        return try Vector2D(
            space: node.value(ofAttribute: "space"),
            x: node.value(ofAttribute: "x"),
            y: node.value(ofAttribute: "y")
        )
    }
}
