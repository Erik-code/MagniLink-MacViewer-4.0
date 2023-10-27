//
//  File.swift
//  
//
//  Created by Johannes Bergman on 2021-04-01.
//

import Foundation
import SWXMLHash

public struct BasicInformation : XMLObjectDeserialization  {
    public let manufacturer: String
    public let model: String
    public let firmwareVersion: String
    public let serialNumber: String
    public let hardwareId: String
    
    public static func deserialize(_ node: XMLIndexer) throws -> BasicInformation {
        return try BasicInformation(
            manufacturer: node["Manufacturer"].value(),
            model: node["Model"].value(),
            firmwareVersion: node["FirmwareVersion"].value(),
            serialNumber: node["SerialNumber"].value(),
            hardwareId: node["HardwareId"].value()
        )
    }
}
