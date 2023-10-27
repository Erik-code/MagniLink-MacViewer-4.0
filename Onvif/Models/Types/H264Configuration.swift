//
//  File.swift
//  
//
//  Created by Johannes Bergman on 2021-04-20.
//

import Foundation
import SWXMLHash

public struct H264Configuration : XMLObjectDeserialization {
    public let govLength: Int
    public let h264Profile: H264Profile
    
    public static func deserialize(_ node: XMLIndexer) throws -> H264Configuration {
        return try H264Configuration(
            govLength: node["GovLength"].value(),
            h264Profile: H264Profile(rawValue: node["H264Profile"].value())!
        )
    }
}

