//
//  File.swift
//  
//
//  Created by Johannes Bergman on 2021-04-20.
//

import Foundation
import SWXMLHash

public struct VideoSourceConfiguration : XMLObjectDeserialization {
    public let token: String
    public let name: String
    public let useCount: Int
    public let sourceToken: String
    public let bounds: Bounds
    
    public static func deserialize(_ node: XMLIndexer) throws -> VideoSourceConfiguration {
        return try VideoSourceConfiguration(
            token: node.value(ofAttribute: "token"),
            name: node["Name"].value(),
            useCount: node["UseCount"].value(),
            sourceToken: node["SourceToken"].value(),
            bounds: node["Bounds"].value()
        )
    }
}
