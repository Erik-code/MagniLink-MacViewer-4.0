//
//  File.swift
//  
//
//  Created by Johannes Bergman on 2021-04-23.
//

import Foundation

@objcMembers public class FloatSetting : NSObject {
    public private(set) var value: Float
    public private(set) var min: Float
    public private(set) var max: Float
    
    private override init() {
        self.value = 0
        self.min = 0
        self.max = 0
        
        super.init()
    }
    
    public convenience init(value: Float, min: Float, max: Float) {
        self.init()
        
        self.value = value
        self.min = min
        self.max = max
    }
}
