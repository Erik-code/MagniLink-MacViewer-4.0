//
//  File.swift
//  
//
//  Created by Johannes Bergman on 2021-04-21.
//

import Foundation

internal extension String {
    func toLicense() -> License? {
        let licenseInformation = self.split(separator: "_")
        
        if licenseInformation.count == 3 &&
            licenseInformation.first == "LVI" &&
            licenseInformation[1].count == 6 &&
            licenseInformation[2].count == 1 {
            
            return License(serialNumber: licenseInformation[1].description, productId: licenseInformation[2].description)
        }
        
        return nil
    }
}
