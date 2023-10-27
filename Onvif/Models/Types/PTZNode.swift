//
//  File.swift
//  
//
//  Created by Erik Sandstrom on 2021-11-22.
//
import Foundation
import SWXMLHash

public struct PTZNode : XMLObjectDeserialization {
    public let token: String
    public let name: String
    public let maximumNumberOfPresets : Int
    public let homeSupported : String
    
    public static func deserialize(_ node: XMLIndexer) throws -> PTZNode {
        return try PTZNode (
            token: node.value(ofAttribute: "token"),
            name: node["Name"].value(),
            maximumNumberOfPresets: node["MaximumNumberOfPresets"].value(),
            homeSupported: node["HomeSupported"].value()
        )
    }
}
