//
//  File.swift
//  
//
//  Created by Johannes Bergman on 2021-04-26.
//

import Foundation
import SWXMLHash

public struct PTZStatus : XMLObjectDeserialization {
    public let position: PTZVector?
    public let moveStatus: PTZMoveStatus?
    public let error: String?
    public let utcTime: String
    
    public static func deserialize(_ node: XMLIndexer) throws -> PTZStatus {
        return try PTZStatus(
            position: node["Position"].value(),
            moveStatus: node["MoveStatus"].value(),
            error: node["Error"].value(),
            utcTime: node["UtcTime"].value()
        )
    }
}

/*
 <Envelope>
    <Body>
       <GetStatusResponse>
          <PTZStatus>
             <Position>
                <PanTilt x="-0.555500" y="-0.790889" space="http://www.onvif.org/ver10/tptz/PanTiltSpaces/PositionGenericSpace" />
                <Zoom space="http://www.onvif.org/ver10/tptz/ZoomSpaces/PositionGenericSpace" x="0.000000" />
             </Position>
             <MoveStatus>
                <PanTilt>IDLE</PanTilt>
                <Zoom>IDLE</Zoom>
             </MoveStatus>
             <Error>NO error</Error>
             <UtcTime>2021-04-26T07:39:55Z</UtcTime>
          </PTZStatus>
       </GetStatusResponse>
    </Body>
 </Envelope>
 */
