//
//  File.swift
//  
//
//  Created by Johannes Bergman on 2021-04-15.
//

import Foundation
import SWXMLHash

public struct SoapFault  : XMLObjectDeserialization{
    public let code: String
    public let subcode: String
    public let detail: String?
    
    public static func deserialize(_ node: XMLIndexer) throws -> SoapFault {
        print(node["Code"]["Subcode"]["Value"].description)
        print(node["Reason"]["Text"].description)
        print(node["Detail"]["Text"].description)
        
        return try SoapFault(
            code: node["Code"]["Subcode"]["Value"].value(),
            subcode: node["Reason"]["Text"].value(),
            detail: try? node["Detail"]["Text"].value()
        )
    }
}

/*
<Envelope>
     <Body>
         <Fault>
             <Code>
                 <Value>SOAP-ENV:Sender</Value>
                 <Subcode>
                    <Value>ter:TagMismatch</Value>
                 </Subcode>
             </Code>
         
            <Reason>
                <Text xml:lang="en">Tag mismatch</Text>
            </Reason>
         
            <Detail>
                <Text>Validation constraint violation: tag name or namespace mismatch in element ProfileToken</Text>
            </Detail>
        </Fault>
     </Body>
 </Envelope>
*/
