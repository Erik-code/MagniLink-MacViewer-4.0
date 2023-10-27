//
//  File.swift
//  
//
//  Created by Johannes Bergman on 2021-04-06.
//

import Foundation
import SWXMLHash

public enum CapabilitiesCategory: String {
    case all = "All"
    case analytics = "Analytics"
    case device = "Device"
    case events = "Events"
    case imaging = "Imaging"
    case media = "Media"
    case ptz = "PTZ"
}

public struct Capabilities : XMLObjectDeserialization {
    public let device: Device?
    public let media: Media?
    public let ptz: PTZ?
    public let imaging: Imaging?

    public static func deserialize(_ node: XMLIndexer) throws -> Capabilities {
        return try Capabilities(
            device: node["Device"].value(),
            media: node["Media"].value(),
            ptz: node["PTZ"].value(),
            imaging: node["Imaging"].value()
        )
    }
}

public struct Device : XMLObjectDeserialization {
    public let xAddr: String

    public static func deserialize(_ node: XMLIndexer) throws -> Device {
        return try Device(xAddr: node["XAddr"].value())
    }
}

public struct Media : XMLObjectDeserialization {
    public let xAddr: String
    
    public static func deserialize(_ node: XMLIndexer) throws -> Media {
        return try Media(xAddr: node["XAddr"].value())
    }
}

public struct PTZ : XMLObjectDeserialization {
    public let xAddr: String
    
    public static func deserialize(_ node: XMLIndexer) throws -> PTZ {
        return try PTZ(xAddr: node["XAddr"].value())
    }
}

public struct Imaging : XMLObjectDeserialization {
    public let xAddr: String
    
    public static func deserialize(_ node: XMLIndexer) throws -> Imaging {
        return try Imaging(xAddr: node["XAddr"].value())
    }
}
