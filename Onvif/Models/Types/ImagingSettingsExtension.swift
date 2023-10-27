//
//  File.swift
//  
//
//  Created by Johannes Bergman on 2021-04-23.
//

import Foundation
import SWXMLHash

public struct ImagingSettingsExtension : XMLObjectDeserialization {
    public let imageStabilization: ImageStabilization?
    
    public static func deserialize(_ node: XMLIndexer) throws -> ImagingSettingsExtension {
        return try ImagingSettingsExtension(
            imageStabilization: node["ImageStabilization"].value()
        )
    }
}


public struct ImageStabilization : XMLObjectDeserialization {
    public let mode: String
    
    public static func deserialize(_ node: XMLIndexer) throws -> ImageStabilization {
        return try ImageStabilization(
            mode: node["Mode"].value()
        )
    }
}

