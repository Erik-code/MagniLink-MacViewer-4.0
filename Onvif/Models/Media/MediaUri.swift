//
//  File.swift
//  
//
//  Created by Johannes Bergman on 2021-04-26.
//

import Foundation
import SWXMLHash

public struct MediaUri : XMLObjectDeserialization {
    public let uri: String
    public let invalidAfterConnect: Bool
    public let invalidAfterReboot: Bool
    public let timeout: String
    
    public static func deserialize(_ node: XMLIndexer) throws -> MediaUri {
        return try MediaUri(
            uri: node["Uri"].value(),
            invalidAfterConnect: node["InvalidAfterConnect"].value(),
            invalidAfterReboot: node["InvalidAfterReboot"].value(),
            timeout: node["Timeout"].value()
        )
    }
}

/*
 
<Envelope>
    <Body>
        <GetStreamUriResponse>
            <MediaUri>
                <Uri>rtsp://192.168.1.200:554/Streaming/Channels/101?transportmode=unicast&profile=LVI_666666_1</Uri>
                <InvalidAfterConnect>false</InvalidAfterConnect>
                <InvalidAfterReboot>false</InvalidAfterReboot>
                <Timeout>PT60S</Timeout>
            </MediaUri>
        </GetStreamUriResponse>
    </Body>
</Envelope>
 
 */
