//
//  File.swift
//  
//
//  Created by Johannes Bergman on 2021-04-22.
//

import Foundation

public extension MediaProfile {
    func isConfiguredProperly() -> Bool {
        return self.videoEncoderConfiguration != nil && self.videoSourceConfiguration != nil && self.ptzConfiguration != nil
    }
}
