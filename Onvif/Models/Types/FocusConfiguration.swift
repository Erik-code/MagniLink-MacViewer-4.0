//
//  File.swift
//  
//
//  Created by Johannes Bergman on 2021-04-23.
//

import Foundation
import SWXMLHash

public struct FocusConfiguration : XMLIndexerDeserializable {
    public let focusMode: String
    public let defaultSpeed: Float?
    public let nearLimit: Float?
    public let farLimit: Float?
    
    public static func deserialize(_ node: XMLIndexer) throws -> FocusConfiguration {
        return try FocusConfiguration(
            focusMode: node["AutoFocusMode"].value(),
            defaultSpeed: node["DefaultSpeed"].value(),
            nearLimit: node["NearLimit"].value(),
            farLimit: node["FarLimit"].value()
        )
    }
}
