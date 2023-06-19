//
//  File.swift
//  
//
//  Created by Erik Sandstrom on 2021-11-19.
//

import Foundation
import SWXMLHash

public struct PTZPreset : XMLIndexerDeserializable {
    public let token: String
    public let name: String
    public let ptzPosition : PTZVector
    
    public static func deserialize(_ node: XMLIndexer) throws -> PTZPreset {
        return try PTZPreset(
            token: node.value(ofAttribute: "token"),
            name: node["Name"].value(),
            ptzPosition : node["PTZPosition"].value()
        )
    }
}

