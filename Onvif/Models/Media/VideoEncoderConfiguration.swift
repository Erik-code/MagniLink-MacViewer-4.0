//
//  File.swift
//  
//
//  Created by Johannes Bergman on 2021-04-06.
//

import Foundation
import SWXMLHash

public struct VideoEncoderConfiguration : XMLObjectDeserialization {
    public let token: String
    public let name: String
    public let useCount: Int
    public let encoding: VideoEncoding
    public let resolution: VideoResolution
    public let quality: Float
    public let rateControl: VideoRateControl?
    public let h264: H264Configuration?
    public let multicast: MulticastConfiguration
    public let sessionTimeout: String
    
    public static func deserialize(_ node: XMLIndexer) throws -> VideoEncoderConfiguration {
        return try VideoEncoderConfiguration(
            token: node.value(ofAttribute: "token"),
            name: node["Name"].value(),
            useCount: node["UseCount"].value(),
            encoding: VideoEncoding(rawValue: node["Encoding"].value())!,
            resolution: node["Resolution"].value(),
            quality: node["Quality"].value(),
            rateControl: try? node["RateControl"].value(),
            h264: try? node["H264"].value(),
            multicast: node["Multicast"].value(),
            sessionTimeout: node["SessionTimeout"].value()
        )
    }
}

public struct MulticastConfiguration : XMLObjectDeserialization {
    public let address: IPAddress
    public let port: Int
    public let ttl: Int
    public let autoStart: Bool
    
    public static func deserialize(_ node: XMLIndexer) throws -> MulticastConfiguration {
        return try MulticastConfiguration(
            address: node["Address"].value(),
            port: node["Port"].value(),
            ttl: node["TTL"].value(),
            autoStart: node["AutoStart"].value()
        )
    }
}

public struct IPAddress : XMLObjectDeserialization {
    public let type: String
    public let ipV4Address: String?
    public let ipV6Address: String?
    
    public static func deserialize(_ node: XMLIndexer) throws -> IPAddress {
        return try IPAddress(
            type: node["Type"].value(),
            ipV4Address: node["IPv4Address"].value(),
            ipV6Address: node["IPv6Address"].value()
        )
    }
}

/*
 <Multicast>
     <Address>
         <Type>IPv4</Type>
         <IPv4Address>0.0.0.0</IPv4Address>
     </Address>
     <Port>8860</Port>
     <TTL>128</TTL>
     <AutoStart>false</AutoStart>
 </Multicast>
 <SessionTimeout>PT5S</SessionTimeout>
 */
