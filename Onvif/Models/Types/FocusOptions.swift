//
//  File.swift
//  
//
//  Created by Johannes Bergman on 2021-04-23.
//

import Foundation
import SWXMLHash

public struct FocusOptions : XMLObjectDeserialization {
    public let focusModes: [String]
    public let defaultSpeed: FloatRange?
    public let nearLimit: FloatRange?
    public let farLimit: FloatRange?
    
    public static func deserialize(_ node: XMLIndexer) throws -> FocusOptions {
        return try FocusOptions(
            focusModes: node["AutoFocusModes"].value(),
            defaultSpeed: node["DefaultSpeed"].value(),
            nearLimit: node["NearLimit"].value(),
            farLimit: node["FarLimit"].value()
        )
    }
}
