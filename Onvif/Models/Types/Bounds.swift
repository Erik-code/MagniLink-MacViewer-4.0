//
//  File.swift
//  
//
//  Created by Johannes Bergman on 2021-04-20.
//

import Foundation
import SWXMLHash

public struct Bounds : XMLIndexerDeserializable {
    public let x: Int
    public let y: Int
    public let width: Int
    public let height: Int
    
    public static func deserialize(_ node: XMLIndexer) throws -> Bounds {
        return try Bounds(
            x: node.value(ofAttribute: "x"),
            y: node.value(ofAttribute: "y"),
            width: node.value(ofAttribute: "width"),
            height: node.value(ofAttribute: "height")
        )
    }
}
