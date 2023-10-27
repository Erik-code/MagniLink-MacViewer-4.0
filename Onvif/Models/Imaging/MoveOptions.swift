//
//  File.swift
//  
//
//  Created by Johannes Bergman on 2021-04-23.
//

import Foundation
import SWXMLHash

public struct MoveOptions : XMLObjectDeserialization {
    public let continuous: ContinuousFocusOptions?
    
    public static func deserialize(_ node: XMLIndexer) throws -> MoveOptions {
        return try MoveOptions(
            continuous: node["Continuous"].value()
        )
    }
}

public struct ContinuousFocusOptions : XMLObjectDeserialization {
    public let speed: FloatRange
    
    public static func deserialize(_ node: XMLIndexer) throws -> ContinuousFocusOptions {
        return try ContinuousFocusOptions(
            speed: node["Speed"].value()
        )
    }
}

/*
 
 <Envelope>
    <Body>
       <GetMoveOptionsResponse>
          <MoveOptions>
             <Continuous>
                <Speed>
                   <Min>-7</Min>
                   <Max>7</Max>
                </Speed>
             </Continuous>
          </MoveOptions>
       </GetMoveOptionsResponse>
    </Body>
 </Envelope>
 
 */
